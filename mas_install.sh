#! /bin/bash

set -e

function mas_install() {
    echo "🔍 Checking for $2..."
    if mas list | grep -q "$1"; then
        echo "✅ $2 found"
    else
        echo "⏳ Installing $2"
        mas install $1
        echo "✅ $2 installed"
    fi
}

echo "🔍 Checking Mac AppStore applications..."

mas_install "1402042596" "AdBlock"
mas_install "1569813296" "1Password for Safari"
mas_install "577085396" "Unclutter"
mas_install "1482454543" "Twitter"
mas_install "408981434" "iMovie"
mas_install "497799835" "Xcode"
mas_install "409183694" "Keynote"
mas_install "1166066070" "Bumpr"
mas_install "1472777122" "PayPal Honey"
mas_install "904280696" "Things"
mas_install "1384080005" "Tweetbot"
mas_install "1480933944" "Vimari"
mas_install "967805235" "Paste"
mas_install "1091189122" "Bear"
mas_install "409201541" "Pages"
mas_install "682658836" "GarageBand"
mas_install "905953485" "NordVPN"
mas_install "409203825" "Numbers"
mas_install "1289583905" "Pixelmator Pro"
mas_install "1147396723" "WhatsApp Desktop"