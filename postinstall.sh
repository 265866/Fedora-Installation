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

chmod +x ./scripts/*

# Get the normal user's username
USER_NAME=$(logname)


if [ $UNATTENDED -eq 1 ]; then
    echo -e "${CYAN}Running system setup...${NC}"
    bash ./scripts/system.sh --unattended
    echo -e "${CYAN}Running GNOME configuration...${NC}"
    bash ./scripts/gnome.sh --unattended
    echo -e "${CYAN}Running coding tools installation...${NC}"
    bash ./scripts/coding.sh --unattended
    echo -e "${RED}Skipping GitHub setup as not possible unattended...${NC}"
    echo -e "${CYAN}Running miscellaneous installations...${NC}"
    bash ./scripts/misc.sh --unattended
    echo -e "${CYAN}System setup complete!${NC}"
    reboot
else
    echo -e "${CYAN}Running system setup...${NC}"
    bash ./scripts/system.sh
    echo -e "${CYAN}Running GNOME configuration...${NC}"
    bash ./scripts/gnome.sh
    echo -e "${CYAN}Running coding tools installation...${NC}"
    bash ./scripts/coding.sh
    echo -e "${CYAN}Running GitHub setup...${NC} (as $USER_NAME)"
    sudo -u "$USER_NAME" bash ./scripts/github.sh
    echo -e "${CYAN}Running miscellaneous installations...${NC}"
    bash ./scripts/misc.sh
    echo -e "${CYAN}System setup complete!${NC}"
    if prompt_yes_no "${BLUE}Would you like to reboot the system now? (y/n): ${NC}"; then
        echo -e "${GREEN}Rebooting system...${NC}"
        reboot
    else
        echo -e "${YELLOW}Reboot skipped. Please remember to reboot later to finish installing everything.${NC}"
    fi
fi