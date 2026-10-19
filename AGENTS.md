# AGENTS.md

Guidance for AI coding agents working in this repo.

## What this is

Personal machine setup repo, managed with chezmoi. It supports macOS and
Ubuntu/Debian. `bootstrap.sh` installs the tools. `home/` holds the dotfiles,
package lists and the Neovim config.

## Layout

- `bootstrap.sh` - first-run script (Xcode CLI tools or apt, Homebrew, chezmoi,
  just, then `chezmoi init --apply`)
- `justfile` - recipes (`just --list`)
- `.oxfmtrc.json` - oxfmt formatter config
- `.githooks/pre-commit` - runs `just lint` (enable with `just hooks`)
- `.github/workflows/lint.yml` - CI, runs `just lint`
- `.chezmoiroot` - sets the chezmoi source to `home/`
- `home/` - chezmoi source
  - `.chezmoi.toml.tmpl` - chezmoi config (`sourceDir`, `mode = "symlink"`,
    `machine` prompt)
  - `.chezmoidata/packages.yaml` - package lists
  - `.chezmoitemplates/Brewfile` - Brewfile built from the lists
  - `run_onchange_before_install-packages.sh.tmpl` - runs `brew bundle`
  - `.chezmoiignore` - files chezmoi skips (`.envvars`)
  - `run_onchange_after_macos-defaults.sh.tmpl` - macOS `defaults write`
    settings (renders to an empty script on Linux)
  - `dot_gitconfig.tmpl` - `~/.gitconfig`. It includes `~/.gitconfig.local`,
    which holds signing and work settings and is not in the repo.
  - `dot_config/nvim/` - Neovim config (lazy.nvim,
    `lua/config/{plugins,standalone,vscode,telescope}`, `lazy-lock.json`)
  - `dot_config/{ghostty,sheldon}/`, `dot_config/starship.toml`, `dot_zshrc`,
    `dot_aliases`, `dot_tmux.conf` - terminal, shell and tmux config
- Claude and Codex config are not in this repo.

## Running setup

Never run these without asking. They change the system (brew, apps, home
directory files):

- `bootstrap.sh`
- `chezmoi apply`, `chezmoi init`, `chezmoi update`
- `just apply`, `just update`, `just bootstrap`

Read-only commands are fine: `just diff`, `just status`, `just missing`,
`just lint`.

## Editing

- Edit sources under `home/`, never the targets in `~`.
- Use chezmoi names: `dot_` for a leading `.`, `.tmpl` for templates, `empty_`
  to keep empty files, `run_onchange_` for scripts that run when they change.
- Files without `.tmpl` are symlinked into the repo, so the target and source
  are the same file.
- For `.tmpl` files, edit the source. The target is rendered output and is
  overwritten on apply.
- Packages: edit `home/.chezmoidata/packages.yaml`. Prefer core Homebrew
  formulae and casks, because Homebrew refuses untrusted third-party taps.
- Run `just lint` after changes. `just hooks` makes git run it before each
  commit.

## Neovim config

- The config lives at `home/dot_config/nvim`.
- Files in `~/.config/nvim` are symlinks to it, so there is nothing to sync.
- `dot_stylua.toml` and `dot_editorconfig` become `.stylua.toml` and
  `.editorconfig` in the target.

## Formatting

- Lua: `home/dot_config/nvim/dot_stylua.toml` (2 spaces).
  `home/dot_config/nvim/dot_editorconfig` also sets 2-space indent for `*.lua`.
- Markdown, JSON, YAML, TOML: `.oxfmtrc.json` (oxfmt, 80 cols,
  `proseWrap: always`, no semicolons, single quotes). `lazy-lock.json` is
  ignored.
- `just lint` runs shellcheck, stylua and `oxfmt --check`. Run `oxfmt` to fix
  formatting.

## Shell script conventions

- `#! /bin/bash` and `set -e` at the top
- Helper functions per task (`brew_install`, `install_homebrew`, `clone_repo`)
- Check first, then install; skip when already present
- Status echos with emoji: `🔍` checking, `⏳` working, `✅` done, `❌` failed,
  `⚠` warning, `❓` prompt

## Commits

GitMoji prefix, then a capitalized short message. Examples from `git log`:

- `✨ Add flash.nvim on <CR> / <S-CR>`
- ``🐛 Fix invalid `not` negation in sync_directory``
- `🔧 Fix jsdoc and listing shortcut`
- `⬆️ Update plugins and drop flume.nvim`

Ask before committing.
