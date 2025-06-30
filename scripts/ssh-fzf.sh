#!/bin/bash

# This script allows you to select an SSH host from your ~/.ssh/config file
# using fzf and then connects to the selected host.

# Check if the config file exists
if [ ! -f "$HOME/.ssh/config" ]; then
    echo "Error: SSH config file not found at ~/.ssh/config" >&2
    exit 1
fi

# Get the list of hosts from the config file.
# This command looks for lines starting with "Host", prints the second column,
# and filters out any wildcard entries like "*".
HOSTS=$(awk '/^Host / && $2 != "*" {print $2}' "$HOME/.ssh/config")

# Check if any hosts were found
if [ -z "$HOSTS" ]; then
    echo "No hosts found in ~/.ssh/config" >&2
    exit 1
fi

# Use fzf to let the user select a host.
# --height=40% makes the fzf window not take up the whole screen.
# --reverse places the search results at the bottom, which is common.
SELECTED_HOST=$(echo "$HOSTS" | fzf --height=40% --reverse)

# If SELECTED_HOST is not empty (i.e., the user selected something),
# then connect to it.
if [ -n "$SELECTED_HOST" ]; then
    echo "Connecting to $SELECTED_HOST..."
    ssh "$SELECTED_HOST"
else
    echo "No host selected. Aborting."
fi
