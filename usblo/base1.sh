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
TARGET_UUID=$(echo "$chosen_line" | grep -o 'UUID="[^"]*' | sed 's/UUID="//')

echo "The selected UUID is: $TARGET_UUID"

# Get information about the UUID entry in blkid
device=$(echo "$chosen_line" | awk -F':' '{print $1}')
uuid_entry=$(echo "$chosen_line" | awk -F' ' '{print $2}')

# Check if the device is already present in /etc/fstab
if grep -q "$TARGET_UUID" /etc/fstab; then
    echo "This UUID is already present in /etc/fstab."
else
    # Backup /etc/fstab
    cp /etc/fstab /etc/fstab.backup

    # Append entry to /etc/fstab for auto-mounting
    echo "UUID=$TARGET_UUID  /mnt/local-usb  auto  defaults  0  2" >> /etc/fstab
    echo "Entry added to /etc/fstab for auto-mounting."
fi
