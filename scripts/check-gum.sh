#!/bin/bash

# Script to check if gum is installed, and install it if not

set -e

# Check if gum is installed
if command -v gum &> /dev/null; then
    echo "✓ gum is already installed"
    gum --version
    exit 0
fi

echo "gum is not installed. Installing..."

# Check if Homebrew is installed
if ! command -v brew &> /dev/null; then
    echo "Error: Homebrew is not installed. Please install Homebrew first:"
    echo "  /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
    exit 1
fi

# Install gum via Homebrew
echo "Installing gum via Homebrew..."
brew install gum

# Verify installation
if command -v gum &> /dev/null; then
    echo "✓ gum has been successfully installed"
    gum --version
else
    echo "Error: Failed to install gum"
    exit 1
fi

