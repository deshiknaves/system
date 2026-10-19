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
`chezmoi` and `just`. It clones the repo to `~/Developer/system`, enables the
git hooks, then runs `chezmoi init --apply`. It asks for your password once and
keeps `sudo` alive until it finishes. It asks once for the machine type
(`personal` or `work`).

Without a TTY, pass the machine type instead:

```shell
bash -c "$(curl -fsSL https://raw.githubusercontent.com/deshiknaves/system/main/bootstrap.sh)" -- --machine personal
```

`--machine <personal|work>` answers the prompt. Other arguments pass through to
`chezmoi init`.

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
| `mas`        | Install App Store apps (sign in to the App Store) |
| `diff`       | Show pending dotfile changes                      |
| `status`     | Show files that differ from the source            |
| `add <path>` | Add a file to the chezmoi source                  |
| `update`     | Pull repo changes and apply                       |
| `missing`    | List installed packages that are not in the lists |
| `hooks`      | Make git run `just lint` before each commit       |
| `lint`       | Run shellcheck, stylua and oxfmt checks           |

## Packages

Edit `home/.chezmoidata/packages.yaml`. Each group has `taps`, `brews`, `casks`
and `mas`:

- `all`: every machine
- `darwin`, `linux`: by OS
- `personal`, `work`: by machine type (optional sections)

Casks and `mas` apps install on macOS only. `just apply` runs the package script
when the list changes. It runs after the dotfiles and never aborts the apply: a
failed `brew bundle` prints a warning. The script also:

- adopts casks you installed by hand (`brew install --cask --adopt`) when their
  `.app` is in `/Applications`

App Store apps install in a separate script. If you are not signed in to the App
Store it warns and stops. Sign in, then run `just mas`.

`just missing` shows installed packages that are not in the lists.

Homebrew refuses untrusted third-party taps, so prefer core formulae and casks.
Fonts are casks (`font-*`).

## Per-machine settings

- Templates can use `.machine` (`personal` or `work`) and `.chezmoi.os`.
- `~/.gitconfig.local` holds signing and work git settings.
  `~/.local_extensions` holds machine-local shell config. Neither is in the
  repo. chezmoi creates a stub for each only if it is missing.
- `~/.envvars` is for this machine only. It is never synced (it is in
  `home/.chezmoiignore`). `~/.zshrc` sources it if it exists.

## Shell

zsh with [sheldon](https://sheldon.cli.rs) for plugins and
[starship](https://starship.rs) for the prompt.

- Plugins: `home/dot_config/sheldon/plugins.toml`
- Prompt: `home/dot_config/starship.toml`
- Node versions: [fnm](https://github.com/Schniz/fnm) switches on `cd` using
  `.nvmrc` or `.node-version`.

## Layout

- `bootstrap.sh` - first-run script
- `scripts/sudo-keepalive.sh` - keeps `sudo` alive for `just apply` and
  `just update`
- `justfile` - recipes
- `.oxfmtrc.json` - oxfmt formatter config
- `.githooks/` - pre-commit hook that runs `just lint`
- `.github/workflows/` - CI lint
- `home/` - chezmoi source
  - `.chezmoi.toml.tmpl` - chezmoi config and the machine prompt
  - `.chezmoidata/packages.yaml` - package lists
  - `.chezmoitemplates/Brewfile` - Brewfile built from the lists
  - `.chezmoitemplates/casks` - cask list as JSON, shared by the Brewfile and
    the install script
  - `run_onchange_after_install-packages.sh.tmpl` - installs packages, adopts
    casks
  - `run_onchange_after_mas-apps.sh.tmpl` - installs App Store apps
  - `dot_config/nvim/` - Neovim config (lazy.nvim)
  - `dot_config/{ghostty,sheldon}/`, `dot_config/starship.toml` - terminal and
    shell config
  - `dot_zshrc`, `dot_aliases`, `dot_tmux.conf` - shell and tmux config
  - `dot_gitconfig.tmpl` - git config (includes `~/.gitconfig.local`)
  - `create_dot_gitconfig.local`, `create_dot_local_extensions` - stubs created
    only if missing
  - `run_onchange_after_macos-defaults.sh.tmpl` - macOS defaults

Claude and Codex config and skills are not in this repo.
