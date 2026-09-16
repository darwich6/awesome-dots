# Pi coding agent

Shared configuration for both machines; credentials and conversations stay local.

## Installation

Mac:

```sh
cd ~/github/awesome-dots
brew bundle --file=Brewfile.pi --no-upgrade
./script/link-dotfiles --apply
pi --version
```

NixOS: `pi.nix` installs Pi from the separate `nixpkgs-pi` input because it is absent
from the system's 25.11 package set. Generate/review/commit `flake.lock`, build and
activate as described in the [overall guide](../README.md). `dotfiles.nix` installs
the live config links. The Nix package/build is not yet verified on homepc.

## Sign in on each machine

Start `pi` in a project, then run `/login`. Repeat for each provider you use:

- **ChatGPT:** choose ChatGPT Plus/Pro (Codex) and complete the browser login.
- **Anthropic:** select Anthropic and the login method appropriate to your account,
  or supply `ANTHROPIC_API_KEY` outside this repository. Pi's current provider docs
  say Claude subscription use in third-party harnesses draws on separately billed
  extra usage; do not assume it consumes the normal Claude subscription allowance.
- **Cursor:** not built in. The community `pi-cursor-sdk` extension uses the Cursor
  SDK and requires a Cursor SDK API key. A normal Cursor login alone is not this key.
  The extension is not installed; review it and confirm the intended auth/billing
  path before adding it to shared packages. Do not import Cursor's stored tokens.

Use `/model` to switch among available authenticated providers/models. No default
provider/model is pinned yet. Authenticate directly in Pi; do not put keys in chat,
settings.json, or Git. No account is authenticated by this setup.

References: [Pi providers](https://pi.dev/docs/latest/providers),
[Cursor SDK extension](https://pi.dev/packages/pi-cursor-sdk).

## Shared versus local files

Links under `~/.pi/agent/` point to the corresponding files/directories here:
`settings.json`, `keybindings.json`, `extensions/`, `skills/`, `prompts/`, `themes/`.
The initial settings use the dark theme and Neovim as the external editor (Ctrl+G).
There are no installed extensions, custom skills, prompts or themes yet.

**Do not symlink the whole `~/.pi/agent` directory.** `auth.json`, sessions, trust
choices, caches and installed package files stay on each machine. Pi sessions are
separate from Possession's Neovim layout sessions.

Pi's `/settings` updates write through the settings symlink into this checkout.
Review `git diff` before committing. Project `.pi/settings.json` can override global
preferences. Keep credentials in Pi's local auth store or environment variables.

## Updates and daily use

Pull awesome-dots on each machine, then restart Pi to pick up shared changes.
Update the CLI through Homebrew or Nix; avoid `pi update self` for these installations.
Third-party packages are separate from the CLI and may execute code; add only chosen,
reviewed packages, preferably pinned to a version.

- `pi`: start in the current project.
- `/login`: connect another provider.
- `/model`: select provider/model.
- `/settings`: preferences.
- `pi --continue`: continue the latest session in this directory.
- `pi --resume`: select a previous session.

Mac CLI installation and config loading are checked without making a model request.
Provider login and an authenticated conversation still need to be completed locally.
