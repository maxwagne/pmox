#!/bin/bash

# Perform blkid and filter entries with sd*
blkid_output=$(blkid | grep '/dev/sd*')

# Display filtered results
echo "Filtered entries with sd*:"
echo "$blkid_output"

# Prompt for the line number
read -p "Enter the line number to retrieve the UUID: " line_number

# Retrieve UUID based on the chosen line number
chosen_line=$(echo "$blkid_output" | sed -n "${line_number}p")

# Extract UUID from the chosen line
TARGET_UUID=$(echo "$chosen_line" | grep -oP ' UUID="\K[^"]*')

echo "The selected UUID is: $TARGET_UUID"

# Check if the device's UUID is already present in /etc/fstab
if grep -q "UUID=$TARGET_UUID" /etc/fstab; then
    echo "This UUID is already present in /etc/fstab."
else
    # Check if the script is run as root
    if [ "$EUID" -ne 0 ]; then
        echo "Please run this script as root to modify /etc/fstab."
        exit 1
    fi
    
    # Append entry to /etc/fstab for auto-mounting
    echo "UUID=$TARGET_UUID /mnt/local-usb auto defaults 0 2" >> /etc/fstab
    echo "Entry added to /etc/fstab for auto-mounting."
fi

