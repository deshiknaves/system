# AGENTS.md

Guidance for AI coding agents working in this repo.

## What this is

Personal macOS setup repo. Shell scripts install tools and apps. Config folders
hold dotfiles and the Neovim config.

## Layout

- `makefile` - target `brew` runs the setup scripts in order
- `*.sh` in root - install and sync scripts
- `nvim/` - Neovim config (lazy.nvim,
  `lua/config/{plugins,standalone,vscode,telescope}`, `lazy-lock.json`)
- `zsh/`, `tmux/`, `ghostty/` - shell, tmux and terminal config
- `claude/CLAUDE.md`, `codex/AGENTS.md` - the user's global agent configs. They
  are not instructions for this repo. Edit them only when asked.
- `.warp/themes/` - Warp themes

## Running setup

`make` runs, in order: `xcode_cli_tools.sh`, `brew_install.sh`,
`applications.sh`, `spaceship_install.sh`, `mas_install.sh`, `dot_files.sh`,
`sync_nvim_config.sh`.

Never run `make` or any install script without asking. They change the system
(brew, apps, home directory files, `~/.config/nvim`).

## Neovim config

- Edit the config in the repo's `nvim/`.
- `~/.config/nvim` is the live copy. `sync_nvim_config.sh` syncs it, from the
  repo root:
  - `--push`: `~/.config/nvim` to repo, no prompt
  - `--pull`: repo to `~/.config/nvim`, prompts, uses `rsync --delete` so extra
    files there are removed
- Check the direction before syncing. Do not run it without asking.

## Formatting

- Lua: `nvim/.stylua.toml` (2 spaces). `nvim/.editorconfig` also sets 2-space
  indent for `*.lua`.
- Markdown, JS, JSON: `.prettierrc.js` (80 cols, `proseWrap: always`, no
  semicolons, single quotes).

## Shell script conventions

- `#! /bin/bash` and `set -e` at the top
- Helper functions per task (`brew_install`, `mas_install`, `copy_file`)
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
