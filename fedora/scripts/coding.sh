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

# Ask if user wants to install Golang
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
    dnf install -y code
    echo -e "${GREEN}Visual Studio Code installed${NC}"
else
    echo -e "${YELLOW}Skipping installing Visual Studio Code${NC}"
fi

# Ask if user wants NodeJS
if prompt_yes_no "${BLUE}Would you like to install NodeJS? (y/n): ${NC}"; then
    dnf install -y nodejs
    echo -e "${GREEN}NodeJS installed${NC}"
else
    echo -e "${YELLOW}Skipping installing NodeJS${NC}"
fi

# Ask if user wants Bun
if prompt_yes_no "${BLUE}Would you like to install Bun? (y/n): ${NC}"; then
    sudo -u "$(logname)" bash -c 'curl -fsSL https://bun.sh/install | bash'
    sudo -u "$(logname)" bash -c 'source ~/.bashrc'
    echo -e "${GREEN}Bun installed${NC}"
else
    echo -e "${YELLOW}Skipping installing Bun${NC}"
fi

# Ask if user wants Rust
if prompt_yes_no "${BLUE}Would you like to install Rust? (y/n): ${NC}"; then
    sudo -u "$(logname)" bash -c 'curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y'
    sudo -u "$(logname)" bash -c '. "$HOME/.cargo/env"'
    echo -e "${GREEN}Rust installed${NC}"
else
    echo -e "${YELLOW}Skipping installing Rust${NC}"
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
