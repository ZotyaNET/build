#!/bin/bash

set -e

if [ "$#" -lt 3 ] || ([ "$1" == "restore" ] && [ "$#" -ne 4 ]); then
    echo "Usage: $0 <action> <source_folder> <target_folder> [size]"
    exit 1
fi

action=$1
source_folder=$2
target_folder=$3
size=$4

if [ "$action" == "restore" ]; then
    if [ ! -d "$source_folder" ]; then
        echo "Error: Source folder does not exist."
        exit 1
    fi
    if [ -e "$target_folder" ] && [ "$(ls -A $target_folder 2>/dev/null)" ]; then
        echo "Error: Target folder exists and is not empty."
        exit 1
    fi
    sudo rm -R "$target_folder"
    mkdir -p "$target_folder"
    sudo mount -t tmpfs -o size=${size}G tmpfs "$target_folder"
    rsync -avu --progress "$source_folder"/ "$target_folder"/
    echo "Restore completed successfully."

elif [ "$action" == "backup" ]; then
    if ! mount | grep -q "on $target_folder type tmpfs"; then
        echo "Error: Target folder is not a tmpfs mount."
        exit 1
    fi
    rsync -avu --delete --progress "$target_folder"/ "$source_folder"/
    echo "Backup completed successfully."
else
    echo "Error: Invalid action. Use 'restore' or 'backup'."
    exit 1
fi
