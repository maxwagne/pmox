#!/bin/bash

# Update package lists and install vim
apt update
apt install -y vim

# Display EFI boot information
efibootmgr -v

# Edit GRUB configuration
sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="quiet"/GRUB_CMDLINE_LINUX_DEFAULT="quiet iommu=pt"/' /etc/default/grub
update-grub

# Reboot the system
reboot now

