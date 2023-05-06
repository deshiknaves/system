#! /bin/bash

set -e

function brew_install() {
    echo "🔍 Checking for $2..."
    if brew list $1 &>/dev/null; then
        echo "✅ $2 found"
    else
        echo "⏳ Installing $2"
        brew install $1
        echo "✅ $2 installed"
    fi
}

brew_install "mas" "Mac App Store CLI"
brew_install "gh" "GitHub"
brew_install "iterm2" "iTerm2"
brew_install "moom" "Moom"
brew_install "visual-studio-code" "Visual Studio Code"
brew_install "zsh" "ZSH"
brew_install "zsh-completions" "ZSH Completions"
brew_install "nvm" "NVM"
brew_install "wget" "Wget"
brew_install "arc" "Arc"
brew_install "tower" "Tower"
brew_install "docker" "Docker"
brew_install "yarn" "Yarn"
brew_install "fig" "Fig"
brew_install "rocket" "Rocket"
brew_install "raycast" "Raycast"
brew_install "discord" "Discord"
brew_install "cron" "Cron"
brew_install "contexts" "Contexts"
brew_install "awscli" "AWS CLI"
brew_install "bat" "Bat"

# Post install

cat ~/.zshrc | grep "export NVM_DIR" > /dev/null
if [[ $? != 0 ]] ; then
    echo "⏳ Appending NVM to .zshrc"
    tee -a ~/.zshrc <<EOF

export NVM_DIR="$HOME/.nvm"
  [ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && . "/usr/local/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

EOF
    echo "✅ NVM appended to .zshrc"
else
    echo "✅ NVM found in .zshrc"
fi

echo "Additional apps to install:"
echo "Homerow https://www.homerow.app"