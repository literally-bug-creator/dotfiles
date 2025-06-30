#!/bin/bash

# This script configures GNOME to use Alt+Shift to switch between keyboard layouts.
# It uses gsettings to modify the dconf database, which is the standard way
# to change GNOME settings via the command line.

KEY="org.gnome.desktop.input-sources"
OPTION="xkb-options"
VALUE="['grp:alt_shift_toggle']"

echo "This script will set the keyboard layout switch shortcut to Alt+Shift."
echo ""

# 1. Show the current setting
CURRENT_VALUE=$(gsettings get $KEY $OPTION)
echo "Current layout switch option: $CURRENT_VALUE"
echo ""

# 2. Set the new value
echo "Applying new setting: $VALUE"
gsettings set $KEY $OPTION "$VALUE"

# 3. Verify the change
echo ""
echo "Verifying the change..."
NEW_VALUE=$(gsettings get $KEY $OPTION)

if [ "$NEW_VALUE" = "$VALUE" ]; then
    echo "✅ Success! Your keyboard layout can now be switched with Alt+Shift."
    echo "The change should be effective immediately."
else
    echo "❌ Error: Failed to set the new value."
    echo "Expected: $VALUE"
    echo "Got: $NEW_VALUE"
    exit 1
fi

exit 0
