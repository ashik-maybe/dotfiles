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
  if ! git clone https://github.com/zdharma-continuum/zinit.git ~/.zinit/bin; then
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
alias reload='source ~/.zshrc && echo "✓ Reloaded ~/.zshrc"'  # Reload zsh
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

# ────── ALIASES: CUSTOM SCRIPTS ──────────────────
[[ -x "$HOME/scripts/aria2c_script.sh" ]] && alias ar="$HOME/scripts/aria2c_script.sh"
[[ -x "$HOME/scripts/yt-dlp_script.sh" ]] && alias yt="$HOME/scripts/yt-dlp_script.sh"
[[ -x "$HOME/scripts/archive_script.sh" ]] && alias k="$HOME/scripts/archive_script.sh"
[[ -x "$HOME/scripts/unarchive_script.sh" ]] && alias x="$HOME/scripts/unarchive_script.sh"

# ────── FZF + ZOXIDE + BAT UTILS ─────────────────

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
