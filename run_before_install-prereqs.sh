#!/usr/bin/env bash

# Install homebrew
if ! /opt/homebrew/bin/brew &> /dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
