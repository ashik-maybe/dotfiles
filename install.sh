#!/bin/zsh

DOTFILES_DIR="$HOME/dotfiles"

# Symlink Zsh config
ln -sf "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc"

# Symlink Starship config (if you added it)
mkdir -p "$HOME/.config"
ln -sf "$DOTFILES_DIR/starship/.config/starship.toml" "$HOME/.config/starship.toml"

# Symlink Git config (optional)
ln -sf "$DOTFILES_DIR/git/.gitconfig" "$HOME/.gitconfig"

# Symlink VS Code settings (optional)
mkdir -p "$HOME/.config/Code"
ln -sf "$DOTFILES_DIR/vscode/User" "$HOME/.config/Code/User"

# Install Starship if not installed
if ! command -v starship &> /dev/null; then
    echo "Installing Starship..."
    curl -sS https://starship.rs/install.sh | sh
fi

echo "Dotfiles installed! Reload Zsh with: source ~/.zshrc"