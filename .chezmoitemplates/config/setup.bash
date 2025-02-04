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

# Install oh-my-posh
curl -s https://ohmyposh.dev/install.sh | bash -s

# Install Tmux plugin manager if it does not already exist
if [ ! -d ~/.tmux/plugins/tpm ]; then
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi