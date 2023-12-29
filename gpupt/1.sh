#!/bin/bash

# Display EFI boot information
efibootmgr -v

# Edit GRUB configuration
sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="quiet"/GRUB_CMDLINE_LINUX_DEFAULT="quiet iommu=pt"/' /etc/default/grub
update-grub
update-grub2

# Perform system reboot
read -p "Do you want to reboot the system now? (y/n): " REBOOT_CONFIRM
if [ "$REBOOT_CONFIRM" = "y" ]; then
    reboot
else
    echo "System reboot was not executed. Please manually restart the system to apply the changes."
fi
