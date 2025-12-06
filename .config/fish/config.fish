# ~/.config/fish/config.fish
#  Fish stores it's command history in: ~/.local/share/fish/

# 🌱 Environment
set -gx EDITOR code
set -gx VISUAL code

set -gx PATH $HOME/.local/bin $HOME/bin $PATH

# Android SDK environment variables
set -gx ANDROID_HOME ~/Android/Sdk; set -gx PATH $ANDROID_HOME/tools $ANDROID_HOME/platform-tools $PATH

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH

# 📜 History
set -g fish_history 20000

# ⚙️ Auto cd (type "Downloads" → cd into it)
set -g fish_autocd_enabled 1

# 🎨 Silence welcome message
set -U fish_greeting

# 🔌 Starship prompt (if installed)
if status is-interactive
    if type -q starship
        starship init fish | source
    end
end

# 🔁 zoxide — smarter cd (run `z dir` anytime)
# Optional but recommended for full integration (tab completions + tracking)
if type -q zoxide
    zoxide init fish | source
end

# 🔍 fzf — use as command, no keybindings unless you add them later
# (If you want Tab preview or Ctrl+R, install fzf.fish instead!)
# → https://github.com/PatrickF1/fzf.fish
# For now: just ensure fzf works when you call it
if type -q fzf
    # Basic preview config (used by fzf.fish or manual fzf)
    set -gx FZF_DEFAULT_OPTS --height=40% --layout=reverse --border --preview-window=right:50%
end

# 🧠 Motivational quote (once per session)
# if not set -q __MOTD_SHOWN
#     echo -e "\n\t  Front-load your pain.\n\tDelay comfort. Earn ease.\n"
#     set -g __MOTD_SHOWN 1
# end

# Display time remaining in a clean, professional status panel style.
# if type -q time-stat; and not set -q __TIME_STAT_SHOWN
#     echo "Time Left:"
#     set -l i 1
#     set -l labels Today Week Month Year
#     time-stat -t | while read -l line
#         set clean (string replace ' + ' ' ' $line | string replace -r ' left.*$' '' | string trim)
#         printf "  %-6s: %s\n" $labels[$i] $clean
#         set i (math $i + 1)
#     end
#     set -g __TIME_STAT_SHOWN 1
# end
