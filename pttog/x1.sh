#!/bin/bash

# Define your Proxmox configuration file path
CONF_FILE="/etc/pve/qemu-server"

# Check if the correct number of arguments is provided
if [ $# -ne 2 ]; then
    echo "Usage: $0 <VM_ID> <-on|-off>"
    exit 1
fi

# Extract VM ID and action from command line arguments
VM_ID="$1"
ACTION="$2"

# Construct the full path to the VM configuration file
VM_CONF="$CONF_FILE/$VM_ID.conf"

# Action based on the parameter
case "$ACTION" in
    -on)
        # Add USB and PCIe passthrough lines
        echo "usb1: host=3-1" >> "$VM_CONF"
        echo "usb2: host=3-2" >> "$VM_CONF"
	echo "usb3: host=3-3" >> "$VM_CONF"
	echo "usb4: host=3-4" >> "$VM_CONF"
	echo "usb5: host=5-1" >> "$VM_CONF"
	echo "usb6: host=5-2" >> "$VM_CONF"
	echo "usb7: host=5-3" >> "$VM_CONF"
	echo "usb8: host=5-4" >> "$VM_CONF"
        echo "hostpci0: 0000:09:00.0,pcie=1,x-vga=1" >> "$VM_CONF"
        echo "hostpci1: 0000:09:00.1,pcie=1" >> "$VM_CONF"
        echo "Passthrough lines added to $VM_CONF."
        ;;
    -off)
        # Remove USB and PCIe passthrough lines
        sed -i '/^usb/d' "$VM_CONF"
        sed -i '/^hostpci/d' "$VM_CONF"
        echo "Passthrough lines removed from $VM_CONF."
        ;;
    *)
        echo "Invalid parameter. Usage: $0 <VM_ID> <-on|-off>"
        exit 1
        ;;
esac
