#!/bin/bash

set -e

# Options for rsync
# -a: archive mode (preserves permissions, timestamps, symbolic links, etc.)
# -v: verbose output
# -h: human-readable output
# --delete: delete extraneous files from destination directories
# --progress: show progress during transfer
RSYNC_OPTIONS="-avh --delete --progress"

function sync_directory() {
    SOURCE_DIR=$1
    DEST_DIR=$2

    if not [ -d "$SOURCE_DIR" ]; then
	echo "❌ $SOURCE_DIR does not exist"
	exit 1
    fi

    echo "🔄 Syncing $3 from $2..."

    rsync $RSYNC_OPTIONS "$SOURCE_DIR" "$DEST_DIR"

    echo "✅ synced"
}


