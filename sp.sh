#!/bin/bash

# Set up the initial 'setup' virtual environment
python3 -m venv setup

# Activate the 'setup' virtual environment
source setup/bin/activate

# Install yaspin in the 'setup' environment
pip install yaspin

# Run your installation Python script
python your_install_script.py

# Deactivate the 'setup' virtual environment
deactivate
