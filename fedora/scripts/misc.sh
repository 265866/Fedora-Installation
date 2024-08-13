#!/bin/bash

# Check for unattended flag
UNATTENDED=0
if [[ "$1" == "--unattended" ]]; then
    UNATTENDED=1
fi

# Function to prompt yes/no questions
function prompt_yes_no() {
    if [ $UNATTENDED -eq 1 ]; then
        return 0 # Assume "yes" for all prompts
    fi

    while true; do
        read -p "$(echo -e "$1")" yn
        case $yn in
            [Yy]* ) return 0;;
            [Nn]* ) return 1;;
            * ) echo -e "${YELLOW}Please answer y or n.${NC}";;
        esac
    done
}

# Define color variables
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Ask if user wants to add the Flathub repository for Flatpak
if prompt_yes_no "${BLUE}Would you like to add the Flathub repository for Flatpak? (y/n): ${NC}"; then
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    echo -e "${GREEN}Flathub repository added${NC}"
else
    echo -e "${YELLOW}Skipping Flathub repository addition${NC}"
fi

# Ask if user wants Telegram
if prompt_yes_no "${BLUE}Would you like to install Telegram? (y/n): ${NC}"; then
    dnf install -y telegram-desktop
    echo -e "${GREEN}Telegram installed${NC}"
else
    echo -e "${YELLOW}Skipping installing Telegram${NC}"
fi

# Ask if user wants Spotify
if prompt_yes_no "${BLUE}Would you like to install Spotify? (y/n): ${NC}"; then
    flatpak install flathub com.spotify.Client -y
    echo -e "${GREEN}Spotify installed${NC}"
else
    echo -e "${YELLOW}Skipping installing Spotify${NC}"
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

# Ask if user wants Lunar Client
if prompt_yes_no "${BLUE}Would you like to install Lunar Client? (y/n): ${NC}"; then
    flatpak install flathub com.lunarclient.LunarClient -y
    echo -e "${GREEN}Lunar Client installed${NC}"
else
    echo -e "${YELLOW}Skipping installing Lunar Client${NC}"
fi

# Ask if user wants Nvidia Drivers
if prompt_yes_no "${BLUE}Would you like to install Nvidia Drivers? (y/n): ${NC}"; then
    dnf install -y akmod-nvidia xorg-x11-drv-nvidia-cuda
    echo -e "${GREEN}Nvidia Drivers installed${NC}"
else
    echo -e "${YELLOW}Skipping installing Nvidia Drivers${NC}"
fi

# Install Neofetch and htop
dnf install -y neofetch htop

neofetch
