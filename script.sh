#!/bin/bash

# Define color variables
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Ensure the script is run as root
if [[ $EUID -ne 0 ]]; then
   echo -e "${RED}This script must be run as root${NC}"
   exit 1
fi

# Function to prompt yes/no questions
function prompt_yes_no() {
    while true; do
        read -p "$(echo -e "$1")" yn
        case $yn in
            [Yy]* ) return 0;;
            [Nn]* ) return 1;;
            * ) echo -e "${YELLOW}Please answer yes or no.${NC}";;
        esac
    done
}

# Function to prompt for input
function prompt_input() {
    read -p "$(echo -e "$1")" input
    echo "$input"
}

# Ask for the desired hostname
hostname=$(prompt_input "${CYAN}Enter your desired hostname (e.g., colton-desktop): ${NC}")
hostnamectl set-hostname "$hostname"
echo -e "${GREEN}Hostname set to $hostname${NC}"

# Update dnf configuration to improve performance
echo -e "${CYAN}Updating dnf configuration for improved performance...${NC}"
echo -e "\nmax_parallel_downloads=10\nfastestmirror=True\ndefaultyes=True" | tee -a /etc/dnf/dnf.conf > /dev/null

# Ask if user wants to install DNF plugins
if prompt_yes_no "${BLUE}Would you like to install DNF plugins? (y/n): ${NC}"; then
    dnf install -y dnf-plugins-core
    echo -e "${GREEN}DNF plugins installed${NC}"
else
    echo -e "${YELLOW}Skipping DNF plugins installation${NC}"
fi

# Ask if user wants to upgrade all packages
if prompt_yes_no "${BLUE}Would you like to upgrade packages? (y/n): ${NC}"; then
    dnf upgrade --refresh -y
    echo -e "${GREEN}All packages upgraded${NC}"
else
    echo -e "${YELLOW}Skipping package upgrade${NC}"
fi

# Enable the Cisco OpenH264 repository for multimedia codecs
echo -e "${CYAN}Enabling the Cisco OpenH264 repository...${NC}"
dnf config-manager --enable fedora-cisco-openh264

# Ask if user wants to install RPM Fusion repositories
if prompt_yes_no "${BLUE}Would you like to install RPM Fusion repositories? (y/n): ${NC}"; then
    dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
    echo -e "${GREEN}RPM Fusion repositories installed${NC}"
else
    echo -e "${YELLOW}Skipping RPM Fusion repositories installation${NC}"
fi

# Ask if user wants to update core groups and install development tools and multimedia libraries
if prompt_yes_no "${BLUE}Would you like to update core groups and install development tools and multimedia libraries? (y/n): ${NC}"; then
    dnf groupupdate -y core
    dnf groupinstall -y "Development Tools" "Development Libraries" "Multimedia" "Sound and Video"
    echo -e "${GREEN}Core groups updated and tools installed${NC}"
else
    echo -e "${YELLOW}Skipping core groups update and tools installation${NC}"
fi

# Ask if user wants to update firmware
if prompt_yes_no "${BLUE}Would you like to update your firmware? (y/n): ${NC}"; then
    fwupdmgr refresh --force
    fwupdmgr get-updates
    fwupdmgr update -y
    echo -e "${GREEN}Firmware updated${NC}"
else
    echo -e "${YELLOW}Skipping firmware update${NC}"
fi

# Ask if user wants to add the Flathub repository for Flatpak
if prompt_yes_no "${BLUE}Would you like to add the Flathub repository for Flatpak? (y/n): ${NC}"; then
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    echo -e "${GREEN}Flathub repository added${NC}"
else
    echo -e "${YELLOW}Skipping Flathub repository addition${NC}"
fi

# Enable Network Time Protocol for accurate timekeeping
echo -e "${CYAN}Enabling Network Time Protocol (NTP) for accurate timekeeping...${NC}"
timedatectl set-ntp true

# Set the system to performance power mode
echo -e "${CYAN}Setting the system to performance power mode...${NC}"
systemctl start power-profiles-daemon
powerprofilesctl set performance

# Disable mouse acceleration
echo -e "${CYAN}Disabling mouse acceleration...${NC}"
gsettings set org.gnome.desktop.peripherals.mouse accel-profile 'flat'

# Ask if user wants to disable and mask automatic bug reporting services (ABRT)
if prompt_yes_no "${BLUE}Would you like to disable and mask automatic bug reporting services (ABRT)? (y/n): ${NC}"; then
    systemctl disable --now abrt-watch-log abrt-journal-core abrt-oops abrt-xorg abrt-journal-qabrtd
    systemctl mask abrt-watch-log abrt-journal-core abrt-oops abrt-xorg abrt-journal-qabrtd
    echo -e "${GREEN}ABRT services disabled and masked${NC}"
else
    echo -e "${YELLOW}Skipping ABRT services disablement${NC}"
fi

# Ask if user wants to remove Fedora Workstation repositories
if prompt_yes_no "${BLUE}Would you like to remove Fedora Workstation repositories (more telemetry)? (y/n): ${NC}"; then
    dnf remove -y fedora-workstation-repositories
    echo -e "${GREEN}Fedora Workstation repositories removed${NC}"
else
    echo -e "${YELLOW}Skipping Fedora Workstation repositories removal${NC}"
fi

# Ask if user wants to remove default gnome apps
if prompt_yes_no "${BLUE}Would you like to remove default Gnome apps (Maps, Weather, Contacts, Music)? (y/n): ${NC}"; then
    dnf remove -y rhythmbox gnome-maps gnome-weather gnome-contacts gnome-photos gnome-music
    echo -e "${GREEN}Default Gnome apps removed${NC}"
else
    echo -e "${YELLOW}Skipping Gnome apps removal${NC}"
fi


# Ask if user wants to remove default libreoffice apps
if prompt_yes_no "${BLUE}Would you like to remove default Libreoffice apps? (y/n): ${NC}"; then
    dnf remove -y libreoffice*
    echo -e "${GREEN}Libreoffice suite removed${NC}"
else
    echo -e "${YELLOW}Skipping Libreoffice suite removal${NC}"
fi

echo -e "${CYAN}Autoremoving unneeded dependencies${NC}"
dnf autoremove -y

# Ask if user wants dark mode and theming and stuff
if prompt_yes_no "${BLUE}Would you like to use a dark theme? (y/n): ${NC}"; then
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
    mkdir -p ~/.local/share/backgrounds/.hidden
    wget -O ~/.local/share/backgrounds/.hidden/background.png https://raw.githubusercontent.com/265866/Fedora-Installation/main/background.png
    gsettings set org.gnome.desktop.background picture-uri "file:///home/$(whoami)/.local/share/backgrounds/.hidden/background.png"
    gsettings set org.gnome.desktop.background picture-uri-dark "file:///home/$(whoami)/.local/share/backgrounds/.hidden/background.png"
    chmod 444 ~/.local/share/backgrounds/.hidden/background.png
    dnf install -y gnome-tweaks gtk3 gnome-themes-extra gtk-murrine-engine sassc
    flatpak install flathub com.mattjakeman.ExtensionManager -y
    
    echo -e "${GREEN}Dark theme added & Enabled${NC}"
else
    echo -e "${YELLOW}Skipping addding dark theme${NC}"
fi

# Ask if user wants telegran
if prompt_yes_no "${BLUE}Would you like to install Telegram? (y/n): ${NC}"; then
    dnf install -y telegram-desktop
    echo -e "${GREEN}Telegram installed${NC}"
else
    echo -e "${YELLOW}Skipping installing Telegram${NC}"
fi

# Ask if user wants golang
if prompt_yes_no "${BLUE}Would you like to install Golang? (y/n): ${NC}"; then
    dnf install -y golang
    echo -e "${GREEN}Golang installed${NC}"
else
    echo -e "${YELLOW}Skipping installing Golang${NC}"
fi

# Ask if user wants Visual Studio Code
if prompt_yes_no "${BLUE}Would you like to install Visual Studio Code? (y/n): ${NC}"; then
    sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
    echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo > /dev/null
    dnf check-update
    dnf install code
    echo -e "${GREEN}Visual Studio Code installed${NC}"
else
    echo -e "${YELLOW}Skipping installing Visual Studio Code${NC}"
fi

# Ask if user wants Lunar Client
if prompt_yes_no "${BLUE}Would you like to install Lunar Client? (y/n): ${NC}"; then
    flatpak install flathub com.lunarclient.LunarClient -y
    echo -e "${GREEN}Lunar Client installed${NC}"
else
    echo -e "${YELLOW}Skipping installing Lunar Client${NC}"
fi

# Ask if user wants Prop Nvidia Drivers
if prompt_yes_no "${BLUE}Would you like to install proprietary Nvidia Drivers? (y/n): ${NC}"; then
    dnf install -y akmod-nvidia xorg-x11-drv-nvidia-cuda
    echo -e "${GREEN}Nvidia Drivers installed${NC}"
else
    echo -e "${YELLOW}Skipping installing Nvidia Drivers${NC}"
fi

# Ask if user wants Spotify
if prompt_yes_no "${BLUE}Would you like to install Spotify? (y/n): ${NC}"; then
    flatpak install flathub com.spotify.Client -y
    echo -e "${GREEN}Spotify installed${NC}"
else
    echo -e "${YELLOW}Skipping installing Spotify${NC}"
fi

# Ask if user wants Docker
if prompt_yes_no "${BLUE}Would you like to install Docker? (y/n): ${NC}"; then
    dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
    dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    systemctl start docker
    echo -e "${GREEN}Docker installed${NC}"
else
    echo -e "${YELLOW}Skipping installing Docker${NC}"
fi

# Ask if user wants Bun
if prompt_yes_no "${BLUE}Would you like to install Bun? (y/n): ${NC}"; then
    curl -fsSL https://bun.sh/install | bash
    source ~/.bashrc
    echo -e "${GREEN}Bun installed${NC}"
else
    echo -e "${YELLOW}Skipping installing Bun${NC}"
fi

# Ask if user wants NodeJS
if prompt_yes_no "${BLUE}Would you like to install NodeJS? (y/n): ${NC}"; then
    dnf install -y nodejs
    echo -e "${GREEN}Bun installed${NC}"
else
    echo -e "${YELLOW}Skipping installing Bun${NC}"
fi

# Ask if user wants Rust
if prompt_yes_no "${BLUE}Would you like to install Rust? (y/n): ${NC}"; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
    . "$HOME/.cargo/env"
    echo -e "${GREEN}Rust installed${NC}"
else
    echo -e "${YELLOW}Skipping installing Rust${NC}"
fi

# Ask if user wants OBS
if prompt_yes_no "${BLUE}Would you like to install OBS? (y/n): ${NC}"; then
    dnf install -y obs-studio
    echo -e "${GREEN}OBS installed${NC}"
else
    echo -e "${YELLOW}Skipping installing OBS${NC}"
fi


# Ask if user wants Wireguard
if prompt_yes_no "${BLUE}Would you like to install Wireguard? (y/n): ${NC}"; then
    dnf install -y wireguard-tools
    echo -e "${GREEN}Wireguard installed${NC}"
else
    echo -e "${YELLOW}Skipping installing Wireguard${NC}"
fi

# Ask if user wants Steam
if prompt_yes_no "${BLUE}Would you like to install Steam? (y/n): ${NC}"; then
    dnf install -y steam
    echo -e "${GREEN}Steam installed${NC}"
else
    echo -e "${YELLOW}Skipping installing Steam${NC}"
fi

# Ask if user wants Python3
if prompt_yes_no "${BLUE}Would you like to install Python3? (y/n): ${NC}"; then
    dnf install -y python3
    echo -e "${GREEN}Python3 installed${NC}"
else
    echo -e "${YELLOW}Skipping installing Python3${NC}"
fi

# Ask if user wants Discord
if prompt_yes_no "${BLUE}Would you like to install Discord? (y/n): ${NC}"; then
    flatpak install flathub com.discordapp.Discord -y
    echo -e "${GREEN}Discord installed${NC}"
else
    echo -e "${YELLOW}Skipping installing Discord${NC}"
fi

# Ask if user wants Prism Launcher
if prompt_yes_no "${BLUE}Would you like to install Prism Launcher (Basically MultiMC)? (y/n): ${NC}"; then
    flatpak install flathub org.prismlauncher.PrismLauncher -y
    echo -e "${GREEN}Prism Launcher installed${NC}"
else
    echo -e "${YELLOW}Skipping installing Prism Launcher${NC}"
fi

# Ask if user wants VLC
if prompt_yes_no "${BLUE}Would you like to install VLC? (y/n): ${NC}"; then
    flatpak install flathub org.videolan.VLC -y
    echo -e "${GREEN}VLC installed${NC}"
else
    echo -e "${YELLOW}Skipping installing VLC${NC}"
fi


# Install Neofetch directly without using COPR
dnf install -y neofetch htop

neofetch

# End of script
echo -e "${CYAN}System setup complete!${NC}"
