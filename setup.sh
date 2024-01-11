#!/bin/bash
tmux kill-session -t jarvis > /dev/null 2>&1
echo "Starting setup..."

# Function to display a spinner
function spinner() {
    local pid=$1
    local delay=0.5
    local spinstr='|/-\\'
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
spinner $!
sudo apt-get install -y git python3 python3-pip python3-venv tmux pkg-config libcairo2-dev libgirepository1.0-dev > /dev/null 2>&1 &
spinner $!

# Clone the Jarvis-GPT and Jarvis-Setup repositories
echo "Cloning Jarvis-GPT repository..."
git clone https://github.com/XenioxYT/jarvis-gpt.git > /dev/null 2>&1 &
spinner $!
echo "Cloning Jarvis-Setup repository..."
git clone https://github.com/XenioxYT/jarvis-setup.git jarvis-gpt/jarvis-setup > /dev/null 2>&1 &
spinner $!

# Create and activate the virtual environment
python3 -m venv jarvis-venv
source jarvis-venv/bin/activate

# Open a new tmux session
tmux new-session -d -s jarvis

# Install packages from requirements.txt with progress and error output
REL_PATH_TO_FIRST_REQUIREMENTS="./jarvis-gpt/requirements.txt"
# Path to the second requirements.txt
REL_PATH_TO_SECOND_REQUIREMENTS="./jarvis-gpt/jarvis-setup/requirements.txt"


# Install packages from the first requirements.txt with progress and error output
echo "Installing packages from jarvis-gpt requirements.txt..."
pip install -r "$REL_PATH_TO_FIRST_REQUIREMENTS" > /dev/null 2>&1 &
spinner $!
wait $!
EXIT_STATUS=$?
if [ $EXIT_STATUS -eq 0 ]; then
    echo -e "All packages from jarvis-gpt requirements.txt installed successfully \e[92m[✔]\e[0m"
else
    echo -e "Error installing packages from jarvis-gpt requirements.txt \e[91m[X]\e[0m"
fi

# Install packages from the second requirements.txt with progress and error output
echo "Installing packages from jarvis-setup requirements.txt..."
pip install -r "$REL_PATH_TO_SECOND_REQUIREMENTS" > /dev/null 2>&1 &
spinner $!
wait $!
EXIT_STATUS=$?
if [ $EXIT_STATUS -eq 0 ]; then
    echo -e "All packages from jarvis-setup requirements.txt installed successfully \e[92m[✔]\e[0m"
else
    echo -e "Error installing packages from jarvis-setup requirements.txt \e[91m[X]\e[0m"
fi

# Continue with Django server setup in tmux
tmux send-keys "
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
