# ────── ENVIRONMENT ──────────────────────────────
export EDITOR="code"                             # Set default CLI editor
export VISUAL="code"                             # Set default visual editor
export GOPATH="$HOME/go"                         # Golang workspace
export BUN_INSTALL="$HOME/.bun"                  # bun JS runtime install dir
export PATH="$HOME/.local/bin:$HOME/bin:$GOPATH/bin:$BUN_INSTALL/bin:$PATH"

# ────── PROMPT / STARSHIP ────────────────────────
if command -v starship &>/dev/null; then
  eval "$(starship init zsh)"                    # Use Starship prompt
else
  PROMPT='%n@%m:%~%(!.#.$) '                     # Fallback prompt with proper root indicator
fi

# ────── HISTORY SETTINGS ─────────────────────────
HISTSIZE=10000                                   # In-memory history size
SAVEHIST=20000                                   # Saved history lines
HISTFILE="$HOME/.zsh_history"                    # History file

setopt HIST_IGNORE_ALL_DUPS                      # Skip duplicate commands
setopt SHARE_HISTORY                             # Share across sessions
setopt APPEND_HISTORY                            # Append, don't overwrite
setopt INC_APPEND_HISTORY                        # Write incrementally
setopt EXTENDEDGLOB                              # Extended globbing (e.g., **/*.md)
setopt CORRECT                                   # Spell-correct commands
setopt AUTOCD                                    # `dir` = `cd dir`
setopt NO_BEEP                                   # Disable annoying beep

# ────── TAB COMPLETION ───────────────────────────
autoload -Uz compinit && compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*'
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '[%d]'

# ────── ZINIT SETUP (Plugin Manager) ─────────────
if [[ ! -f "${HOME}/.zinit/bin/zinit.zsh" ]]; then
  echo "→ Installing Zinit plugin manager..."
  mkdir -p ~/.zinit
  if ! git clone https://github.com/zdharma-continuum/zinit.git     ~/.zinit/bin; then
    echo "❌ Failed to install Zinit." >&2
    return 1
  fi
fi

if [[ -f "${HOME}/.zinit/bin/zinit.zsh" ]]; then
  source "${HOME}/.zinit/bin/zinit.zsh"
else
  echo "⚠️ Zinit not found. Plugins may not load." >&2
fi

# ────── ZSH PLUGINS ──────────────────────────────
zinit light zsh-users/zsh-autosuggestions         # Command suggestions as you type
zinit light zsh-users/zsh-completions             # Extra completions
zinit light Aloxaf/fzf-tab                        # Fuzzy tab completion
zinit light ajeetdsouza/zoxide && eval "$(zoxide init zsh)"  # Smarter `cd`
zinit light zsh-users/zsh-syntax-highlighting     # Syntax highlight (must be last)

# ────── ALIASES: NAVIGATION ──────────────────────
# USAGE: Navigate directories quickly
# ..     → Go up one directory
# ...    → Go up two directories
# ....   → Go up three directories
# c      → Clear terminal screen
# q      → Exit shell
# d      → Go to ~/Downloads
# p      → Go to ~/WorkSpace/Projects
alias ..='cd ..'                                  # Go up 1 dir
alias ...='cd ../..'                              # Go up 2 dirs
alias ....='cd ../../..'                          # Go up 3 dirs
alias c='clear'                                   # Clear terminal
alias q='exit'                                    # Quick exit
alias d='cd ~/Downloads'                          # Go to Downloads
alias p='cd ~/WorkSpace/Projects'                 # Go to Projects

# ────── ALIASES: FILE OPS ────────────────────────
# USAGE: Safer file operations with prompts and verbose output
# mkdir dir_name    → Create directory with parent dirs, show progress
# cp file dest      → Copy with interactive prompt and verbose output
# mv file dest      → Move with interactive prompt and verbose output
# rm file           → Remove with confirmation for multiple files
# rmdir dir         → Remove empty directory with verbose output
alias mkdir='mkdir -pv'                           # Make directory verbose
alias cp='cp -iv'                                 # Copy with prompt
alias mv='mv -iv'                                 # Move with prompt
alias rm='rm -Iv'                                 # Remove with prompt
alias rmdir='rmdir -v'                            # Remove dir verbose

# ────── ALIASES: LISTING ─────────────────────────
# USAGE: Enhanced directory listing
# ls        → List files (modern lsd or traditional ls)
# ll        → Long format with human readable sizes
# la        → List all files including hidden ones
if command -v lsd &>/dev/null; then
  alias ls='lsd --color=auto --group-directories-first' # Modern `ls`
  alias ll='lsd -lh'                              # List long + human
  alias la='lsd -a'                               # List all
else
  alias ls='ls --color=auto -h --group-directories-first'
  alias ll='ls -lh'
  alias la='ls -A'
fi

# ────── ALIASES: REPLACEMENTS ────────────────────
# USAGE: Enhanced alternatives to standard commands
# cat file      → Syntax highlighted file viewing (bat) or plain cat
# grep pattern  → Colorized search results
if command -v batcat &>/dev/null; then
  alias cat='batcat --paging=never'              # Pretty cat
elif command -v bat &>/dev/null; then
  alias cat='bat --paging=never'
fi
alias grep='grep --color=auto'                   # Colored grep

# ────── ALIASES: SYSTEM SHORTCUTS ────────────────
# USAGE: System management shortcuts
# please        → Re-run last command with sudo
# reload        → Reload .zshrc configuration
# upgrade       → Full system upgrade (dnf + flatpak)
please() {
  sudo $(fc -lLn -1)
}                                                  # "please" re-run last cmd
alias reload='source ~/.zshrc && echo "✓ Reloaded ~/.zshrc"'  # Reload zsh
alias upgrade='sudo dnf upgrade --refresh -y && flatpak update -y'  # Full upgrade

# ────── ALIASES: GIT SHORTCUTS ───────────────────
# USAGE: Git shortcuts for common operations
# gs            → Show repository status
# ga .          → Add all changes
# gc "message"  → Commit with message
# gp            → Push to remote
# gl            → Pull from remote
# gco branch    → Switch to branch
# gb            → List branches
# gd            → Show file differences
# gds           → Show staged differences
alias gs='git status'
alias ga='git add'
alias gc='git commit -m'
alias gp='git push'
alias gl='git pull'
alias gco='git checkout'
alias gb='git branch'
alias gd='git diff'
alias gds='git diff --staged'

# ────── ALIASES: DOCKER SHORTCUTS ────────────────
# USAGE: Docker management shortcuts
# dps           → List running containers
# dpsa          → List all containers (including stopped)
# dimg          → List Docker images
# dvol          → List volumes
# dnet          → List networks
# dexec container_name  → Execute command in running container
# dlog container_name   → View container logs
# dlogf container_name  → Follow container logs in real-time
# dstats        → Show container resource usage
# dcu           → Start docker-compose services (detached)
# dcd           → Stop and remove docker-compose services
# ld            → Launch LazyDocker TUI (if installed)

# Basic Docker commands
alias dps='docker ps'                            # List running containers
alias dpsa='docker ps -a'                        # List all containers
alias dimg='docker images'                       # List images
alias dvol='docker volume ls'                    # List volumes
alias dnet='docker network ls'                   # List networks
alias dexec='docker exec -it'                    # Execute in container
alias dlog='docker logs'                         # Container logs
alias dlogf='docker logs -f'                     # Follow container logs
alias dstats='docker stats'                      # Container stats
alias dtop='docker top'                          # Container processes

# Docker Compose
alias dc='docker-compose'                        # Docker Compose
alias dcu='docker-compose up -d'                 # Up detached
alias dcd='docker-compose down'                  # Down
alias dcl='docker-compose logs'                  # Logs
alias dclf='docker-compose logs -f'              # Follow logs
alias dcb='docker-compose build'                 # Build
alias dcr='docker-compose restart'               # Restart
alias dcs='docker-compose stop'                  # Stop

# Docker System
alias dprune='docker system prune -af'           # Clean everything
alias dprunei='docker image prune -af'           # Clean images
alias dprunev='docker volume prune -f'           # Clean volumes
alias dprunen='docker network prune -f'          # Clean networks

# LazyDocker - if installed
if command -v lazydocker &>/dev/null; then
  alias ld='lazydocker'                          # LazyDocker TUI
  alias lzd='lazydocker'                         # Alternative alias
fi

# ────── ALIASES: CUSTOM SCRIPTS ──────────────────
# USAGE: Personal automation scripts
# ar            → Run aria2c download script
# yt            → Run yt-dlp download script
# k             → Run archive script
# x             → Run unarchive script
alias ar="$HOME/scripts/aria2c_script.sh"
alias yt="$HOME/scripts/yt-dlp_script.sh"
alias k="$HOME/scripts/archive_script.sh"
alias x="$HOME/scripts/unarchive_script.sh"

# ────── FZF + ZOXIDE + BAT UTILS ─────────────────
# USAGE: Interactive fuzzy finding tools
# j             → Fuzzy jump to directories (uses zoxide)
# e / fopen     → Fuzzy find and open files with preview
# fkill         → Fuzzy find and kill processes
# glog          → Fuzzy browse git commit history
# fr            → Fuzzy find recent files in home directory
# cdf           → Fuzzy find and cd to directories

# Fuzzy jump to zoxide dir
j() {
  local dir
  dir=$(zoxide query -ls | fzf --height=40% --layout=reverse --preview='(exa -T --icons --color=always {} || tree -C {} || ls -la {}) | head -100' --preview-window=right:60%)
  [[ -n $dir ]] && cd "$dir"
}

# Fuzzy open file with preview
fopen() {
  local file
  file=$(fzf --preview 'bat --color=always --style=numbers --line-range=:200 {} 2>/dev/null || cat {} 2>/dev/null || echo "No preview available"' --height=40%)
  [[ -n $file ]] && ${EDITOR:-nano} "$file"
}
alias e='fopen'

# Kill process with fzf
fkill() {
  local pid
  pid=$(ps -ef | sed 1d | fzf --header="Select process to kill" --preview="echo {}" | awk '{print $2}')
  [[ -n $pid ]] && kill -9 "$pid"
}

# Git log browser with preview
glog() {
  git log --pretty=oneline --abbrev-commit |
    fzf --no-sort --reverse --tiebreak=index --preview \
    'echo {} | awk "{print \$1}" | xargs git show --color' \
    --preview-window=up:70%
}

# Recent file opener - with fallback to find
fr() {
  local file
  if command -v fd &>/dev/null; then
    file=$(fd --type f . ~ | fzf --preview 'bat --style=plain --color=always --line-range=:200 {} 2>/dev/null || cat {} 2>/dev/null')
  else
    file=$(find ~ -type f -not -path "*/\.*" | fzf --preview 'bat --style=plain --color=always --line-range=:200 {} 2>/dev/null || cat {} 2>/dev/null')
  fi
  [[ -n $file ]] && ${EDITOR:-nano} "$file"
}

# Fuzzy cd with fallback - uses fd if available, otherwise find
cdf() {
  local dir
  if command -v fd &>/dev/null; then
    dir=$(fd --type d . ~ | fzf --preview='(lsd -la --color=always {} || ls -la {}) | head -100')
  else
    dir=$(find ~ -type d -not -path "*/\.*" | fzf --preview='(lsd -la --color=always {} || ls -la {}) | head -100')
  fi
  [[ -n $dir ]] && cd "$dir"
}

# ────── FZF CONFIGS ──────────────────────────────
# USAGE: Enhanced command history search
# Ctrl+R        → Fuzzy search through command history
bindkey '^R' fzf-history-widget                   # Ctrl+R = fuzzy history
export FZF_DEFAULT_OPTS='
  --height=40%
  --layout=reverse
  --border
  --inline-info
  --color=bg+:237,hl:65,fg:252,fg+:255,info:108,pointer:161,marker:135
'

# ────── BUN / MISE / OTHER TOOLS INIT ────────────
[[ -s "$HOME/.bun/_bun" ]] && source "$HOME/.bun/_bun"  # bun completions
[[ -x "$HOME/.local/bin/mise" ]] && eval "$($HOME/.local/bin/mise activate zsh)"  # mise version manager
