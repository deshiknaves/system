#! /bin/bash
set -e

REPO_URL="https://github.com/deshiknaves/system.git"
SOURCE_DIR="$HOME/Developer/system"
CHEZMOI_ARGS=()

# Standalone copy of scripts/sudo-keepalive.sh, since this runs before the clone.
keep_sudo_alive() {
  sudo -v
  while true; do
    sudo -n true
    sleep 50
    kill -0 "$$" 2>/dev/null || exit
  done 2>/dev/null &
  SUDO_KEEPALIVE_PID=$!
  trap 'kill "$SUDO_KEEPALIVE_PID" 2>/dev/null' EXIT
}

# Turns --machine <personal|work> into a chezmoi prompt answer, passes the rest through.
parse_args() {
  local machine=""
  while [ $# -gt 0 ]; do
    case "$1" in
      --machine)
        machine="$2"
        shift 2 || { echo "❌ --machine needs a value"; exit 1; }
        ;;
      --machine=*)
        machine="${1#--machine=}"
        shift
        ;;
      *)
        CHEZMOI_ARGS+=("$1")
        shift
        ;;
    esac
  done

  [ -n "$machine" ] || return 0
  case "$machine" in
    personal | work) CHEZMOI_ARGS+=(--promptChoice "Machine type=$machine") ;;
    *)
      echo "❌ --machine must be personal or work"
      exit 1
      ;;
  esac
}

install_xcode_cli_tools() {
  echo "🔍 Checking for Xcode CLI tools..."
  if xcode-select -p &>/dev/null; then
    echo "✅ Xcode CLI tools found"
    return
  fi
  echo "⏳ Installing Xcode CLI tools"
  xcode-select --install
  echo "⚠ Rerun this script once the Xcode CLI tools finish installing"
  exit 0
}

install_apt_packages() {
  echo "🔍 Checking for apt-get..."
  if ! command -v apt-get &>/dev/null; then
    echo "❌ apt-get not found, only Ubuntu/Debian is supported"
    exit 1
  fi
  echo "⏳ Installing apt packages"
  sudo apt-get update
  sudo DEBIAN_FRONTEND=noninteractive apt-get install -y \
    build-essential procps curl file git zsh
  echo "✅ Apt packages installed"
}

load_brew() {
  local brew_bin
  for brew_bin in /opt/homebrew/bin/brew /home/linuxbrew/.linuxbrew/bin/brew; do
    if [ -x "$brew_bin" ]; then
      eval "$("$brew_bin" shellenv)"
      return
    fi
  done
}

install_homebrew() {
  echo "🔍 Checking for Homebrew..."
  command -v brew &>/dev/null || load_brew
  if command -v brew &>/dev/null; then
    echo "✅ Homebrew found"
    return
  fi
  echo "⏳ Installing Homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  load_brew
  echo "✅ Homebrew installed"
}

brew_install() {
  echo "🔍 Checking for $1..."
  if command -v "$1" &>/dev/null; then
    echo "✅ $1 found"
    return
  fi
  echo "⏳ Installing $1"
  brew install "$1"
  echo "✅ $1 installed"
}

clone_repo() {
  echo "🔍 Checking for $SOURCE_DIR..."
  if [ -d "$SOURCE_DIR" ]; then
    echo "✅ Repo found"
    return
  fi
  echo "⏳ Cloning $REPO_URL"
  mkdir -p "$(dirname "$SOURCE_DIR")"
  git clone "$REPO_URL" "$SOURCE_DIR"
  echo "✅ Repo cloned"
}

install_git_hooks() {
  echo "🔍 Checking git hooks..."
  if [ "$(git -C "$SOURCE_DIR" config --get core.hooksPath)" = ".githooks" ]; then
    echo "✅ Git hooks configured"
    return
  fi
  echo "⏳ Configuring git hooks"
  git -C "$SOURCE_DIR" config core.hooksPath .githooks
  echo "✅ Git hooks configured"
}

warn_login_shell() {
  local login_shell
  login_shell="$(getent passwd "$(id -un)" | cut -d: -f7)"
  if [ "$(basename "$login_shell")" != "zsh" ]; then
    echo "⚠ Login shell is not zsh. Run: chsh -s \"\$(command -v zsh)\""
  fi
}

main() {
  parse_args "$@"
  keep_sudo_alive

  local os
  os="$(uname -s)"
  if [ "$os" = "Darwin" ]; then
    install_xcode_cli_tools
  else
    install_apt_packages
  fi

  install_homebrew
  brew_install chezmoi
  brew_install just
  clone_repo
  install_git_hooks

  echo "⏳ Applying dotfiles"
  chezmoi init --apply --source "$SOURCE_DIR" "${CHEZMOI_ARGS[@]}"
  echo "✅ Dotfiles applied"

  if [ "$os" != "Darwin" ]; then
    warn_login_shell
  fi
}

main "$@"
