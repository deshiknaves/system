#! /bin/bash

set -e

# Check if powerline fonts are installed
ls ~/Library/Fonts | grep Powerline > /dev/null
if [[ $? != 0 ]] ; then
    echo "⏳ Installing Powerline fonts..."
    git clone https://github.com/powerline/fonts.git --depth=1
    cd fonts
    ./install.sh
    cd ..
    rm -rf fonts
    echo "✅ Powerline fonts installed"
else
    echo "✅ Powerline fonts found"
fi

if [ -d ~/.oh-my-zsh ]; then
    echo "✅ oh-my-zsh is installed"
else
    echo "⏳ Installing oh-my-zsh"
    sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
fi

ZSH_CUSTOM=~/.oh-my-zsh

if test -f "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme"; then
    echo "✅ Spaceship theme found"
else
    echo "⏳ Installing Spaceship theme"
    unset ZSH
    echo $ZSH_CUSTOM
    git clone https://github.com/spaceship-prompt/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt" --depth=1
    ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme"
    git clone https://github.com/aspirewit/zsh-nvm-auto-switch ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-nvm-auto-switch
    echo "✅ Spaceship theme installed"
fi
