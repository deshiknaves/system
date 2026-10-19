# System

Personal machine setup, managed with [chezmoi](https://www.chezmoi.io). One
command sets up a new machine: Homebrew, packages, dotfiles and the Neovim
config. Supports macOS and Ubuntu/Debian.

## First run

On a fresh machine:

```shell
bash -c "$(curl -fsSL https://raw.githubusercontent.com/deshiknaves/system/main/bootstrap.sh)"
```

From a clone of this repo:

```shell
just bootstrap
```

The script installs Xcode CLI tools (macOS) or apt packages (Linux), Homebrew,
`chezmoi` and `just`. It clones the repo to `~/Developer/system`, then runs
`chezmoi init --apply`. It asks once for the machine type (`personal` or
`work`).

## How it works

- The chezmoi source is `home/` (set by `.chezmoiroot`).
- The repo lives at `~/Developer/system` (`sourceDir` in
  `home/.chezmoi.toml.tmpl`).
- chezmoi uses `mode = "symlink"`. Files that are not templates become symlinks
  into the repo, so edits on the machine land in the repo directly.
- Files named `dot_x` become `~/.x`. Files ending in `.tmpl` are templates and
  are rendered, not linked.

## Daily workflow

- Normal file: edit it (it is a symlink), then `git commit`.
- Template (`*.tmpl`): run `chezmoi edit --apply <target>`.
- New file: run `just add <path>`.
- Sync a machine from the repo: run `just update`. It runs `git pull` and
  applies. Symlinked files change on pull alone. Templates, new files and
  packages need the apply.
- Preview changes: run `just diff`.

## Recipes

Run `just --list` to see them all.

| Recipe       | What it does                                      |
| ------------ | ------------------------------------------------- |
| `bootstrap`  | First-run setup on a fresh machine                |
| `apply`      | Apply dotfiles and run the package install        |
| `diff`       | Show pending dotfile changes                      |
| `status`     | Show files that differ from the source            |
| `add <path>` | Add a file to the chezmoi source                  |
| `update`     | Pull repo changes and apply                       |
| `missing`    | List installed packages that are not in the lists |
| `lint`       | Run shellcheck, stylua and prettier checks        |

## Packages

Edit `home/.chezmoidata/packages.yaml`. Each group has `brews`, `casks` and
`mas`:

- `all`: every machine
- `darwin`, `linux`: by OS
- `personal`, `work`: by machine type (optional sections)

Casks and `mas` apps install on macOS only. `just apply` runs `brew bundle` when
the list changes. `just missing` shows installed packages that are not in the
lists.

Homebrew refuses untrusted third-party taps, so prefer core formulae and casks.
Fonts are casks (`font-*`).

## Per-machine settings

- Templates can use `.machine` (`personal` or `work`) and `.chezmoi.os`.
- `~/.envvars` is for this machine only. It is never synced (it is in
  `home/.chezmoiignore`). `~/.zshrc` sources it if it exists.

## Shell

zsh with [sheldon](https://sheldon.cli.rs) for plugins and
[starship](https://starship.rs) for the prompt.

- Plugins: `home/dot_config/sheldon/plugins.toml`
- Prompt: `home/dot_config/starship.toml`

## Layout

- `bootstrap.sh` - first-run script
- `justfile` - recipes
- `home/` - chezmoi source
  - `.chezmoi.toml.tmpl` - chezmoi config and the machine prompt
  - `.chezmoidata/packages.yaml` - package lists
  - `.chezmoitemplates/Brewfile` - Brewfile built from the lists
  - `run_onchange_before_install-packages.sh.tmpl` - installs packages
  - `dot_config/nvim/` - Neovim config (lazy.nvim)
  - `dot_config/{ghostty,sheldon}/`, `dot_config/starship.toml` - terminal and
    shell config
  - `dot_zshrc`, `dot_aliases`, `dot_tmux.conf` - shell and tmux config
  - `dot_codex/AGENTS.md` - global Codex instructions

Claude config and skills are not in this repo.
