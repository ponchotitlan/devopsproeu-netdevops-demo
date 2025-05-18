#!/bin/bash -x
# Title: Generate Inventory Payload
# Description: This script creates a JSON payload file based on the provided YAML file. It is implied that the file exists, and that it has a properly linted format
# Author: @ponchotitlan
#
# Usage:
#   ./generate-inventory-payload.sh <inventory_yaml> <output_payload_json>

# Function to convert YAML to JSON
convert_yaml_to_json() {
    local yaml_file=$1
    local json_file=$2

    # Check if the YAML file exists
    if [[ ! -f $yaml_file ]]; then
        echo "Error: YAML file '$yaml_file' does not exist."
        exit 1
    fi

    # Convert YAML to JSON using yq
    echo "Converting YAML file '$yaml_file' to JSON file '$json_file'..."
    cat "$yaml_file" | yq  > "$json_file"

    # Check if the conversion was successful
    if [[ $? -eq 0 ]]; then
        echo "Conversion successful! JSON file saved as '$json_file'."
    else
        echo "Error: Failed to convert YAML to JSON."
        exit 1
    fi
}

if [[ $# -ne 2 ]]; then
    echo "Usage: $0 <inventory_yaml> <output_payload_json>"
    exit 1
fi

echo "##### [♻️] Generating JSON payload based on provided inventory YAML .... #####"

convert_yaml_to_json "$1" "$2"

echo "[♻️] Generation done!"