# Neovim

Shared configuration for macOS and NixOS. On macOS, `~/.config/nvim` symlinks here.
On NixOS, Home Manager generates the entry point and loads shared Lua through live checkout symlinks.
Use Neovim 0.12+ on Mac; shared APIs require 0.11+. Nix supplies its compatible
plugins/parsers. Full Nix package compatibility still needs validation on homepc.

See [overall installation and recovery](../README.md) for both platforms.

## macOS installation

Homebrew and Xcode command-line tools are required for parser compilation.

From the awesome-dots repository:

```sh
brew bundle --file=Brewfile.nvim --no-upgrade
nvim
```

Lazy installs plugins on first launch; Treesitter installs the configured parsers.
Homebrew manages servers and formatters. No npm/Bun global installs or Mason needed.
Conform prefers project-local Prettier; ESLint uses the project's installed ESLint and config.
Run the project's dependency installation first.

## Layout

- `init.lua`: Lazy bootstrap
- `options.lua`, `keymap.lua`: shared core settings and shortcuts
- `lua/shared/`: settings and setup functions consumed by both platforms
- `lua/plugins/`: macOS Lazy plugin installation/loading, referencing shared settings
- `lua/platform_nix.lua`: initializes Nix-installed plugins with the live shared settings
- `plugins/possession.lua`: Nix entry point for the shared session configuration
- `lazy-lock.json`: known plugin revisions; commit after deliberate plugin updates

## Shortcuts

Leader is comma. In normal mode:

- `gd`: definition; `gD`: declaration (server-dependent); Ctrl-o: jump back
- `gr`: references; `gi`: implementation; `K`: hover
- `,rn`: rename; `,ca`: code action
- `,fc`: format buffer (or selection in visual mode); formatting also runs on save
- `,ff`: files; `,fg`: grep; `,fb`: buffers
- `,fs`: document symbols; `,fw`: workspace symbols
- `,fr`: searchable references; `,fd`: diagnostics
- `[d` / `]d`: previous/next diagnostic; `,e`: diagnostic details
- `\`: file tree

Completion: Tab selects a suggestion, Enter accepts the selected item. Nothing is
preselected or automatically inserted. Ctrl-space opens completion/documentation.
Which-key shows available mappings after a prefix.

Nix additionally enables `nixd` and uses `nixfmt` for Nix files. Possession session autosave is shared with Mac. The undeclared Markdown `compiler`
linter was removed; Markdown still formats with Prettier. Treesitter highlighting
is shared; parser installation remains platform-specific. Nix loads plugins
through Home Manager; Mac uses Lazy events and commands.

## Troubleshooting and updates

- `:checkhealth vim.lsp`: enabled servers, executables, and attached clients
- `:ConformInfo`: selected formatter and log
- `:LspEslintFixAll`: apply ESLint fixes when ESLint is attached
- `:checkhealth nvim-treesitter`: parser dependencies
- `:Lazy profile`: plugin loading costs (Mac only)
- `:Lazy restore`: Mac only; restore plugin revisions from the committed lockfile

Update plugins deliberately with `:Lazy update`, verify editing, then commit the
lockfile. Treesitter updates parsers with the plugin. Go navigation requires a
valid module/workspace and resolvable dependencies; server installation alone cannot
fix a broken project's module graph.

Config edits take effect after restarting Neovim on either platform. Nix rebuilds
are needed for package changes or the generated launcher, not shared Lua edits.

## Sessions (both platforms)

Possession saves the current layout on interactive exit, using the working-directory
basename as the automatic session name (the existing Nix naming convention).
`:PossessionList` lists sessions; `:PossessionLoad name` restores one.
`:PossessionSave name` explicitly saves a named snapshot. Automatic restore is off.
Two checkouts with the same directory basename share an automatic session name;
use distinct named snapshots when you need to keep both.

Session files live under Neovim's data directory (`:echo stdpath('data')`), in
`possession/`. They stay local to each machine, outside the repo. Sessions restore
workspace layout, not backups of unsaved edits. Headless checks do not autosave.
Settings live in `lua/shared/possession.lua`; both installers consume that file.
