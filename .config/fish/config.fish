# ~/.config/fish/config.fish
# Pure environment setup, paths, and maxed-out native prompt configuration.

# ==============================================================================
# ENVIRONMENT VARIABLES
# ==============================================================================
set -gx EDITOR nano
set -gx VISUAL nano
set -gx PAGER less
# Colors (-R), Smart-case (-i), Line numbers (-N), Auto-exit if small (-F)
set -gx LESS '-R -i -M -N -F -X --shift 5'

# ==============================================================================
# PATH MANAGEMENT
# ==============================================================================
# ~/bin: Execution hub (standalone binaries/symlinks)
# ~/sdk: Development storage (intact SDKs/toolchains)
# ~/.local/bin: User-installed binaries (pip, cargo, npm -g, etc.)
fish_add_path -g -m $HOME/.local/bin
fish_add_path -g -m $HOME/sdk
fish_add_path -g -m $HOME/bin

# ==============================================================================
# SHELL OPTIONS
# ==============================================================================
set -g fish_history 20000
set -g fish_autocd_enabled 1
set -U fish_greeting
set -g fish_features no-command-not-found

# ==============================================================================
# INTERACTIVE SHELL CONFIG & MAXED-OUT NATIVE PROMPT
# ==============================================================================
if status is-interactive

    # --- 1. Enable All Native Git Prompt Features ---
    set -g __fish_git_prompt_show_informative_status 1
    set -g __fish_git_prompt_showdirtystate 1          # Modified/unstaged files
    set -g __fish_git_prompt_showuntrackedfiles 1      # Untracked files
    set -g __fish_git_prompt_showstashstate 1          # NEW: Stashed changes
    set -g __fish_git_prompt_showupstream "informative"# Ahead/behind/diverged
    set -g __fish_git_prompt_showcolorhints 1          # Color-code the states

    # --- 2. Modern, Distinct Unicode Characters ---
    set -g __fish_git_prompt_char_cleanstate "✔"      # Clean working tree (Green)
    set -g __fish_git_prompt_char_dirtystate "✚"       # Modified/unstaged (Red)
    set -g __fish_git_prompt_char_stagedstate "●"      # Staged/ready to commit (Green)
    set -g __fish_git_prompt_char_untrackedfiles "…"   # Untracked files (Yellow)
    set -g __fish_git_prompt_char_conflictedstate "≠"  # NEW: Merge conflicts (Red)
    set -g __fish_git_prompt_char_stashstate "💾"      # NEW: Stashed changes (Cyan)

    # Upstream tracking
    set -g __fish_git_prompt_char_upstream_ahead "↑"   # Commits ahead of remote
    set -g __fish_git_prompt_char_upstream_behind "↓"  # Commits behind remote
    set -g __fish_git_prompt_char_upstream_diverged "↕"# Diverged from remote

    set -g __fish_git_prompt_char_stateseparator " "

    # --- 3. Optional: Custom Prompt Colors (Uncomment to tweak) ---
    # set -g __fish_git_prompt_color_branch magenta
    # set -g __fish_git_prompt_color_upstream blue
    # set -g __fish_git_prompt_color_dirtystate red
    # set -g __fish_git_prompt_color_untrackedfiles yellow

end
