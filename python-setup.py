import subprocess
import time
import sys
from yaspin import yaspin
from yaspin.spinners import Spinners

def run_command(command, display_output=False):
    process = subprocess.Popen(command, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    while True:
        output = process.stdout.readline()
        if display_output and output:
            print(output.decode().strip())
        if process.poll() is not None:
            break
    return process.returncode, process.stderr.read().decode()

def install_requirements(file_path):
    with yaspin(Spinners.pong, text=f"Installing packages from {file_path}...") as spinner:
        exit_status, error_message = run_command(f"./jarvis-venv/bin/pip install -r {file_path}")
        if exit_status == 0:
            spinner.ok("✅ ")
            spinner.text = f"Installed packages from {file_path}"
        else:
            spinner.fail(f"❌ Error: {error_message}")
            print("\033[91mInstallation failed. Please see the error above.\033[0m")  # Print in red
            sys.exit(1)  # Exit the script

# Kill existing tmux session
subprocess.call("tmux kill-session -t jarvis > /dev/null 2>&1", shell=True)

print("Starting setup...")

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
with yaspin(text="Starting Django server...") as spinner:
    while run_command("tmux capture-pane -pS - | grep -q 'Starting development server at'") != 0:
        time.sleep(1)
        spinner.ok("✅ [Done] ")

# Fetch server IP address
ip_addr = subprocess.check_output("hostname -I | awk '{print $1}'", shell=True).decode().strip()
print(f"Server has started. Access it at http://{ip_addr}:8000")
