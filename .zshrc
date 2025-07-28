# ────── ENVIRONMENT ──────────────────────────────
export EDITOR="code"                             # Set default CLI editor
export VISUAL="code"                             # Set default visual editor
export GOPATH="$HOME/go"                         # Golang workspace
export BUN_INSTALL="$HOME/.bun"                  # bun JS runtime install dir
# Build PATH for better readability
export PATH="$HOME/.local/bin:$PATH"             # User local binaries
export PATH="$HOME/bin:$PATH"                    # User binaries
export PATH="$GOPATH/bin:$PATH"                  # Go binaries
export PATH="$BUN_INSTALL/bin:$PATH"             # Bun binaries
# Note: New paths are typically prepended to give them priority.

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
  if ! git clone https://github.com/zdharma-continuum/zinit.git   ~/.zinit/bin; then
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
alias ..='cd ..'                                  # Go up 1 dir
alias ...='cd ../..'                              # Go up 2 dirs
alias ....='cd ../../..'                          # Go up 3 dirs
alias c='clear'                                   # Clear terminal
alias q='exit'                                    # Quick exit
alias d='cd ~/Downloads'                          # Go to Downloads
alias p='cd ~/WorkSpace/Projects'                 # Go to Projects

# ────── ALIASES: FILE OPS ────────────────────────
alias mkdir='mkdir -pv'                           # Make directory verbose
alias cp='cp -iv'                                 # Copy with prompt
alias mv='mv -iv'                                 # Move with prompt
alias rm='rm -Iv'                                 # Remove with prompt
alias rmdir='rmdir -v'                            # Remove dir verbose

# ────── ALIASES: LISTING ─────────────────────────
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
if command -v batcat &>/dev/null; then
  alias cat='batcat --paging=never'              # Pretty cat
elif command -v bat &>/dev/null; then
  alias cat='bat --paging=never'
fi
alias grep='grep --color=auto'                   # Colored grep

# ────── ALIASES: SYSTEM SHORTCUTS ────────────────
please() {
  sudo $(fc -lLn -1)
}                                                  # "please" re-run last cmd

alias upgrade='sudo dnf upgrade --refresh -y && flatpak update -y'  # Full upgrade

# ────── ALIASES: GIT SHORTCUTS ───────────────────
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
alias ar="$HOME/scripts/aria2c_script.sh"
alias yt="$HOME/scripts/yt-dlp_script.sh"
alias k="$HOME/scripts/archive_script.sh"
alias x="$HOME/scripts/unarchive_script.sh"

# ────── BUN / MISE / OTHER TOOLS INIT ────────────
[[ -s "$HOME/.bun/_bun" ]] && source "$HOME/.bun/_bun"  # bun completions
[[ -x "$HOME/.local/bin/mise" ]] && eval "$($HOME/.local/bin/mise activate zsh)"  # mise version manager
