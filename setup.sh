#!/bin/bash
set -e

echo "==> Starting dotfiles setup..."

# Force copy a file or directory
force_copy() {
    local src="$1" dest="$2"
    rm -rf "$dest"
    cp -rf "$src" "$dest"
    echo "✓ Copied $src → $dest"
}

# Make all .sh scripts executable
make_scripts_executable() {
    find "$1" -type f -name "*.sh" -exec chmod +x {} \;
    echo "✓ Made scripts executable in $1"
}

# 1. .bashrc
echo "-> Copying .bashrc"
force_copy "home/.bashrc" "$HOME/.bashrc"

# 2. ~/bin
echo "-> Installing scripts to ~/bin"
mkdir -p "$HOME/bin"
force_copy "home/bin/." "$HOME/bin"
make_scripts_executable "$HOME/bin"

# 3. foot.ini
if command -v foot &>/dev/null; then
    echo "-> foot terminal detected"
    mkdir -p "$HOME/.config/foot"
    force_copy "config/foot/foot.ini" "$HOME/.config/foot/foot.ini"
else
    echo "--> foot terminal not found, skipping foot.ini"
fi

# 4. Setup scripts
chmod +x ./setup-themes.sh ./setup-fonts.sh

# 5. Run optional scripts
read -p "Run theme setup? (y/n): " a && [[ "$a" =~ ^[Yy]$ ]] && ./setup-themes.sh
read -p "Run font setup? (y/n): " b && [[ "$b" =~ ^[Yy]$ ]] && ./setup-fonts.sh

echo "==> Dotfiles setup complete."
