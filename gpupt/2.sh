#!/bin/bash

# Add modules to /etc/modules
echo "vfio" >> /etc/modules
echo "vfio_iommu_type1" >> /etc/modules
echo "vfio_pci" >> /etc/modules

# Update initramfs
update-initramfs -u -k all

# Perform system reboot
read -p "Do you want to reboot the system now? (y/n): " REBOOT_CONFIRM
if [ "$REBOOT_CONFIRM" = "y" ]; then
    reboot
else
    echo "System reboot was not executed. Please manually restart the system to apply the changes."
fi
