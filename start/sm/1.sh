#!/bin/bash

# File to store user-entered values
storage_config_file="$HOME/.storage_config"

# Default values for prompts
default_storage_id="net-nfs1"
default_path="/mnt/net-nfs1"
default_server="192.168.178.34"
default_export="/volume1/pmox"

# Load user-entered values from the config file if it exists
if [[ -f "$storage_config_file" ]]; then
    source "$storage_config_file"
fi

# Prompt user for storage ID
read -p "Enter storage ID [$default_storage_id]: " storage_id
storage_id=${storage_id:-$default_storage_id}

# Prompt user for path
read -p "Enter path [$default_path]: " path
path=${path:-$default_path}

# Prompt user for server
read -p "Enter server [$default_server]: " server
server=${server:-$default_server}

# Prompt user for export
read -p "Enter export [$default_export]: " export
export=${export:-$default_export}

# Save user-entered values into the config file
cat > "$storage_config_file" <<EOF
default_storage_id="$storage_id"
default_path="$path"
default_server="$server"
default_export="$export"
EOF

# Add the NFS storage with user-provided parameters
pvesm add nfs "$storage_id" --path "$path" --server "$server" --export "$export"

# Set the content types for the NFS storage
pvesm set "$storage_id" --content backup,snippets,iso,images,rootdir,vztmpl

