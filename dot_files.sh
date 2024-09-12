#! /bin/bash

set -e

function copy_file() {
    # Check if file exists
    if [ -f $2 ]; then
        echo "✅ $2 exists"
        echo "🔍 Checking for differences..."
        if cmp -s $2 $1; then
            echo "✅ $1 is up to date"
        else
            echo "⚠ $2 is different from $1"
            diff $2 $1 --color || :
            read -p "❓ Do you want to overwrite the existing $2? (y/n): " response
            if [ "$response" == "y" ]; then
                echo "⏳ Copying $1..."
                trash $2
                cp $1 $2
            else
                echo "❌ $1 not copied"
            fi
        fi
    else
        echo "⏳ Copying $1..."
        cp $1 $2
    fi
}

function create_dir() {
    # Check if directory exists
    if [ -d $1 ]; then
        echo "✅ $1 exists"
    else
        echo "⏳ Creating $1..."
        mkdir $1
    fi
}

create_dir ~/.config/nvim
copy_file ./zsh/.aliases ~/.aliases
copy_file ./nvim/init.lua ~/.config/nvim/init.lua
copy_file ./zsh/.zshrc ~/.zshrc
copy_file ./tmux/.tmux.conf ~/.tmux.conf
copy_file ./aerospace/aerospace.toml ~/.config/aerospace/aerospace.toml