#!/bin/bash

# Function to run commands and display output
run_command() {
    echo "Running command: $1"
    bash -c "$1"
}

# Update and install necessary packages

# kill existing tmux sessions
echo "Killing existing tmux sessions..."
run_command "tmux kill-server"

# set up tmux session
echo "Setting up tmux session..."
run_command "tmux new-session -d -s jarvis"

echo "Updating and installing packages..."
run_command "sudo apt-get update > /dev/null 2>&1"
run_command "sudo apt-get install -y git python3 python3-pip python3-venv tmux pkg-config libcairo2-dev libgirepository1.0-dev > /dev/null 2>&1"

# Clone repositories
echo "Cloning Jarvis-GPT repository..."
run_command "git clone https://github.com/XenioxYT/jarvis-gpt.git > /dev/null 2>&1"

echo "Cloning Jarvis-Setup repository..."
run_command "git clone https://github.com/XenioxYT/jarvis-setup.git jarvis-gpt/jarvis-setup > /dev/null 2>&1"

# Create and activate the 'jarvis-venv' virtual environment
python3 -m venv jarvis-venv
source jarvis-venv/bin/activate

# Install yaspin in the 'jarvis-venv' environment
pip install yaspin

# Run the Python installation script
python python-setup.py