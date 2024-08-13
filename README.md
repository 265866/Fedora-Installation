# Fedora Post-Installation Setup Scripts

This repository contains a set of Bash scripts designed to automate the post-installation configuration of a Fedora system. The scripts support both attended and unattended execution.

## Overview

### Main Script

- **`postinstall.sh`**: The central script that orchestrates the execution of all other scripts.

### Subscripts

- **`system.sh`**: Configures system settings (hostname, DNF optimization, essential tools).
- **`gnome.sh`**: Customizes GNOME (settings, theming, and removing unnecessary apps).
- **`coding.sh`**: Installs development tools (Go, NodeJS, Rust, Docker).
- **`misc.sh`**: Installs additional software (Telegram, Spotify, OBS, Discord, etc.).
- **`ssh-generate.sh`**: Generates an SSH key and displays the public key for GitHub.
- **`github.sh`**: Configures GitHub (SSH integration and git settings).

## Usage

### Running the Main Script

To run the main script:

```bash
git clone https://github.com/265866/Fedora-Installation.git
cd Fedora-Installation
chmod +x ./postinstall.sh
sudo ./postinstall.sh
```

To run the main script in unattended mode, add the `--unattended` flag

**By default, the script, not ran in unattended mode, will ask you if you want to do each step (y/n)**

```bash
sudo ./postinstall.sh --unattended
```

### Running Individual Subscripts

Looking to only do certain things? Feel free to run subscripts within the `/scripts` directory, you can also use the `--unattended` flag to run these.
- **`system.sh`**
  - Configure hostname (Defaults to `$(logname)-machine` in unattended)
  - Optimize DNF settings (parallel downloads, fastest mirror, etc.)
  - Install essential tools and updates
  - Set system to performance mode
  - Removes bloatware and disables some Telemetry
- **`gnome.sh`**
  - Disables mouse acceleration
  - Removes default GNOME apps
  - Installs a darkmode theme
- **`coding.sh`**
  - Installs Golang, NodeJS, Bun, Rust, Python3, and Docker
- **`github.sh`** (not available unattended)
  - Asks for and sets your git config user.name and user.email
  - Generates an SSH key, adds it to your system, and tells you to add it to your github account [here](https://github.com/settings/keys)
- **`misc.sh`**
  - Set up Flathub repository for Flatpak
  - Installs
    1) HTop
    2) Neofetch
    3) Installs Telegram
    4) Installs Spotify
    5) Installs OBS
    6) Installs WireGuard
    7) Installs Steam
    8) Installs Discord
    9) Installs Prism Launcher
    10) Installs VLC
    11) Installs Lunar Client
    12) Installs Nvidia Drivers
    13) Installs Visual Studio Code
    

## Extension Manager Settings
![image](https://github.com/user-attachments/assets/7b6ca15e-8ff1-47dd-9e72-b0237e2364af)
