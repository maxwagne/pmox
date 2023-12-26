#!/bin/bash

# Eingabeaufforderung für die IDs
read -p "Bitte gib die IDs im Format ****:****,****:**** ein:" ids_input

# Trenne die IDs basierend auf dem Komma
IFS=',' read -ra id_list <<< "$ids_input"

# Überprüfe, ob die Länge der ID 9 Zeichen ist und füge sie in die Zeile ein
for ids in "${id_list[@]}"
do
    # Füge die IDs in die Zeile ein
    echo "options vfio-pci ids=$ids" >> /opt/config/test
done

