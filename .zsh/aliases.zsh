# ~/.zsh/aliases.zsh — Aliases for navigation, file ops, tools, and custom scripts

# 📁 Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias c='clear'
alias q='exit'
alias d='cd ~/Downloads'
alias p='cd ~/Documents/projects/'

# 📂 File Operations
alias mkdir='mkdir -pv'
alias cp='cp -iv'
alias mv='mv -iv'
alias rm='rm -Iv'
alias rmdir='rmdir -v'

# ⚙️ Modern CLI Replacements
alias fetch='fastfetch --logo none'
alias vim='nvim'
alias top='btop'
alias ls='lsd --color=auto --group-directories-first'
alias cat='bat --paging=never'
alias grep='rg'
alias du='dust'
alias df='duf'
alias find='fdfind'

# 🛠️ System & Utilities
please() { sudo $(fc -lLn -1); }

# 🐍 Python Virtualenv
alias av="source venv/bin/activate"
alias dv="deactivate"

# 🟢 Node.js / NPM Starters
alias vite='npm create vite@latest'
alias nextjs='npx create-next-app@latest'
alias t3='pnpm create t3-app@latest'

# 📜 Custom Scripts
alias ar="$HOME/scripts/aria2c.sh"
alias yt="$HOME/scripts/yt-dlp.sh"
alias k="$HOME/scripts/archive.sh"
alias x="$HOME/scripts/unarchive.sh"

alias warp="$HOME/scripts/toggle-warp.sh"         # Toggle Cloudflare WARP connection
alias time-stat="$HOME/scripts/time-stat.sh"      # Time remaining in day/week/month/year
alias vid-len="$HOME/scripts/video_speed_calc.sh" # Video length calculator by speed

# 🧪 Ready for future:
# - Add git, podman, docker, gh aliases here
# - Or split into ~/.zsh/git.zsh, ~/.zsh/podman.zsh etc.
