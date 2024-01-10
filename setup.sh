#!/bin/bash

# Update and install necessary packages
sudo apt-get update
sudo apt-get install -y git python3 python3-pip python3-venv tmux

# Clone the main Jarvis repository
git clone https://github.com/XenioxYT/jarvis.git
cd jarvis

# Open a new tmux session
tmux new-session -d -s jarvis_session

# Inside the tmux session, execute the following:
tmux send-keys "
    # Clone the Jarvis-GPT repository
    git clone https://github.com/XenioxYT/jarvis-gpt.git
    # Clone the Jarvis-Setup repository
    git clone https://github.com/XenioxYT/jarvis-setup.git jarvis-gpt/jarvis-setup

    # Create a new virtual environment
    python3 -m venv jarvis-venv

    # Activate the virtual environment
    source jarvis-venv/bin/activate

    # Install requirements
    pip install -r jarvis-gpt/requirements.txt
    pip install jarvis-gpt/jarvis-setup

    # Navigate to manage.py directory
    cd jarvis-gpt/jarvis-setup/jarvisSetup

    # Run the server
    python manage.py runserver
" C-m

# Print instruction for detaching from tmux
echo 'Press CTRL+b then d to detach from the tmux session.'
