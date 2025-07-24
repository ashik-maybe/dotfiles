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
# Custom Scripts
alias ar='$HOME/scripts/aria2c_script.sh'
alias yt='$HOME/scripts/yt-dlp_script.sh'
alias k='$HOME/scripts/archive_script.sh'
alias x='$HOME/scripts/unarchive_script.sh'
alias wt='$HOME/scripts/toggle-cloudflare-warp.sh'

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

# Misc
alias please='sudo $(fc -ln -1)'
alias reload='source ~/.zshrc && echo "✓ Reloaded ~/.zshrc"'
alias upgrade='sudo dnf upgrade --refresh -y && flatpak update -y'
