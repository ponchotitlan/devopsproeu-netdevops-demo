#!/bin/bash -x
# Title: Lint inventory
# Description: This script runs a linting validation on the provided inventory yaml file. It is implied that the file exists
# Author: @ponchotitlan
#
# Usage:
#   ./lint-inventory.sh <inventory_yaml>

# Function to lint a YAML file
lint_yaml_file() {
    local file=$1

    # Check if the file exists
    if [[ ! -f $file ]]; then
        echo "Error: File '$file' does not exist."
        exit 1
    fi

    # Run yamllint on the file
    yamllint "$file"

    # Check the exit status of yamllint
    if [[ $? -eq 0 ]]; then
        echo "YAML file '$file' passed linting successfully!"
    else
        echo "YAML file '$file' has linting errors."
        exit 1
    fi
}

if [ -z "$1" ]; then
    echo "Usage: $0 <inventory_yaml> ..."
    exit 1
fi

echo "##### [🗳️] Validating YAML inventory linting .... #####"

pip install yamllint
lint_yaml_file "$1"

echo "[🗳️] Linting done!"