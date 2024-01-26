# README for Jarvis

## Overview
Jarvis is a comprehensive setup script designed to streamline the installation and setup process for a Django-based project. This project is ideal for users looking to quickly set up a Django server with additional dependencies, ensuring an effortless and efficient deployment.

## Repository Contents
- `sp.sh`: The initial setup script for the Jarvis environment. It handles system updates, package installations, virtual environment setup, and cloning of necessary repositories.
- `python-setup.py`: A Python script that manages the installation of Python packages from requirements files and sets up the Django server within a tmux session.

## Prerequisites
Before running the setup scripts, ensure you have the following installed on your system:
- Git
- Python 3
- Python 3-pip
- Python 3-venv
- tmux
- pkg-config
- libcairo2-dev
- libgirepository1.0-dev

## Installation and Setup
1. **Initial Setup with `sp.sh`**:
    - Updates the system and installs necessary packages.
    - Creates and activates a Python virtual environment named `jarvis-venv`.
    - Installs `yaspin` in the virtual environment.
    - Kills existing tmux sessions and sets up a new session named `jarvis`.
    - Clones `jarvis-gpt` and `jarvis-setup` repositories into the appropriate directories.

2. **Python Environment Setup with `python-setup.py`**:
    - Installs Python packages from `requirements.txt` files located in the cloned repositories.
    - Sets up a Django server inside a tmux session named `jarvis`.
    - Executes Django migrations and starts the development server.
    - Fetches and displays the server IP address for access.

## Usage
After completing the setup, access the Django server by navigating to `http://[IP_ADDRESS]:8000` in your web browser, where `[IP_ADDRESS]` is the IP address displayed after running the `python-setup.py` script.

## Troubleshooting
If you encounter any issues during the installation or setup process, please refer to the error messages provided by the scripts. The `python-setup.py` script will display error messages in red if the installation of packages fails.

## Contributions
Contributions to the Jarvis project are welcome. Please follow the standard GitHub fork and pull request workflow.
