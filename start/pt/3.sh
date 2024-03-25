#!/bin/bash

# Check for vfio-related logs in kernel messages after reboot
dmesg | grep -i vfio
dmesg | grep 'remapping'

# List NVIDIA and AMD devices after reboot
lspci -nn | grep 'NVIDIA'
lspci -nn | grep 'AMD'

# Check if vfio configuration already exists
vfio_conf="/etc/modprobe.d/vfio.conf"
if [ ! -f "$vfio_conf" ]; then
    # Prompt for the IDs input in the format ****:****,****:****
    read -p "Please enter the IDs in the format ****:****,****:****: " ids_input

    # Split the IDs based on comma
    IFS=',' read -ra id_list <<< "$ids_input"

    # Construct the line with the IDs
    options_line="options vfio-pci ids="

    # Build the line for each ID
    for id in "${id_list[@]}"
    do
        options_line+="$(echo "$id" | tr '\n' ',')"
    done

    # Remove the trailing comma
    options_line="${options_line%,}"

    # Append the line into the file
    echo "$options_line" >> "$vfio_conf"
fi

# Blacklist GPU
echo "blacklist radeon" >> /etc/modprobe.d/blacklist.conf
echo "blacklist amdgpu" >> /etc/modprobe.d/blacklist.conf

# Perform system reboot without prompting
reboot

