#!/bin/bash

echo "Starting setup..."

# Function to display a spinner
function spinner() {
    local pid=$!
    local delay=0.1
    local spinstr='|/-\'
    while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
        local temp=${spinstr#?}
        printf " [%c]  " "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b\b"
    done
    printf "    \b\b\b\b"
}

# Update and install necessary packages
echo "Updating and installing packages..."
sudo apt-get update > /dev/null 2>&1 &
spinner
sudo apt-get install -y git python3 python3-pip python3-venv tmux pkg-config libcairo2-dev libgirepository1.0-dev > /dev/null 2>&1 &
spinner

# Clone the main Jarvis repository
echo "Cloning Jarvis repository..."
git clone https://github.com/XenioxYT/jarvis.git > /dev/null 2>&1 &
spinner
cd jarvis

# Open a new tmux session
tmux new-session -d -s jarvis

# Inside the tmux session, execute the following:
tmux send-keys "
    git clone https://github.com/XenioxYT/jarvis-gpt.git
    git clone https://github.com/XenioxYT/jarvis-setup.git jarvis-gpt/jarvis-setup
    python3 -m venv jarvis-venv
    source jarvis-venv/bin/activate
    pip install -r jarvis-gpt/requirements.txt
    pip install -r jarvis-gpt/jarvis-setup/requirements.txt
    cd jarvis-gpt/jarvis-setup/jarvisSetup
    python manage.py makemigrations
    python manage.py migrate
    python manage.py runserver 0.0.0.0:8000
" C-m

# Wait for Django server to start
echo "Starting Django server..."
until tmux capture-pane -pS - | grep -q "Starting development server at"; do
    sleep 1
done

# Fetch server IP address
IP_ADDR=$(hostname -I | awk '{print $1}')

echo "Server has started. Access it at http://$IP_ADDR:8000"
