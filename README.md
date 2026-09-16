# awesome-dots

Personal configuration for Ahmed's macOS workstation and NixOS `homepc`.
App settings are symlinked to this live checkout. Pull changes, then reload/restart
the app. Package changes still require Homebrew, Lazy or Nix.

## What manages what

| Component | macOS | NixOS |
| --- | --- | --- |
| Neovim settings | `~/.config/nvim` links to repo | Settings subdirectories/files link to repo; Home Manager generates the launcher |
| Plugins | Lazy; `nvim/lazy-lock.json` | Nix packages and `flake.lock` |
| Servers/formatters | `Brewfile.nvim` | `nvim.nix` |
| Treesitter parsers | Installed by Mac Lazy spec | Nix provides matching parsers; no runtime downloads |
| Ghostty | App installed separately; config symlink | Home Manager installs app and links repo config |
| Zsh, aliases, prompt | Repo symlinks | Repo symlinks declared by Home Manager |
| Git | Shared config symlink + local identity/signing | Same layout |
| Desktop | macOS | Repo Hyprland, Waybar, Wofi directory links |

Neither npm globals, Bun globals nor Mason manages editor dependencies. Projects
still use their own package managers; install project dependencies for local
TypeScript, ESLint and Prettier.

## Repository map

- `script/link-dotfiles`: Mac link installer with preview, backups and Git migration.
- `script/check`: read-only syntax, tool and symlink checks.
- `dotfiles.nix`: NixOS live symlinks.
- `Brewfile.nvim`: Mac editor dependencies, not every Mac application.
- `Brewfile.pi`, `pi.nix`, `pi/`: Pi installation and shared agent configuration.
- `nvim.nix`: Nix editor packages and stable launcher.
- `nvim/options.lua`, `nvim/keymap.lua`, `nvim/lua/shared/`: shared editor behavior.
- `nvim/lua/plugins/`: Mac Lazy installation/loading; references shared settings.
- `nvim/lua/platform_nix.lua`: initialization of Nix-installed plugins.
- `flake.nix`: `homepc` (`x86_64-linux`), Nixpkgs/Home Manager 25.11 inputs.
- `configuration.nix`, `hardware-configuration.nix`: host packages, services and hardware.
- `ghostty/config`: terminal appearance and shell integration.
- `.zshrc`, `.zsh_base.zsh`: shell entry point, functions and zplug setup.
- `.aliases.zsh`, `.p10k.zsh`: aliases and Powerlevel10k preferences.
- `gitconfig`: shared Git preferences; includes `~/.gitconfig.local` last.
- `hypr/`, `waybar/`, `wofi/`: Linux desktop assets. Wallpaper config still expects
  homepc-specific monitors and files under `~/Pictures`.

## macOS installation

Prerequisites: Git, Homebrew, Xcode command-line tools, Ghostty and Hack Nerd Font.
This is not a complete fresh-machine installer. The shell uses rbenv when available;
Mac-specific PATH additions are conditional. `.zshrc` resolves its symlink to find
`.zsh_base.zsh` beside it.

```sh
cd ~/github/awesome-dots
brew bundle --file=Brewfile.nvim --no-upgrade
./script/link-dotfiles          # preview
./script/link-dotfiles --apply  # back up replaced files, then link
```

Links cover Neovim, Ghostty, Zsh, aliases, Powerlevel10k, Git and Pi settings. Correct existing
links are left alone. Backups preserve relative paths under
`~/.local/state/awesome-dots/backups/<timestamp>/`. To undo a replacement, remove the
new link and move the backup to its original path.

Git migration preserves identity, signing and machine-specific settings in
`~/.gitconfig.local` (mode 0600), outside the repository. If both a standalone
`.gitconfig` and `.gitconfig.local` exist, the installer stops before changing files
so you can merge them. Never commit the local file, credentials or backups.

Open Neovim and let plugins/parsers install. The shell may prompt to install zplug
plugins on first launch. Start a new shell after shell changes.

Ghostty also reads files under `~/Library/Application Support/com.mitchellh.ghostty/`,
which can override the XDG config. Check with `ghostty +validate-config`.

## NixOS installation and validation

This flake is for the existing homepc. Review hardware, bootloader, username and
graphics before adapting it. Keep `system.stateVersion` and `home.stateVersion`
tied to installation history.

Keep the checkout at `~/github/awesome-dots`, or change `repo` in `dotfiles.nix` once.
Home Manager uses
[`mkOutOfStoreSymlink`](https://nix-community.github.io/home-manager/usage/dotfiles.html)
to link to this live path. A link may traverse the Nix store, but its final target is
the working checkout rather than a frozen copy.

Neovim's `init.lua` is generated to load Nix plugin paths. Its `lua/`, `options.lua`,
`keymap.lua` and `plugins/` are live links. **Do not symlink the entire Mac `nvim`
directory on NixOS**; it would replace the Nix launcher with Lazy's.

One-time migration on homepc:

1. Back up manually managed destinations listed in `dotfiles.nix` before Home Manager
   takes ownership. Preserve local changes to desktop/shell configs.
2. Run `./script/link-dotfiles --git-only --apply` to preserve existing Git identity
   locally and link shared preferences. On a new machine, populate
   `~/.gitconfig.local` with identity/signing settings before relying on Git commits.
3. Track/stage new repo files: Git-backed flakes omit untracked files.
4. Pin inputs and build without activating:

```sh
nix flake lock
nix build .#nixosConfigurations.homepc.config.home-manager.users.ahmed.programs.neovim.finalPackage -o result-nvim
sudo nixos-rebuild build --flake .#homepc
```

Review and commit `flake.lock`; none was present during this refactor. Lazy's lockfile
does not pin Nix packages. Building the editor alone does not install Home Manager's
launcher or links into your home directory.

After reviewing a successful build, activate deliberately:

```sh
sudo nixos-rebuild switch --flake .#homepc
```

Home Manager may refuse to overwrite existing unmanaged files; back up the named
files and retry. Open a new terminal and run Neovim in a real project. Check `gd`,
completion, ESLint, `,fc`, highlighting, `:checkhealth` and `:messages`.

Roll back a Nix generation with `sudo nixos-rebuild switch --rollback` or an earlier
boot generation. **Nix rollback does not undo live config edits**; restore the intended
Git revision too. Moving/deleting the checkout breaks live links.

## Routine updates

On each machine:

```sh
cd ~/github/awesome-dots
git status --short  # save local edits before pulling
# Once clean:
git pull --ff-only
```

Pushing to GitHub does not update another machine automatically; pull on each one.
Restart Neovim for Lua changes, start a new shell for Zsh changes, reload Ghostty
config, and reload/restart desktop apps as appropriate. Git reads config per command.

Package changes require Homebrew bundle on Mac or a Nix rebuild on homepc. New Mac
plugins require Lazy installation. Changing link destinations in `dotfiles.nix` needs
one activation; editing linked file contents does not. Check plugin/API compatibility
when pulling settings onto a machine with older installed packages.

Update Mac plugins deliberately with `:Lazy update`, test, then commit the lockfile.
Restore a known-good lockfile from Git and run `:Lazy restore` to recover. Update Nix
inputs deliberately, review `flake.lock`, build and test before activation.

## Local checks

Run from any directory:

```sh
~/github/awesome-dots/script/check
~/github/awesome-dots/script/check --repo-only
```

The default checks JSON, Python, shell, Lua and Git syntax, Nix syntax when Nix is
installed, whitespace, required editor tools, live symlink targets, Pi startup and
Ghostty's active config. Neovim runs without your init/plugins; it compiles Lua but
does not execute it. No installs, rebuilds, config changes or model calls are made.
Temporary files are used for the Lua probe.

`--repo-only` skips machine links, runtime dependencies and Pi/Ghostty startup checks.
Python 3 and Neovim are required; unavailable optional syntax tools are reported as
skipped. Exit 1 means a check failed; exit 0 means no failures, but read the skip list.
A missing `flake.lock` is reported as a skip until it is generated on homepc.
These checks do not replace a Nix build or interactive application testing.

CI is not configured. It could run the same checks automatically on pushes/PRs;
for now, run the script locally before pushing.

## Verification status

Mac checks passed for TypeScript cross-file definitions, ESLint diagnostics,
completion, project-local Prettier, Lua formatting and TSX highlighting. Ghostty
validated. The link installer was tested for preview, backups, identity preservation
and repeated runs. Mac links are applied; local Git identity/signing was preserved.

The Nix Lua entry point/live-link layout was tested using installed Mac plugins,
without Lazy or parser downloads. Nix is unavailable here: package builds, activation
and Linux desktop runtime checks still need to run on homepc. Full shell/desktop
behavior is not certified by these editor checks. Pi installation and config links are documented in [pi/README.md](pi/README.md);
provider login remains local to each machine.

Possession session saving is enabled on both platforms; session data stays local
to each machine. Restore sessions explicitly with `:PossessionLoad name`.

See [Neovim setup and shortcuts](nvim/README.md) for daily use.
