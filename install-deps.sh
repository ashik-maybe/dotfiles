#!/bin/bash

set -e

# ========== Helper Functions ==========

# Check if a command exists
is_installed() {
    command -v "$1" &> /dev/null
}

# Install a package via DNF if not already installed
install_if_missing() {
    local pkg="$1"
    if ! is_installed "$pkg"; then
        echo "Installing $pkg..."
        sudo dnf install -y "$pkg"
    else
        echo "$pkg is already installed."
    fi
}

# ========== Essentials ==========

essential_tools=(curl wget git)
third_party_tools=(ffmpeg yt-dlp aria2)

install_essentials() {
    echo -e "\n🔧 Installing essential tools..."
    for tool in "${essential_tools[@]}"; do
        install_if_missing "$tool"
    done
}

# ========== RPM Fusion ==========

enable_rpmfusion() {
    echo -e "\n📦 Enabling RPM Fusion repositories..."
    if ! sudo dnf repolist | grep -q rpmfusion-free; then
        sudo dnf install -y \
            https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
            https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
    else
        echo "RPM Fusion is already enabled."
    fi
}

# ========== Media Tools ==========

install_media_tools() {
    echo -e "\n🎞️ Installing media tools (ffmpeg, yt-dlp, aria2)..."
    install_if_missing ffmpeg
    install_if_missing yt-dlp
    install_if_missing aria2
}

# ========== Flatpak Support ==========

setup_flatpak() {
    echo -e "\n📦 Checking Flatpak support..."
    if ! is_installed flatpak; then
        echo "Flatpak not found. Installing..."
        sudo dnf install -y flatpak
    else
        echo "Flatpak is already installed."
    fi

    # Add Flathub repo if missing
    if ! flatpak remotes | grep -q flathub; then
        echo "Adding Flathub remote..."
        sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    else
        echo "Flathub remote already exists."
    fi

    # Install Flatseal if not present
    if ! flatpak list | grep -q com.github.tchx84.Flatseal; then
        echo "Installing Flatseal..."
        flatpak install -y flathub com.github.tchx84.Flatseal
    else
        echo "Flatseal is already installed."
    fi
}

# ========== Main ==========

echo "🚀 Starting system dependency setup..."
install_essentials
enable_rpmfusion
install_media_tools
setup_flatpak
echo -e "\n✅ All dependencies installed successfully!"
