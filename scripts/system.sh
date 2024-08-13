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

# Function to prompt for input
function prompt_input() {
    if [ $UNATTENDED -eq 1 ]; then
        echo "$2" # Use the provided default value in unattended mode
    else
        read -p "$(echo -e "$1")" input
        echo "$input"
    fi
}

# Ask for the desired hostname
DEFAULT_HOSTNAME="$(logname)-machine"
hostname=$(prompt_input "${CYAN}Enter your desired hostname (e.g., ${DEFAULT_HOSTNAME}): ${NC}" "${DEFAULT_HOSTNAME}")
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

# Enable Network Time Protocol for accurate timekeeping
echo -e "${CYAN}Enabling Network Time Protocol (NTP) for accurate timekeeping...${NC}"
timedatectl set-ntp true

# Set the system to performance power mode
echo -e "${CYAN}Setting the system to performance power mode...${NC}"
systemctl start power-profiles-daemon
powerprofilesctl set performance

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

# Ask if user wants to remove default libreoffice apps
if prompt_yes_no "${BLUE}Would you like to remove default Libreoffice apps? (y/n): ${NC}"; then
    dnf remove -y libreoffice*
    echo -e "${GREEN}Libreoffice suite removed${NC}"
else
    echo -e "${YELLOW}Skipping Libreoffice suite removal${NC}"
fi

echo -e "${CYAN}Autoremoving unneeded dependencies${NC}"
dnf autoremove -y
