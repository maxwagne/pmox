    1  apt install vim 
    2  efibootmgr -v
    3  vim /etc/default/grub
    4  update-grub
    5  reboot now
    6  echo "vfio" >> /etc/modules
    7  echo "vfio_iommu_type1" >> /etc/modules
    8  echo "vfio_pci" >> /etc/modules
    9  update-initramfs -u -k all
   10  systemctl reboot
   11  dmesg | grep -i vfio
   12  dmesg | grep 'remapping'
   13  lspci -nn | grep 'NVIDIA'
   14  lspci -nn | grep 'AMD'
   15  echo "options vfio-pci ids=1002:73ff,1002:ab28" >> /etc/modprobe.d/vfio.conf
   16  echo "softdep radeon pre: vfio-pci" >> /etc/modprobe.d/vfio.conf
   17  echo "softdep amdgpu pre: vfio-pci" >> /etc/modprobe.d/vfio.conf
   18  reboot now
   19  lsblk
   20  mkdir -p /mnt/local-usb
   21  mount /dev/sda1 /mnt/local-usb
   22  umount /dev/sda1 /mnt/local-usb
   23  dmesg | grep -E "DMAR|IOMMU"
   24  apt upgrade qemu
   25  apt update && apt dist-upgrade
   26  apt-get update && apt-get dist-upgrade
   27  apt upgrade
   28  apt-get install --fix-broken
   29  reboot now
   30  history
