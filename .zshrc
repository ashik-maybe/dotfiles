# ~/.zshrc — Optimized, minimal startup time

# ────── ENVIRONMENT ──────────────────────────────
export EDITOR="code"                             # CLI editor
export VISUAL="code"                             # GUI editor
export GOPATH="$HOME/go"                         # Go workspace
export BUN_INSTALL="$HOME/.bun"                  # bun JS runtime

export PATH="$HOME/.local/bin:$PATH"             # User local binaries
export PATH="$HOME/bin:$PATH"                    # User binaries
export PATH="$GOPATH/bin:$PATH"                  # Go binaries
export PATH="$BUN_INSTALL/bin:$PATH"             # Bun binaries

# ────── PROMPT (Starship) ────────────────────────
command -v starship &>/dev/null && eval "$(starship init zsh)"

# ────── HISTORY SETTINGS ─────────────────────────
HISTSIZE=10000
SAVEHIST=20000
HISTFILE="$HOME/.zsh_history"

setopt HIST_IGNORE_ALL_DUPS SHARE_HISTORY APPEND_HISTORY INC_APPEND_HISTORY
setopt EXTENDEDGLOB CORRECT AUTOCD NO_BEEP

# ────── TAB COMPLETION (Cached) ──────────────────
autoload -Uz compinit
if [[ ! -f ~/.zcompdump || ~/.zcompdump -ot ~/.zshrc ]]; then
  compinit -C
else
  compinit -C -d ~/.zcompdump
fi
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*'
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '[%d]'

# ────── ZINIT (Plugin Manager) ───────────────────
ZINIT_HOME="${HOME}/.zinit"
if [[ ! -f "$ZINIT_HOME/bin/zinit.zsh" ]]; then
  echo "→ Installing Zinit..."
  mkdir -p "$ZINIT_HOME" &&
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME/bin"
fi
source "$ZINIT_HOME/bin/zinit.zsh"

# ────── PLUGINS (Lazy where possible) ────────────
zinit light-mode for \
  zsh-users/zsh-autosuggestions \
  zsh-users/zsh-completions \
  Aloxaf/fzf-tab

# `zoxide` (needs eval, delay it a bit)
zinit ice wait lucid atinit"eval \"\$(zoxide init zsh)\""
zinit light ajeetdsouza/zoxide

# Syntax highlighting (must load last)
zinit light zsh-users/zsh-syntax-highlighting

# ────── ALIASES: NAVIGATION ──────────────────────
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias c='clear'
alias q='exit'
alias d='cd ~/Downloads'
alias p='cd ~/WorkSpace/Projects'

# ────── ALIASES: FILE OPS / LISTING ──────────────
alias mkdir='mkdir -pv'
alias cp='cp -iv'
alias mv='mv -iv'
alias rm='rm -Iv'
alias rmdir='rmdir -v'

# ────── ALIASES: REPLACEMENTS ────────────────────
alias ls='lsd --color=auto --group-directories-first'
alias ll='lsd -lh'
alias la='lsd -a'

alias cat='bat --paging=never'
alias grep='grep --color=auto'

# ────── ALIASES: SHORTCUTS & UTILS ───────────────
please() { sudo $(fc -lLn -1); } # sudo last cmd
alias upgrade='sudo dnf upgrade --refresh -y && flatpak update -y'
alias lzd='lazydocker'

# ────── CUSTOM SCRIPTS ───────────────────────────
alias ar="$HOME/scripts/aria2c_script.sh"
alias yt="$HOME/scripts/yt-dlp_script.sh"
alias k="$HOME/scripts/archive_script.sh"
alias x="$HOME/scripts/unarchive_script.sh"

# ────── TOOL INITS (Conditional) ─────────────────
[[ -s "$BUN_INSTALL/_bun" ]] && source "$BUN_INSTALL/_bun"
[[ -x "$HOME/.local/bin/mise" ]] && eval "$($HOME/.local/bin/mise activate zsh)"
