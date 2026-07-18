# ~/.config/fish/config.fish

# ==============================================================================
# ENVIRONMENT VARIABLES
# ==============================================================================
set -gx EDITOR nano
set -gx VISUAL nano

# ==============================================================================
# THE TWO MASTER DIRECTORIES (OPERATIONAL GUIDE)
# ==============================================================================
#
# 1. ~/bin (The Execution Hub)
#    - Purpose: Stores individual executable files or SYMLINKS to tools.
#    - Rule: If you want to run a command globally in the terminal, it goes here.
#
# 2. ~/sdk (The Development Storage)
#    - Purpose: Stores intact software development kits, toolchains, and packages.
#    - Rule: Extracted folders (like Go, Node, or Bun) live here in isolation.
#
# ------------------------------------------------------------------------------
# 🛠️ HOW TO ADD NEW DEV TOOLS IN THE FUTURE (NEVER TOUCH THIS FILE AGAIN)
# ------------------------------------------------------------------------------
#
# METHOD A: For standalone binaries (e.g., a single compiled tool)
#    1. Move the file straight to your execution hub:
#       mv downloaded_tool ~/bin/
#    2. Make it executable:
#       chmod +x ~/bin/downloaded_tool
#
# METHOD B: For full toolchains (e.g., Go, Node, Zig)
#    1. Create a dedicated directory inside your SDK master folder:
#       mkdir -p ~/sdk/go
#    2. Extract the archive contents directly into that directory:
#       tar -C ~/sdk/go --strip-components=1 -xzf go1.XX.X.linux-amd64.tar.gz
#    3. Expose the compiler binary to the system by linking it into your execution hub:
#       ln -sf ~/sdk/go/bin/go ~/bin/go
#       ln -sf ~/sdk/go/bin/gofmt ~/bin/gofmt
#
# METHOD C: Updating an existing SDK
#    1. Wipe the old toolchain folder: rm -rf ~/sdk/go
#    2. Drop the new version in its place: tar -C ~/sdk/go ...
#    3. The symlink in ~/bin points to the exact same path, so it updates instantly!
#
# ==============================================================================
# THE MASTER PATHS SETTING
# ==============================================================================
# -g sets global scope.
# -m ensures they move to the very front of your system PATH to override defaults.
fish_add_path -g -m $HOME/.local/bin
fish_add_path -g -m $HOME/sdk             # Master SDK Storage
fish_add_path -g -m $HOME/bin             # Master Execution Hub

# ==============================================================================
# SHELL OPTIONS & INTERACTIVE CONFIG
# ==============================================================================
set -g fish_history 20000
set -g fish_autocd_enabled 1
set -U fish_greeting
set -g fish_features no-command-not-found

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
end
