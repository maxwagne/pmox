#!/bin/bash

# Add modules to /etc/modules
echo "vfio" >> /etc/modules
echo "vfio_iommu_type1" >> /etc/modules
echo "vfio_pci" >> /etc/modules

# Update initramfs
update-initramfs -u -k all

# Reboot again this time with systemctl
systemctl reboot

