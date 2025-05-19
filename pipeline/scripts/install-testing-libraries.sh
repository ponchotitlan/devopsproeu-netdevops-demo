#!/bin/bash -x
# Title: Installing of libraries for testing
# Description: This script performs the pip installation of the requirements.txt file located in the pipeline/preconfigs dir of this repository.
# Author: @ponchotitlan

echo "##### [🏃🏻‍♀️] Installing the libraries required for testing .... #####"

python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt

echo "[🏃🏻‍♀️] Installing done!"