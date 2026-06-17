#!/bin/bash

set -e

source ./sync_directory.sh

# Set $1 to a variable
DIRECTION=$1

if [ "$DIRECTION" != "--push" ] && [ "$DIRECTION" != "--pull" ]; then
    echo "❌ Invalid direction. Use '--push' or '--pull'."
    exit 1
fi

if [ "$DIRECTION" == "--push" ]; then
    # Not prompting here as we can always revert from the git history
    echo "🔄 Syncing Neovim config to the system repository..."

    sync_directory ~/.config/nvim .
elif [ "$DIRECTION" == "--pull" ]; then
    # Add a confirmation prompt
    read -p "Are you sure you want to overwrite your Neovim config from the repository? (y/n) " -n 1 -r

    if [[ $REPLY =~ ^[Yy]$ ]]; then
	echo "🔄 Syncing Neovim config from system repository..."
	sync_directory ./nvim ~/.config "nvim config"
    else
	echo "❌ Sync canceled."
	exit 1
    fi
fi
