#!/bin/bash

# --- Configuration ---
# List of GNOME packages to exclude from the installation.
#
# !!! WARNING !!!
# `gnome-keyring` is in this list as requested. It stores passwords for Wi-Fi,
# online accounts, etc. Removing it is NOT RECOMMENDED. Consider deleting
# 'gnome-keyring' from the list below if you are unsure.
EXCLUDE_PACKAGES=(
    # Applications
    baobab
    epiphany
    evince
    gnome-calculator
    gnome-calendar
    gnome-characters
    gnome-clocks
    gnome-connections
    gnome-console
    gnome-contacts
    gnome-font-viewer
    gnome-logs
    gnome-maps
    gnome-music
    gnome-software
    gnome-system-monitor
    gnome-text-editor
    gnome-tour
    gnome-weather
    loupe
    simple-scan
    snapshot
    sushi
    totem

    # Accessibility & Help
    orca
    tecla
    gnome-user-docs
    yelp

    # Other specified packages
    gnome-remote-desktop
    grilo-plugins
    gnome-disk-utility
    gnome-keyring
)

# --- Script Logic ---

# Convert the array into a pipe-separated string for grep
EXCLUDE_PATTERN=$(IFS="|"; echo "${EXCLUDE_PACKAGES[*]}")

echo "Fetching package list from the 'gnome' group..."
# Get all packages in the 'gnome' group, one per line
GNOME_PACKAGES=$(pacman -Sgq gnome)

if [ -z "$GNOME_PACKAGES" ]; then
    echo "Error: Could not find the 'gnome' package group. Is it available in your repositories?" >&2
    exit 1
fi

echo "Filtering out excluded packages..."
# Filter the list, ensuring we match the whole line to avoid partial matches
INSTALL_PACKAGES=$(echo "$GNOME_PACKAGES" | grep -vE "^(${EXCLUDE_PATTERN})$")

if [ -z "$INSTALL_PACKAGES" ]; then
    echo "Error: The filtered package list is empty. Check your exclusion list." >&2
    exit 1
fi

# Build the final command, replacing newlines with spaces
COMMAND="sudo pacman -S --needed ${INSTALL_PACKAGES//$'\n'/ }"

echo ""
echo "The following command will be executed:"
echo "----------------------------------------"
echo "$COMMAND"
echo "----------------------------------------"
echo ""
read -p "Do you want to proceed with the installation? (y/N) " -n 1 -r
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "Starting installation..."
    eval "$COMMAND"
else
    echo "Installation cancelled."
fi
