#!/usr/bin/env bash

# Apache License 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


# Display usage
usage() {
    echo "Usage: $0 [-h] [-d]"
    echo "  -h  Display help"
    echo "  -o  Specify destination directory (default: /etc/nixos)"
    exit 1
}

# Default values
DEST_DIR="/etc/nixos"

# Parse command line args
while getopts "ho:" opt; do
    case ${opt} in
        h )
            usage
            ;;
        o )
            DEST_DIR=$OPTARG
            ;;
        \? )
            usage
            ;;
    esac
done

# Check if rsync is available
if ! command -v rsync &> /dev/null; then
    echo "Error: rsync is not installed. Please install rsync." >&2
    exit 1
fi

# Check if destination directory exists and is not empty
if [ -d "$DEST_DIR" ]; then
    if [ "$(ls -A $DEST_DIR)" ]; then
        read -p "The destination directory $DEST_DIR is not empty. Do you want to overwrite the files? (y/n): " choice
        case "$choice" in 
            y|Y ) echo "Overwriting files...";;
            n|N ) echo "Operation cancelled."; exit 1;;
            * ) echo "Invalid choice. Operation cancelled."; exit 1;;
        esac
    fi
else
    echo "The destination directory $DEST_DIR does not exist. Creating it..."
    mkdir -p "$DEST_DIR"
    if [ $? -ne 0 ]; then
        echo "Error: Failed to create directory $DEST_DIR." >&2
        exit 1
    fi
fi

echo "Copying configuration files to $DEST_DIR"

# Copy config files out
rsync -av --quiet \
    --include="flake.nix" \
    --include="flake.lock" \
    --include="hosts/***" \
    --include="modules/***" \
    --exclude='*' \
    ./ $DEST_DIR

# Check if rsync was successful
if [ $? -ne 0 ]; then
    echo "Error: rsync failed to copy files to $DEST_DIR. Try running as root or using sudo." >&2
    exit 1
fi

echo "Done! Configuration files are in $DEST_DIR"
exit 0
