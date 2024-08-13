# Fedora Post-Installation Setup Scripts

This repository contains a set of Bash scripts designed to automate the post-installation configuration of a Fedora system. The scripts allow for both attended and unattended execution.

## Overview

### Scripts

- **`postinstall.sh`**: The main script that coordinates the execution of all other scripts.
- **`system.sh`**: Configures system settings such as hostname, DNF performance, and installs essential tools.
- **`gnome.sh`**: Customizes GNOME settings, removes unnecessary applications, and applies theming.
- **`coding.sh`**: Installs development tools and languages such as Go, NodeJS, Rust, and Docker.
- **`misc.sh`**: Installs additional software like Telegram, Spotify, OBS, Discord, and more.
- **`ssh-generate.sh`**: Generates an SSH key and displays the public key for GitHub configuration.
- **`github.sh`**: Sets up GitHub configuration, including SSH key integration.
  
## Usage

### Running the Main Script

To run the main script, execute `postinstall.sh`:

```bash
git clone https://github.com/265866/Fedora-Installation.git
cd Fedora-Installation
chmod +x ./postinstall.sh
sudo ./postinstall.sh
```

To run the main script in unattended mode, follow the instructions above, except add an --unattended flag to `postinstall.sh`

```bash
git clone https://github.com/265866/Fedora-Installation.git
cd Fedora-Installation
chmod +x ./postinstall.sh
sudo ./postinstall.sh --unattended
```

### Running Subscripts

Looking to only do certain things? Feel free to run subscripts within the `/scripts` directory, you can also use the --unattended flag to run these.
- `system.sh`
  1) Asks for and sets your machine's hostname (defaults to `$(logname)-machine` in unattended mode)
  2) Updates your DNF configuration by increasing your max parallel download limit and using the fastest mirror by default
  3) Installs DNF plugins (dnf-plugins-core)
  4) Upgrades your packages
  5) Enables the Cisco OpenH264 repository for multimedia codecs 
  6) Installs RPM Fusion repositories
  7) Update core groups and installs development tools and multimedia libraries
  8) Updates firmware
  9) Enables NTP (Network Time Protocol)
  10) Sets System to Power Performance Mode
  11) Disables and masks automatic bug reporting
  12) Removes Fedora Workstation Repositories
  13) Removes default Libreoffice apps
  14) Removes unneeded dependencies
- `gnome.sh`
  1) Disables mouse acceleration
  2) Removes default Gnome apps
  3) Installs a darkmode theme
- `coding.sh`
  1) Installs Golang
  2) Installs NodeJS
  3) Installs Bun
  4) Installs Rust
  5) Installs Docker
  6) Installs Python3
- `github.sh` (not available unattended)
  1) Asks for and sets your git config user.name and user.email
  2) Generates an SSH key, adds it to your system, and tells you to add it to your github account (https://github.com/settings/keys)
- `misc.sh`
  1) Adds the Flathub repository for Flatpak
  2) Installs Visual Studio Code
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
  13) Installs Neofetch
  14) Installs HTop

## Extension Manager Settings
![image](https://github.com/user-attachments/assets/7b6ca15e-8ff1-47dd-9e72-b0237e2364af)
