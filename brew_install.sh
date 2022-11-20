#! /bin/bash

set -e

echo "🔍 Checking for Homebrew..."
which -s brew  > /dev/null
if [[ $? != 0 ]] ; then
    echo "⏳ Installing Brew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> /Users/deshi/.zshrc
    eval "$(/opt/homebrew/bin/brew shellenv)"
    source ~/.zshrc
    echo "✅ Brew installed"
else
    echo "✅ Homebrew found"
    brew update
fi