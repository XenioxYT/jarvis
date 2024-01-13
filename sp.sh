#!/bin/bash
# Function to run commands and display output
run_command() {
    echo -e "\033[1;34mRunning command:\033[0m $1"
    (
        while :; do
            for s in / - \\ \|; do 
                printf "\r$s"; 
                sleep .1; 
            done; 
        done & 
        bash -c "$1"
        kill $!; trap 'kill $!' SIGTERM
    ) 
}
# Update and install necessary packages
echo -e "\033[1;32mUpdating and installing necessary packages...\033[0m"
run_command "sudo apt-get update"
run_command "sudo apt-get install -y git python3 python3-pip python3-venv tmux pkg-config libcairo2-dev libgirepository1.0-dev"

# Create and activate the 'jarvis-venv' virtual environment
echo -e "\033[1;32mCreating and activating the 'jarvis-venv' virtual environment...\033[0m"
python3 -m venv jarvis-venv
source jarvis-venv/bin/activate

# Install yaspin in the 'jarvis-venv' environment
echo -e "\033[1;32mInstalling yaspin in the 'jarvis-venv' environment...\033[0m"
pip install yaspin

# kill existing tmux sessions
echo -e "\033[1;32mKilling existing tmux pane...\033[0m"
run_command "tmux kill-pane -t jarvis"

# set up tmux session
echo -e "\033[1;32mSetting up tmux session...\033[0m"
run_command "tmux new-session -d -s jarvis"

echo -e "\033[1;32mUpdating and installing packages...\033[0m"
run_command "sudo apt-get update"
run_command "sudo apt-get install -y git python3 python3-pip python3-venv tmux pkg-config libcairo2-dev libgirepository1.0-dev git"

# Clone repositories
echo -e "\033[1;32mCloning Jarvis-GPT repository...\033[0m"
run_command "git clone https://github.com/XenioxYT/jarvis-gpt.git"

echo -e "\033[1;32mCloning Jarvis-Setup repository...\033[0m"
run_command "git clone https://github.com/XenioxYT/jarvis-setup.git jarvis-gpt/jarvis-setup"

# Run the Python installation script
echo -e "\033[1;32mRunning the Python installation script...\033[0m"
python python-setup.py