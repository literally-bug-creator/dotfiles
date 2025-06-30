#!/bin/bash

# Path to the package list file
PACKAGE_FILE=".packages"

# Check if the package file exists
if [ ! -f "$PACKAGE_FILE" ]; then
    echo "Error: $PACKAGE_FILE not found." >&2
    exit 1
fi

# Read each package line by line
grep -v -e '^#' -e '^
 "$PACKAGE_FILE" | while IFS= read -r package; do
    # Try to install with pacman first
    if sudo pacman -S --noconfirm --needed "$package"; then
        echo "Successfully installed $package with pacman."
    else
        echo "Failed to install $package with pacman, trying with yay."
        # If pacman fails, try with yay
        if command -v yay &> /dev/null && yay -S --noconfirm --needed "$package"; then
            echo "Successfully installed $package with yay."
        else
            echo "WARNING: Failed to install $package with both pacman and yay. Skipping."
        fi
    fi
done

echo "All packages from $PACKAGE_FILE have been processed."
