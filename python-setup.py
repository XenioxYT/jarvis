import subprocess
import time
import os
from yaspin import yaspin

def run_command(command, display_output=False):
    process = subprocess.Popen(command, shell=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
    while True:
        output = process.stdout.readline()
        if display_output and output:
            print(output.decode().strip())
        if process.poll() is not None:
            break
    return process.returncode

def install_requirements(file_path):
    with yaspin(text=f"Installing packages from {file_path}..."):
        exit_status = run_command(f"./jarvis-venv/bin/pip install -r {file_path}")
        if exit_status == 0:
            print(f"\033[92mAll packages from {file_path} installed successfully [✔]\033[0m")
        else:
            print(f"\033[91mError installing packages from {file_path} [X]\033[0m")

# Kill existing tmux session
subprocess.call("tmux kill-session -t jarvis > /dev/null 2>&1", shell=True)

print("Starting setup...")

# # Create and activate the virtual environment
os.system("python3 -m venv jarvis-venv")
os.system("source jarvis-venv/bin/activate")

# Open a new tmux session
subprocess.call("tmux new-session -d -s jarvis", shell=True)

# Install packages from requirements.txt
install_requirements("./jarvis-gpt/requirements.txt")
install_requirements("./jarvis-gpt/jarvis-setup/requirements.txt")

# Django server setup in tmux
tmux_commands = """
    source jarvis-venv/bin/activate
    cd jarvis-gpt/jarvis-setup/jarvisSetup
    python manage.py makemigrations
    python manage.py migrate
    python manage.py runserver 0.0.0.0:8000
"""
subprocess.call(f"tmux send-keys -t jarvis '{tmux_commands}' C-m", shell=True)

# Wait for Django server to start
with yaspin(text="Starting Django server..."):
    while run_command("tmux capture-pane -pS - | grep -q 'Starting development server at'") != 0:
        time.sleep(1)

# Fetch server IP address
ip_addr = subprocess.check_output("hostname -I | awk '{print $1}'", shell=True).decode().strip()
print(f"Server has started. Access it at http://{ip_addr}:8000")
