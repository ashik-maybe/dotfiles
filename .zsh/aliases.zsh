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
alias z='zoxide'
alias ls='lsd --color=auto --group-directories-first'
alias bat='bat --paging=never'
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

# 🧠 Git Aliases (Local & Remote)
alias gs='git status'
alias ga='git add'
alias gaa='git add --all'
alias gc='git commit -v'
alias gcm='git commit -m'
alias gco='git checkout'
alias gb='git branch'
alias gcb='git checkout -b'
alias gl='git log --oneline --graph --decorate'
alias gd='git diff'
alias gds='git diff --staged'
alias gp='git push'
alias gpl='git pull'
alias gfp='git fetch --prune'
alias gr='git remote -v'
alias gcl='git clone'
alias gmv='git mv'
alias grm='git rm'
alias gstash='git stash'
alias gstashp='git stash pop'
alias gclean='git clean -fd'

# 🧠 Git QoL & Branch Management
alias gundo='git reset --soft HEAD~1'       # Undo last commit, keep changes
alias gfix='git commit --amend'             # Amend last commit
alias gcleanall='git clean -fdx'            # Remove all untracked files and dirs
alias gprune='git remote prune origin'      # Clean up stale remote branches
alias gsync='git pull --rebase && git push' # Sync with remote
alias gbd='git branch -d'                   # Delete local branch
alias gbD='git branch -D'                   # Force delete local branch
alias gpo='git push origin'                 # Push to origin
alias gpu='git push -u origin HEAD'         # Push current branch and set upstream
alias gnew='git switch -c'                  # Create and switch to new branch

# 🌐 GitHub Aliases (via CLI gh)
alias gh='gh'
alias ghrepo='gh repo view --web'
alias ghclone='gh repo clone'
alias ghpr='gh pr create --fill'
alias ghprs='gh pr status'
alias ghissue='gh issue create'
alias ghview='gh issue view --web'

# 🐳 Podman Aliases (Container Dev)
alias pod='podman'
alias podps='podman ps -a'
alias podimg='podman images'
alias podrun='podman run -it --rm'
alias podexec='podman exec -it'
alias podrm='podman rm'
alias podrmi='podman rmi'
alias podbuild='podman build -t'
alias podpull='podman pull'
alias podlogs='podman logs'
alias podstop='podman stop'
alias podstart='podman start'
alias podsh='podman exec -it $(podman ps -q | head -n1) sh'
alias podbash='podman exec -it $(podman ps -q | head -n1) bash'
alias podprune='podman system prune -a -f'

# 🧪 Misc Dev Tools
alias ports='ss -tuln'                     # Show open ports
alias ipinfo='curl ipinfo.io'              # Public IP + geolocation
alias serve='python3 -m http.server 8000'  # Quick local web server
