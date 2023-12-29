# Get latest Proxmox kernel headers:
apt install pve-headers

# Get required build tools:
apt install git dkms build-essential

# Perform the build:
git clone https://github.com/gnif/vendor-reset.git
cd vendor-reset
dkms install .

# Enable vendor-reset to be loaded automatically on startup:
echo "vendor-reset" >> /etc/modules
update-initramfs -u

# Perform system reboot
read -p "Do you want to reboot the system now? (y/n): " REBOOT_CONFIRM
if [ "$REBOOT_CONFIRM" = "y" ]; then
    reboot
else
    echo "System reboot was not executed. Please manually restart the system to apply the changes."
fi
