#!/bin/bash

set -e

# ╭──────────────────────────────────────────────╮
# │              Dotfiles Setup Script           │
# │             Clean • Minimal • Smooth         │
# ╰──────────────────────────────────────────────╯

# Copy file or directory with confirmation
safe_copy() {
    local src="$1" dest="$2"
    if [[ -e "$dest" || -L "$dest" ]]; then
        read -p "→ '$dest' exists. Overwrite? (y/n): " confirm
        [[ "$confirm" =~ ^[Yy]$ ]] || { echo "⤷ Skipped: $dest"; return; }
    fi
    cp -rf "$src" "$dest"
    echo "✔ Copied → $dest"
}

# Make all .sh scripts executable in a given directory
make_scripts_executable() {
    local dir="$1"
    find "$dir" -type f -name "*.sh" -exec chmod +x {} \;
    echo "✔ Made scripts in '$dir' executable"
}

echo "⚙️  Starting setup..."

# 1. .bashrc
echo "⤷ Setting up .bashrc"
safe_copy "home/.bashrc" "$HOME/.bashrc"

# 2. bin/
echo "⤷ Installing custom scripts to ~/bin"
mkdir -p "$HOME/bin"
safe_copy "home/bin/." "$HOME/bin"
make_scripts_executable "$HOME/bin"

# 3. foot.ini
if command -v foot &> /dev/null; then
    echo "⤷ foot terminal detected"
    mkdir -p "$HOME/.config/foot"
    safe_copy "config/foot/foot.ini" "$HOME/.config/foot/foot.ini"
else
    echo "⚠️  foot terminal not found — skipping foot.ini"
fi

# 4. Ensure executable permission for theme and font setup scripts
echo "⤷ Ensuring executable permissions for theme and font setup scripts..."
chmod +x ./setup-themes.sh
chmod +x ./setup-fonts.sh

# 5. Ask about custom themes installation
read -p "⤷ Would you like to install custom icons and cursors? (y/n): " install_themes
if [[ "$install_themes" =~ ^[Yy]$ ]]; then
    echo "⤷ Running theme setup script..."
    ./setup-themes.sh
else
    echo "⤷ Skipping theme setup."
fi

# 6. Ask about custom font installation
read -p "⤷ Would you like to install custom fonts? (y/n): " install_fonts
if [[ "$install_fonts" =~ ^[Yy]$ ]]; then
    echo "⤷ Running font setup script..."
    ./setup-fonts.sh
else
    echo "⤷ Skipping font setup."
fi

echo "✅ Setup complete!"
