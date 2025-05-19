#!/bin/bash -x
# Title: Creation of artifacts with the test results from the service packages
# Description: This script adds to a tar file the files located in the packages/<package>/tests dir of this repository. The netsim folders are ignored. The resulting tar file is stored in the mounted volume /tmp/nso for easier access via the pipeline later on.
# Author: @ponchotitlan
#
# Usage:
#   ./create-artifact-tests.sh <service-name>

# This function creates a tar file of the folder specified and saves it in the /tmp/nso location
# Usage tar_folders <container_name(str)> <package_folder_names(array(str))>
tar_folders_test(){
    local container_name="$1"
    local tests_array="$@"

    docker exec -i $container_name bash -lc "cd /nso/run/packages/ && tar -czvf /tmp/nso/devopsproeu_test.tar.gz ${tests_array[@]}"
}

tar_folders_commit(){
    local tests_array="$1"
    cd services/
    tar -czvf ../pipeline/preconfigs/devopsproeu_commit.tar.gz ${tests_array[@]}
}

YAML_FILE_CONFIG="pipeline/setup/config.yaml"
YAML_FILE_DOCKER="pipeline/setup/docker-compose.yml"
PACKAGES_DIR="services"
NEDS_PATH=".netsims | keys"

if [ -z "$1" ]; then
    echo "Usage: $0 <container_name> ..."
    exit 1
fi

echo "##### [📦] Zipping the results into an artifact.... #####"

# Extract the name of the container and remove quotes
CONTAINER_NAME_PATH=".services.$1.container_name"
container_name=$(yq "$CONTAINER_NAME_PATH" "$YAML_FILE_DOCKER")
container_name=$(echo "$container_name" | tr -d '"')

# Extract the netsim folder names from the YAML file
ned_packages=$(yq "$NEDS_PATH" "$YAML_FILE_CONFIG")

# Get all the packages folders and remove the trailing slash from their names
all_packages=($(ls -d "$PACKAGES_DIR"/*/ | xargs -n 1 basename))

service_tests=()
# Iterate over each folder and check if it's in the excluded list
for package in "${all_packages[@]}"; do

    is_ned=0
    for ned in $ned_packages; do
        ned=$(echo "$ned" | tr -d '"')
        ned=$(echo "$ned" | tr -d ',')
        if [[ $package == $ned ]]; then
            is_ned=1
        fi
    done

    if [[ $is_ned == 0 ]]; then
        service_tests+=("${package}/tests")
    fi
done

if [[ "$ENVIRONMENT" == "test" ]]; then
    tar_folders_test $container_name ${service_tests[@]}
else
    tar_folders_commit ${service_tests[@]}
fi

echo "[📦] Creation of the artifact done!"