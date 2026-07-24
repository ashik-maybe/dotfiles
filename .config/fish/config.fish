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
    set -g __fish_git_prompt_char_cleanstate "ok"
    set -g __fish_git_prompt_char_dirtystate "mod"
    set -g __fish_git_prompt_char_stagedstate "stg"
    set -g __fish_git_prompt_char_untrackedfiles "unt"
    set -g __fish_git_prompt_char_conflictedstate "cfl"
    set -g __fish_git_prompt_char_stashstate "sth"
    set -g __fish_git_prompt_char_upstream_ahead "ahd"
    set -g __fish_git_prompt_char_upstream_behind "bhd"
    set -g __fish_git_prompt_char_upstream_diverged "div"
    set -g __fish_git_prompt_char_stateseparator " "

    # Theme-Adaptive Colors
    set -g __fish_git_prompt_color_branch yellow --bold
    set -g __fish_git_prompt_color_cleanstate green
    set -g __fish_git_prompt_color_dirtystate red
    set -g __fish_git_prompt_color_stagedstate cyan
    set -g __fish_git_prompt_color_untrackedfiles brblack
    set -g __fish_git_prompt_color_stashstate brblack
    set -g __fish_git_prompt_color_upstream brblack

    # High-Performance Adaptive Prompt
    function fish_prompt
        set -l last_status $status

        # Blank Line Separator
        echo

        # Dynamic Directory Color (Theme Inherited)
        set_color $fish_color_cwd
        echo -n (prompt_pwd)
        set_color normal

        # Git Context
        echo -n (fish_git_prompt)

        # Fast Native Duration Calculation (>2000ms)
        if test -n "$CMD_DURATION" -a "$CMD_DURATION" -gt 2000
            set -l secs (math --scale=1 "$CMD_DURATION / 1000")
            set_color brblack
            echo -n " "$secs"s"
            set_color normal
        end

        # Prompt Symbol
        echo
        if test $last_status -eq 0
            set_color green --bold
        else
            set_color red --bold
        end
        echo -n "❯ "
        set_color normal
    end

end
