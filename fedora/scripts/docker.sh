#!/bin/bash

# Function to prompt yes/no questions
function prompt_yes_no() {
    while true; do
        read -p "$(echo -e "$1")" yn
        case $yn in
            [Yy]* ) return 0;;
            [Nn]* ) return 1;;
            * ) echo -e "${YELLOW}Please answer y or n.${NC}";;
        esac
    done
}

# Ask if user wants Docker
if prompt_yes_no "${BLUE}Would you like to install Docker? (y/n): ${NC}"; then
    dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
    dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    systemctl start docker
    echo -e "${GREEN}Docker installed${NC}"
else
    echo -e "${YELLOW}Skipping installing Docker${NC}"
fi
