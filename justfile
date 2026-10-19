# List recipes
default:
    @just --list

# First-run setup on a fresh machine
bootstrap *args:
    ./bootstrap.sh {{ args }}

# Apply dotfiles and run package install
apply:
    #! /bin/bash
    set -e
    source "{{ justfile_directory() }}/scripts/sudo-keepalive.sh"
    keep_sudo_alive
    chezmoi apply

# Show pending dotfile changes
diff:
    chezmoi diff

# Show files that differ from source
status:
    chezmoi status

# Add a file to chezmoi source
add path:
    chezmoi add {{ path }}

# Pull repo changes and apply
update:
    #! /bin/bash
    set -e
    source "{{ justfile_directory() }}/scripts/sudo-keepalive.sh"
    keep_sudo_alive
    chezmoi update

# Install App Store apps (sign in to the App Store first)
mas:
    chezmoi --source "{{ justfile_directory() }}" execute-template < home/run_onchange_after_mas-apps.sh.tmpl | bash

# Copy files that differ from the source into ~/.dotfiles-backup/<timestamp>
backup:
    #! /bin/bash
    set -e
    dest="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"
    count=0
    while IFS= read -r rel; do
      if [ -e "$HOME/$rel" ]; then
        mkdir -p "$dest/$(dirname "$rel")"
        cp -RL "$HOME/$rel" "$dest/$rel"
        count=$((count + 1))
      fi
    done < <(chezmoi status | cut -c4-)
    if [ "$count" -eq 0 ]; then
      echo "✅ Nothing to back up"
    else
      echo "✅ Backed up $count paths to $dest"
    fi

# List installed packages missing from the Brewfile
missing:
    chezmoi execute-template '{{ "{{" }} template "Brewfile" . {{ "}}" }}' | brew bundle cleanup --file=- || [ $? -eq 1 ]

# Point git at the repo hooks in .githooks
hooks:
    git config core.hooksPath .githooks

# Shellcheck, stylua and oxfmt checks
lint:
    shellcheck bootstrap.sh scripts/sudo-keepalive.sh .githooks/pre-commit
    chezmoi --source "{{ justfile_directory() }}" execute-template < home/run_onchange_after_install-packages.sh.tmpl | shellcheck -
    chezmoi --source "{{ justfile_directory() }}" execute-template < home/run_onchange_after_mas-apps.sh.tmpl | shellcheck -
    chezmoi --source "{{ justfile_directory() }}" execute-template < home/run_onchange_after_macos-defaults.sh.tmpl | shellcheck -
    stylua --config-path home/dot_config/nvim/dot_stylua.toml --check home/dot_config/nvim
    oxfmt --check
