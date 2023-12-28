#!/bin/bash

# Prompt user for the new interface name
read -p "Enter the new interface name (e.g., nic1): " INTERFACE_NAME

# Get the list of available network interfaces and their MAC addresses
echo "Available network interfaces and their MAC addresses:"
ip addr

# Prompt user to enter the NIC name from the list
read -p "Enter the network interface name whose MAC address you want to associate with the new name: " SELECTED_INTERFACE

# Retrieve MAC address for the selected interface
MAC_ADDRESS=$(ip addr show dev "$SELECTED_INTERFACE" | awk '/ether/{print $2}')
echo "MAC address for $SELECTED_INTERFACE: $MAC_ADDRESS"

# Create or edit the udev rule file
echo 'SUBSYSTEM=="net", ACTION=="add", ATTR{address}=="'"$MAC_ADDRESS"'", NAME="'"$INTERFACE_NAME"'"' > /etc/udev/rules.d/70-persistent-net.rules

# Reload udev rules
udevadm control --reload-rules
udevadm trigger

echo "Udev rule applied. The interface name '$INTERFACE_NAME' has been assigned to MAC address '$MAC_ADDRESS'."

# Make changes in the network configuration file
sed -i 's/'"$SELECTED_INTERFACE"'/'"$INTERFACE_NAME"'/g' /etc/network/interfaces

echo "Network configuration updated. The interface name has been replaced in the configuration file."

# Perform system reboot
read -p "Do you want to reboot the system now? (y/n): " REBOOT_CONFIRM
if [ "$REBOOT_CONFIRM" = "y" ]; then
    reboot
else
    echo "System reboot was not executed. Please manually restart the system to apply the changes."
fi
