# ~/.config/fish/config.fish
# Fish stores it's command history in: ~/.local/share/fish/

# 🌱 Preferred editor
set -gx EDITOR zed
set -gx VISUAL zed

# 📂 Add personal bin directories to PATH (local tools, etc.)
# uv (https://docs.astral.sh/uv/)
fish_add_path -g -p $HOME/.local/bin
fish_add_path -g -p $HOME/bin

# OpenCode (https://opencode.ai/)
fish_add_path -g -p $HOME/.opencode/bin

# Bun (https://bun.com/)
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH

# Rust / Cargo (https://rustup.rs/)
fish_add_path -g -p $HOME/.cargo/bin

# mise-en-place (https://mise.jdx.dev/)
# ~/.local/bin/mise activate fish | source

# Android SDK
set -gx ANDROID_HOME ~/Android/Sdk
fish_add_path -g -p $ANDROID_HOME/tools
fish_add_path -g -p $ANDROID_HOME/platform-tools

# Flutter SDK
# fish_add_path -g -p ~/develop/flutter/bin

# 📜 History
set -g fish_history 20000

# ⚙️ Auto cd (type "Downloads" → cd into it)
set -g fish_autocd_enabled 1

# 🎨 fish shell features
set -U fish_greeting
set -g fish_features no-command-not-found

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

    # 🚀 Zellij Auto-start
#    if type -q zellij; and not set -q ZELLIJ
#        exec zellij attach -c
#    end
end
