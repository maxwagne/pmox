#!/bin/bash

# Benutzer zur Eingabe des neuen Schnittstellennamens auffordern
read -p "Geben Sie den neuen Schnittstellennamen ein (z.B. nic1): " INTERFACE_NAME

# Get the list of available network interfaces and their MAC addresses
echo "Available network interfaces and their MAC addresses:"
ip addr

# Prompt user to enter the NIC name from the list
read -p "Geben Sie den Namen der Netzwerkschnittstelle ein, dessen MAC-Adresse Sie mit dem neuen Namen versehen möchten (z.B. eth0, enp4s0): " SELECTED_INTERFACE

# Retrieve MAC address for the selected interface
MAC_ADDRESS=$(ip addr show dev "$SELECTED_INTERFACE" | awk '/ether/{print $2}')
echo "MAC-Adresse für $SELECTED_INTERFACE: $MAC_ADDRESS"

# Create or edit the udev rule file
echo 'SUBSYSTEM=="net", ACTION=="add", ATTR{address}=="'"$MAC_ADDRESS"'", NAME="'"$INTERFACE_NAME"'"' | sudo tee /etc/udev/rules.d/70-persistent-net.rules > /dev/null

# Reload udev rules
sudo udevadm control --reload-rules
sudo udevadm trigger

echo "Udev-Regel angewendet. Der Schnittstellenname '$INTERFACE_NAME' wurde der MAC-Adresse '$MAC_ADDRESS' zugewiesen."

# Änderungen in der Netzwerkkonfigurationsdatei vornehmen
sudo sed -i 's/'"$SELECTED_INTERFACE"'/'"$INTERFACE_NAME"'/g' /etc/network/interfaces

echo "Netzwerkkonfiguration aktualisiert. Der Schnittstellenname wurde in der Konfigurationsdatei ersetzt."

# Neustart des Systems durchführen
read -p "Möchten Sie jetzt das System neu starten? (j/n): " REBOOT_CONFIRM
if [ "$REBOOT_CONFIRM" = "j" ]; then
    sudo reboot
else
    echo "Systemneustart wurde nicht ausgeführt. Bitte starten Sie das System manuell neu, um die Änderungen wirksam zu machen."
fi

