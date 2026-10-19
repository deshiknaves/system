# List recipes
default:
    @just --list

# First-run setup on a fresh machine
bootstrap:
    ./bootstrap.sh

# Apply dotfiles and run package install
apply:
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
    chezmoi update

# List installed packages missing from the Brewfile
missing:
    chezmoi execute-template '{{ "{{" }} template "Brewfile" . {{ "}}" }}' | brew bundle cleanup --file=-

# Shellcheck, stylua and prettier checks
lint:
    shellcheck bootstrap.sh
    chezmoi execute-template < home/run_onchange_before_install-packages.sh.tmpl | shellcheck -
    stylua --config-path home/dot_config/nvim/dot_stylua.toml --check home/dot_config/nvim
    npx --yes prettier --check '**/*.md'
