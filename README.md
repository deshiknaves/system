# System

This is a collection of install scripts that I use to set up a new system. The
goal is to run a single command and have a system ready to go. Of course, there
are some things that can't be automated, but this should get you 90% of the way
there.

## Usage

```shell
make
```

## Order of operations

1. Install Xcode CLI tools (`xcode_cli_tools.sh`)
2. Install brew (`brew_install.sh`)
3. Install applications through brew (`applications.sh`)
4. Install oh-my-zsh and Spaceship (`spaceship_install.sh`)
5. Install applications through the Mac App Store (`mas_install.sh`)
6. Copy dotfiles into the home directory (`dot_files.sh`)
7. Sync the Neovim config (`sync_nvim_config.sh`)

## Repo layout

- `nvim/` - Neovim config (lazy.nvim, plugins under `lua/config/`)
- `zsh/` - zsh config and aliases
- `tmux/` - tmux config
- `ghostty/` - Ghostty terminal config
- `claude/` - global instructions for Claude Code
- `codex/` - global instructions for Codex
- `.warp/themes/` - Warp terminal themes

## Neovim sync

`~/.config/nvim` is the live copy. Run from the repo root:

```shell
./sync_nvim_config.sh --push # ~/.config/nvim -> repo, no prompt
./sync_nvim_config.sh --pull # repo -> ~/.config/nvim, asks first
```

`--pull` uses `rsync --delete`, so files in `~/.config/nvim` that are not in the
repo are removed.

## If you're customizing this

If you're customizing this for your own use, you'll want to change the
applications and files that are listed in the scripts:

- `applications.sh` - This is the list of applications that are installed
  through brew
- `mas_install.sh` - This is the list of applications that are installed through
  the Mac App Store
- `spaceship_install.sh` - This installs oh-my-zsh and Spaceship
- `dot_files.sh` - This is the list of dotfiles that are copied into the home
  directory

To remove one of the scripts, remove the line from the `makefile` that
orchestrates the install.

## Known issues

- `makefile` calls `sync_nvim_config.sh from`, but the script only accepts
  `--push` or `--pull`, so the last step of `make` fails.
- `dot_files.sh` copies `./aerospace/aerospace.toml`, but there is no
  `aerospace/` directory. With `set -e` the script aborts at that line.
- Nothing installs the `ghostty/`, `claude/` or `codex/` configs.

## TODO

- [ ] Add a script to install all the fonts
