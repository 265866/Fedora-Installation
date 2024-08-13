#!/bin/bash

# Check if the script is run as root (sudo)
if [ "$(id -u)" == "0" ]; then
    echo "This script mustn't be run as root. Please run as your normal user."
    exit 1
fi

SSH_PUB_KEY=$(./scripts/ssh-generate.sh 2>&1 >/dev/tty)

read -p "Enter your GitHub username: " GITHUB_USERNAME

if [ -z "${GITHUB_USERNAME}" ]; then
    echo "GitHub username cannot be empty."
    exit 1
fi

git config --global user.name "$GITHUB_USERNAME"

read -p "Enter your GitHub email: " GITHUB_EMAIL

if [ -z "${GITHUB_EMAIL}" ]; then
    echo "GitHub email cannot be empty."
    exit 1
fi

git config --global user.email "$GITHUB_EMAIL"
