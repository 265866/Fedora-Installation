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

# Get the normal user's username
USER_NAME=$(logname)

echo -e "${CYAN}Running system setup...${NC}"
bash ./scripts/system.sh

echo -e "${CYAN}Running GNOME configuration...${NC}"
bash ./scripts/gnome.sh

echo -e "${CYAN}Running coding tools installation...${NC}"
bash ./scripts/coding.sh

echo -e "${CYAN}Running Docker installation...${NC}"
bash ./scripts/docker.sh

echo -e "${CYAN}Running GitHub setup...${NC} (as $USER_NAME)"
sudo -u "$USER_NAME" bash ./scripts/github.sh

echo -e "${CYAN}Running miscellaneous installations...${NC}"
bash ./scripts/misc.sh

echo -e "${CYAN}System setup complete!${NC}"
