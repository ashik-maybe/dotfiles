# ~/.config/fish/config.fish
# Fish stores it's command history in: ~/.local/share/fish/

# 🌱 Preferred editor
set -gx EDITOR zed
set -gx VISUAL zed

# 📂 Add personal bin directories to PATH (local tools, etc.)
fish_add_path -g -p $HOME/.local/bin
fish_add_path -g -p $HOME/bin

# Bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH

# Android SDK
set -gx ANDROID_HOME ~/Android/Sdk
fish_add_path -g -p $ANDROID_HOME/tools
fish_add_path -g -p $ANDROID_HOME/platform-tools

# Flutter SDK
# fish_add_path -g -p ~/develop/flutter/bin

# mise-en-place
# ~/.local/bin/mise activate fish | source

# 📜 History
set -g fish_history 20000

# ⚙️ Auto cd (type "Downloads" → cd into it)
set -g fish_autocd_enabled 1

# 🎨 Silence welcome message
set -U fish_greeting

if status is-interactive
    # ✨ Optimized Starship
    if type -q starship
        source (starship init fish --print-full-init | psub)
    end

    # 🔁 Optimized Zoxide
    if type -q zoxide
        source (zoxide init fish | psub)
    end

    # 🔍 FZF Config
    if type -q fzf
        set -gx FZF_DEFAULT_OPTS --height=40% --layout=reverse --border --preview-window=right:50%
    end
end
