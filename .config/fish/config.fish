# Fish — editor, paths, history, and prompt.

# Editor: nano for quick edits. Tools that need a full editor open Zed.
set -gx EDITOR nano
set -gx VISUAL nano

# Paths: user binaries first. Background priority keeps system paths usable.
fish_add_path -g -m $HOME/.local/bin
fish_add_path -g -m $HOME/sdk
fish_add_path -g -m $HOME/bin

# History: 20000 lines. Autocd: type a directory name to enter it.
# Greeting: cleared. Command-not-found: disabled (use `command-not-found` explicitly).
set -g fish_history 20000
set -g fish_autocd_enabled 1
set -U fish_greeting
set -g fish_features no-command-not-found

# Interactive shells: adaptive git prompt. Non-interactive shells skip it for speed.
if status is-interactive

    # Git prompt: branch, dirtiness, stash, and upstream state in one segment.
    set -g __fish_git_prompt_show_informative_status 1
    set -g __fish_git_prompt_showdirtystate 1
    set -g __fish_git_prompt_showuntrackedfiles 1
    set -g __fish_git_prompt_showstashstate 1
    set -g __fish_git_prompt_showupstream "informative"
    set -g __fish_git_prompt_showcolorhints 1

    # Indicators: each symbol means one state.
    set -g __fish_git_prompt_char_cleanstate ""           # Clean tree
    set -g __fish_git_prompt_char_dirtystate "●"          # Modified files (unstaged)
    set -g __fish_git_prompt_char_stagedstate "+"         # Staged changes
    set -g __fish_git_prompt_char_untrackedfiles "…"      # Untracked files
    set -g __fish_git_prompt_char_conflictedstate "×"     # Merge conflict
    set -g __fish_git_prompt_char_stashstate "*"          # Stash present
    set -g __fish_git_prompt_char_upstream_ahead "↑"      # Ahead of remote (push)
    set -g __fish_git_prompt_char_upstream_behind "↓"     # Behind remote (pull)
    set -g __fish_git_prompt_char_diverged "⥄"            # Local and remote split
    set -g __fish_git_prompt_char_stateseparator " "      # Space between indicators

    # Colors: branch in bold yellow, dirtiness in bold red. Matches Catppuccin.
    set -g __fish_git_prompt_color_branch yellow --bold
    set -g __fish_git_prompt_color_cleanstate green
    set -g __fish_git_prompt_color_dirtystate red --bold
    set -g __fish_git_prompt_color_stagedstate cyan
    set -g __fish_git_prompt_color_untrackedfiles cyan
    set -g __fish_git_prompt_color_stashstate white --bold
    set -g __fish_git_prompt_color_upstream cyan

    # Prompt: directory, git state, slow commands, then status symbol.
    # Slow commands show duration after 2 seconds. Red # marks root shells.
    function fish_prompt
            set -l last_status $status
            set_color $fish_color_cwd
            echo -n (prompt_pwd)
            set_color normal
            echo -n (fish_git_prompt)
            if test -n "$cmd_duration" -a "$cmd_duration" -gt 2000
                set -l secs (math --scale=1 "$cmd_duration / 1000")
                set_color brblack
                echo -n " ["$secs"s]"
                set_color normal
            end
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

# opencode
fish_add_path $HOME/.opencode/bin


# Added by Antigravity CLI installer
set -gx PATH "$HOME/.local/bin" $PATH
