#!/bin/bash


# Check for vfio-related logs in kernel messages after reboot
dmesg | grep -i vfio
dmesg | grep 'remapping'

# List NVIDIA and AMD devices after reboot
lspci -nn | grep 'NVIDIA'
lspci -nn | grep 'AMD'


# Modify vfio configuration after reboot

#First line in vfio.conf

# Eingabeaufforderung für die IDs
read -p "Bitte gib die IDs im Format ****:****,****:**** ein: " ids_input

# Trenne die IDs basierend auf dem Komma
IFS=',' read -ra id_list <<< "$ids_input"

# Konstruiere die Zeile mit den IDs
options_line="options vfio-pci ids="

# Konstruiere die Zeile für jede ID
for id in "${id_list[@]}"
do
    options_line+="$(echo "$id" | tr '\n' ',')"
done

# Entferne das letzte Komma
options_line="${options_line%,}"

# Füge die Zeile in die Datei ein
echo "$options_line" >> /etc/modprobe.d/vfio.conf

#Second and third line in vfio.conf

echo "softdep radeon pre: vfio-pci" >> /etc/modprobe.d/vfio.conf
echo "softdep amdgpu pre: vfio-pci" >> /etc/modprobe.d/vfio.conf


