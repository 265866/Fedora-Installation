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
        read -p "$(echo -e $1)" yn
        case $yn in
            [Yy]* ) return 0;;
            [Nn]* ) return 1;;
            * ) echo -e "${YELLOW}Please answer yes or no.${NC}";;
        esac
    done
}

# Function to prompt for input
function prompt_input() {
    read -p "$(echo -e $1)" input
    echo "$input"
}

# Ask for the desired hostname
echo -e "${CYAN}Enter your desired hostname (e.g., colton-desktop):${NC}"
hostname=$(prompt_input "> ")
hostnamectl set-hostname "$hostname"
echo -e "${GREEN}Hostname set to $hostname${NC}"

# Update dnf configuration to improve performance
echo -e "${CYAN}Updating dnf configuration for improved performance...${NC}"
echo -e "\nmax_parallel_downloads=10\nfastestmirror=True\ndefaultyes=True" | tee -a /etc/dnf/dnf.conf > /dev/null
echo -e "${GREEN}dnf configuration updated${NC}"

# Ask if user wants to install DNF plugins
if prompt_yes_no "${BLUE}Would you like to install DNF plugins? (y/n): ${NC}"; then
    dnf install -y dnf-plugins-core
    echo -e "${GREEN}DNF plugins installed${NC}"
else
    echo -e "${YELLOW}Skipping DNF plugins installation${NC}"
fi

# Ask if user wants to upgrade all packages
if prompt_yes_no "${BLUE}Would you like to upgrade all packages? (y/n): ${NC}"; then
    dnf upgrade --refresh -y
    echo -e "${GREEN}All packages upgraded${NC}"
else
    echo -e "${YELLOW}Skipping package upgrade${NC}"
fi

# Enable the Cisco OpenH264 repository for multimedia codecs
echo -e "${CYAN}Enabling the Cisco OpenH264 repository...${NC}"
dnf config-manager --enable fedora-cisco-openh264
echo -e "${GREEN}Cisco OpenH264 repository enabled${NC}"

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
echo -e "${GREEN}NTP enabled${NC}"

# Set the system to performance power mode
echo -e "${CYAN}Setting the system to performance power mode...${NC}"
systemctl start power-profiles-daemon
powerprofilesctl set performance
echo -e "${GREEN}Performance power mode set${NC}"

# Disable mouse acceleration
echo -e "${CYAN}Disabling mouse acceleration...${NC}"
gsettings set org.gnome.desktop.peripherals.mouse accel-profile 'flat'
echo -e "${GREEN}Mouse acceleration disabled${NC}"

# Ask if user wants to disable and mask automatic bug reporting services (ABRT)
if prompt_yes_no "${BLUE}Would you like to disable and mask automatic bug reporting services (ABRT)? (y/n): ${NC}"; then
    systemctl disable --now abrt-watch-log abrt-journal-core abrt-oops abrt-xorg abrt-journal-qabrtd
    systemctl mask abrt-watch-log abrt-journal-core abrt-oops abrt-xorg abrt-journal-qabrtd
    echo -e "${GREEN}ABRT services disabled and masked${NC}"
else
    echo -e "${YELLOW}Skipping ABRT services disablement${NC}"
fi

# Ask if user wants to remove Fedora Workstation repositories
if prompt_yes_no "${BLUE}Would you like to remove Fedora Workstation repositories? (y/n): ${NC}"; then
    dnf remove -y fedora-workstation-repositories
    echo -e "${GREEN}Fedora Workstation repositories removed${NC}"
else
    echo -e "${YELLOW}Skipping Fedora Workstation repositories removal${NC}"
fi

# Ask if user wants to enable COPR repository for Neofetch and install Neofetch
if prompt_yes_no "${BLUE}Would you like to install Neofetch? (y/n): ${NC}"; then
    dnf copr enable -y konimex/neofetch
    dnf install -y neofetch
    echo -e "${GREEN}Neofetch installed${NC}"
    neofetch
else
    echo -e "${YELLOW}Skipping Neofetch installation${NC}"
fi

# End of script
echo -e "${CYAN}System setup complete!${NC}"