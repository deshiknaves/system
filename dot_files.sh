#! /bin/bash

set -e

# Create a directory if it does not exist
if [ ! -d ~/.config/nvim ]; then
    mkdir -p ~/.config/nvim
fi

# Check if file exists
if [ -f ~/.config/nvim/init.lua ]; then
    echo "✅ Nvim config exists"
else
    echo "⏳ Copying nvim config file..."
    cp ./nvim/init.lua ~/.config/nvim/init.lua
fi