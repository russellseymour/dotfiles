#!/usr/bin/env bash

echo "Installing apt packages, press Ctrl+C to cancel, or enter password."

# Configure additional repositories
sudo add-apt-repository ppa:neovim-ppa/unstable -y

# Update apt after installing new repositories
sudo apt-update

# Install required packages
sudo apt install -y tmux \
    neovim \
    zsh \
    zsh-syntax-highlighting \
    zsh-autosuggestions \
    unzip \
    zoxide \
    eza

# Install oh-my-posh
curl -s https://ohmyposh.dev/install.sh | bash -s

# Install Tmux plugin manager if it does not already exist
if [ ! -d ~/.tmux/plugins/tpm ]; then
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

# Determine if running in WSL, if so then configure accordingly
if grep -qi microsoft /proc/version 2>/dev/null || [ -n "${WSL_DISTRO_NAME}" ]; then
    
    # Add symlinks to allow the GPG agent to work correctly in WSL
    sudo ln -s /mnt/c/Program\ Files/GnuPG/bin/gpg.exe $HOME/.local/bin/gpg
    sudo ln -s /mnt/c/Windows/System32/OpenSSH/ssh.exe $HOME/.local/bin/ssh
    sudo ln -s /mnt/c/Windows/System32/OpenSSH/ssh-add.exe $HOME/.local/bin/ssh-add
    sudo ln -s /mnt/c/Windows/System32/OpenSSH/scp.exe $HOME/.local/bin/scp

    # Configure Git
    git config --global user.email russell.seymour@turtlesystems.co.uk
    git config --global user.name "Russell Seymour"
    git config --global user.signingkey A6E9C075A5A9348B
    git config --global commit.gpgsign true
fi
