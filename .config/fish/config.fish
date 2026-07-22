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
#    - Note: Managed languages (Node, Go, Python) are handled automatically via mise!
#
# ------------------------------------------------------------------------------
# 🛠️ HOW TO ADD NEW DEV TOOLS IN THE FUTURE
# ------------------------------------------------------------------------------
#
# METHOD A: For standalone binaries (e.g., a single compiled tool)
#    1. Move the file straight to your execution hub:
#       mv downloaded_tool ~/bin/
#    2. Make it executable:
#       chmod +x ~/bin/downloaded_tool
#
# METHOD B: For full toolchains (e.g., Go, Node, Zig via mise)
#    mise use --global node@latest
#    mise use --global go@latest
#
# METHOD C: Manual SDK fallback
#    1. Extract into ~/sdk/<tool>
#    2. Symlink binary: ln -sf ~/sdk/<tool>/bin/<binary> ~/bin/<binary>
#
# ==============================================================================
# THE MASTER PATHS SETTING
# ==============================================================================
# -g sets global scope.
# -m prepends to PATH to prioritize user binaries over system defaults.
fish_add_path -g -m $HOME/.local/bin
fish_add_path -g -m $HOME/sdk
fish_add_path -g -m $HOME/bin

# ==============================================================================
# SHELL OPTIONS & INTERACTIVE CONFIG
# ==============================================================================
set -g fish_history 20000
set -g fish_autocd_enabled 1
set -U fish_greeting
set -g fish_features no-command-not-found

if status is-interactive
    # These automatically tweak the default Fish prompt's built-in Git behavior!
    set -g __fish_git_prompt_show_informative_status 1
    set -g __fish_git_prompt_showdirtystate 1
    set -g __fish_git_prompt_showuntrackedfiles 1
    set -g __fish_git_prompt_showcolorhints 1
    set -g __fish_git_prompt_showupstream "informative"

    # Directory navigation (Zoxide)
    if type -q zoxide
        zoxide init fish | source
    end

    # Fuzzy finder configuration (FZF)
    if type -q fzf
        set -gx FZF_DEFAULT_OPTS --height=40% --layout=reverse --border --preview-window=right:50%
    end
end
