#!/usr/bin/env bash

echo "Installing apt packages, press Ctrl+C to cancel, or enter password."

# Configure additional repositories
sudo add-apt-repository ppa:neovim-ppa/unstable -y

# Update apt after installing new repositories
sudo apt-update

# Install required packages
sudo apt install -y tmux \
    neovim \
    zsh

