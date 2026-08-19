# ~/.config/fish/config.fish

# Environment
set -gx EDITOR nano
set -gx VISUAL nano

# Path
fish_add_path -g -m $HOME/.local/bin
fish_add_path -g -m $HOME/sdk
fish_add_path -g -m $HOME/bin

# Shell Options
set -g fish_history 20000
set -g fish_autocd_enabled 1
set -U fish_greeting
set -g fish_features no-command-not-found

# Interactive Configuration
if status is-interactive

    # Adaptive Git Status Config
    set -g __fish_git_prompt_show_informative_status 1
    set -g __fish_git_prompt_showdirtystate 1
    set -g __fish_git_prompt_showuntrackedfiles 1
    set -g __fish_git_prompt_showstashstate 1
    set -g __fish_git_prompt_showupstream "informative"
    set -g __fish_git_prompt_showcolorhints 1

    # Adaptive Indicators
    set -g __fish_git_prompt_char_cleanstate ""           # nothing changed
    set -g __fish_git_prompt_char_dirtystate "●"          # modified files (unstaged)
    set -g __fish_git_prompt_char_stagedstate "+"         # ready to commit
    set -g __fish_git_prompt_char_untrackedfiles "…"      # new files (not tracked yet)
    set -g __fish_git_prompt_char_conflictedstate "×"     # merge conflict
    set -g __fish_git_prompt_char_stashstate "*"          # saved safely aside
    set -g __fish_git_prompt_char_upstream_ahead "↑"      # ahead of remote (need to push)
    set -g __fish_git_prompt_char_upstream_behind "↓"     # behind remote (need to pull)
    set -g __fish_git_prompt_char_diverged "⥄"            # local & remote histories split
    set -g __fish_git_prompt_char_stateseparator " "      # spacing between indicators

    # Theme-Adaptive Colors
    set -g __fish_git_prompt_color_branch yellow --bold
    set -g __fish_git_prompt_color_cleanstate green
    set -g __fish_git_prompt_color_dirtystate red --bold
    set -g __fish_git_prompt_color_stagedstate cyan
    set -g __fish_git_prompt_color_untrackedfiles cyan
    set -g __fish_git_prompt_color_stashstate white --bold
    set -g __fish_git_prompt_color_upstream cyan

    # High-Performance Adaptive Prompt
    function fish_prompt
            set -l last_status $status
            # 1. Directory Context
            set_color $fish_color_cwd
            echo -n (prompt_pwd)
            set_color normal
            # 2. Git Context
            echo -n (fish_git_prompt)
            # 3. Execution Duration (>2000ms)
            if test -n "$CMD_DURATION" -a "$CMD_DURATION" -gt 2000
                set -l secs (math --scale=1 "$CMD_DURATION / 1000")
                set_color brblack
                echo -n " ["$secs"s]"
                set_color normal
            end
            # 4. Status & Privilege Aware Prompt Symbol
            if test "$USER" = "root"
                set_color red --bold
                echo -n " # "
            else if test $last_status -eq 0
                set_color green --bold
                echo -n " ❯ "
            else
                set_color red --bold
                echo -n " ❯ "
            end
            set_color normal
        end

end
