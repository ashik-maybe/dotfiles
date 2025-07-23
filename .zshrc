# ────── ENVIRONMENT ──────────────────────────────
export PATH="$HOME/.local/bin:$HOME/bin:$PATH"
export EDITOR="code"
export VISUAL="code"

# ────── TERMINAL & PROMPT ────────────────────────
if command -v starship &>/dev/null; then
  eval "$(starship init zsh)"
else
  PROMPT='%n@%m:%~%# '
fi

# ────── HISTORY SETTINGS ─────────────────────────
HISTSIZE=10000
SAVEHIST=20000
HISTFILE=~/.zsh_history
setopt HIST_IGNORE_ALL_DUPS SHARE_HISTORY APPEND_HISTORY INC_APPEND_HISTORY
setopt EXTENDEDGLOB CORRECT AUTOCD NO_BEEP

# ────── ZINIT SETUP ──────────────────────────────
if [[ ! -f "${HOME}/.zinit/bin/zinit.zsh" ]]; then
  echo "→ Installing Zinit plugin manager..."
  mkdir -p ~/.zinit && \
  git clone https://github.com/zdharma-continuum/zinit.git ~/.zinit/bin
fi
source ~/.zinit/bin/zinit.zsh

# ────── TAB COMPLETION ────────────────────────────
autoload -Uz compinit
compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*'
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '[%d]'

# ────── ZSH PLUGINS ──────────────────────────────
zinit light zsh-users/zsh-autosuggestions              # Suggest commands as you type
zinit light zsh-users/zsh-completions                  # Extra completions
zinit light Aloxaf/fzf-tab                             # Fuzzy tab completion (modern, super fast)
zinit light zsh-users/zsh-syntax-highlighting          # Highlight commands (MUST be last)

zinit light ajeetdsouza/zoxide                         # `z` alternative with smarter logic
eval "$(zoxide init zsh)"

# ────── SMART ALIASES ────────────────────────────
# Navigation
alias c='clear'
alias q='exit'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias d='cd ~/Downloads'
alias p='cd ~/WorkSpace/Projects'

# File operations
alias mkdir='mkdir -pv'
alias cp='cp -iv'
alias mv='mv -iv'
alias rm='rm -iv'
alias rmdir='rmdir -v'

# Listing
if command -v lsd &>/dev/null; then
  alias ls='lsd --color=auto --group-directories-first'
  alias ll='lsd -lh'
  alias la='lsd -a'
else
  alias ls='ls --color=auto -h'
  alias ll='ls -lh'
  alias la='ls -A'
fi

# Bat fallback
if command -v batcat &>/dev/null; then
  alias cat='batcat --paging=never'
elif command -v bat &>/dev/null; then
  alias cat='bat --paging=never'
fi

# Colorful grep
alias grep='grep --color=auto'

# Git
alias ga='git add'
alias gb='git branch'
alias gc='git commit'
alias gco='git checkout'
alias gl='git pull'
alias gp='git push'
alias gs='git status'
alias gcm='git commit -m'
alias gbr='git branch -r'
alias gcp='git cherry-pick'
alias glg='git log --oneline --graph'

# Misc
alias please='sudo $(fc -ln -1)'
alias reload='source ~/.zshrc && echo "✓ Reloaded ~/.zshrc"'
alias upgrade='sudo dnf upgrade --refresh -y && flatpak update -y'

# Optional WARP toggle (Cloudflare VPN)
warp-toggle() {
  local status=$(warp-cli status 2>/dev/null | grep 'Status update' | awk -F': ' '{print $2}' | tr -d '\r')
  if [[ "$status" == "Connected" ]]; then
    echo "→ Disconnecting WARP..." && warp-cli disconnect && echo "✓ Disconnected."
  else
    echo "→ Connecting WARP..." && warp-cli connect && echo "✓ Connected."
  fi
}
alias wt="warp-toggle"
