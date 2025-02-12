#!/bin/bash

set -e

source ./sync_directory.sh

# Set $1 to a variable
DIRECTION=$1

# Check that DIRECTION is either "to" or "from"
if [ "$DIRECTION" != "to" ] && [ "$DIRECTION" != "from" ]; then
    echo "❌ Invalid direction. Use 'to' or 'from'."
    exit 1
fi

if [ "$DIRECTION" == "to" ]; then
    echo "🔄 Syncing dotfiles to remote..."
    sync_directory ~/.config/nvim . "nvim config"
elif [ "$DIRECTION" == "from" ]; then
    echo "🔄 Syncing dotfiles from remote..."
    sync_directory ./nvim ~/.config "nvim config"
fi
