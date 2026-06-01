# ~/.config/fish/config.fish
# Path to fish history: ~/.local/share/fish/

# Environment variables
set -gx EDITOR zed
set -gx VISUAL zed

# System paths
fish_add_path -g -p $HOME/.local/bin
fish_add_path -g -p $HOME/bin
fish_add_path -g -p $HOME/.opencode/bin

# Bun environment
set -gx BUN_INSTALL "$HOME/.bun"
fish_add_path -g -p $BUN_INSTALL/bin

# Mobile development SDK paths
set -gx ANDROID_HOME $HOME/Android/Sdk
fish_add_path -g -p $ANDROID_HOME/tools
fish_add_path -g -p $ANDROID_HOME/platform-tools
fish_add_path -g -p $HOME/develop/flutter/bin

# Runtime manager (mise-en-place)
# ~/.local/bin/mise activate fish | source

# Shell configuration
set -g fish_history 20000
set -g fish_autocd_enabled 1
set -U fish_greeting
set -g fish_features no-command-not-found

# Interactive sessions configuration
if status is-interactive
    # Prompt initialization (Starship)
    if type -q starship
        starship init fish | source
    end

    # Directory navigation (Zoxide)
    if type -q zoxide
        zoxide init fish | source
    end

    # Fuzzy finder configuration (FZF)
    if type -q fzf
        set -gx FZF_DEFAULT_OPTS --height=40% --layout=reverse --border --preview-window=right:50%
    end

    # Terminal multiplexer auto-start (Zellij)
    # if type -q zellij; and not set -q ZELLIJ
    #     exec zellij attach -c
    # end
end
