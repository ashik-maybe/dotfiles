# ────── ENVIRONMENT ──────────────────────────────
export EDITOR="code"                             # CLI editor
export VISUAL="code"                             # GUI editor

# User binaries (keep these, likely still useful)
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/bin:$PATH"

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
  mkdir -p "$ZINIT_HOME" && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME/bin"
fi
source "$ZINIT_HOME/bin/zinit.zsh"

# ────── PLUGINS (Lazy where possible) ────────────
zinit light-mode for \
  zsh-users/zsh-autosuggestions \
  zsh-users/zsh-completions \
  Aloxaf/fzf-tab

# zoxide (smart cd replacement)
zinit ice wait lucid atinit"eval \"\$(zoxide init zsh)\""
zinit light ajeetdsouza/zoxide

# Syntax highlighting (must be last)
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
alias neofetch='fastfetch'
alias top='btop'
alias ls='lsd --color=auto --group-directories-first'
alias cat='bat --paging=never'
alias grep='rg'
alias du='dust'
alias find='fdfind'

# ────── ALIASES: SHORTCUTS & UTILS ───────────────
please() { sudo $(fc -lLn -1); } # sudo last command
alias upgrade='sudo dnf upgrade --refresh -y && flatpak update -y'
alias vite='npm create vite@latest'
alias lzd='lazydocker'

# ────── CUSTOM SCRIPTS ───────────────────────────
alias ar="$HOME/scripts/aria2c_script.sh"
alias yt="$HOME/scripts/yt-dlp_script.sh"
alias k="$HOME/scripts/archive_script.sh"
alias x="$HOME/scripts/unarchive_script.sh"

#   KEYBINDINGS: Editor-Style Navigation (VS Code / Emacs-like)

bindkey -e  # Use emacs keybindings

# Word movement
bindkey '\e[1;5D'  backward-word            # Ctrl+Left
bindkey '\e[1;5C'  forward-word             # Ctrl+Right
bindkey '\ed'      backward-word            # Alt+Left  (macOS)
bindkey '\e\'      forward-word             # Alt+Right (macOS)

# Delete word by word
bindkey '\C-w'     backward-kill-word       # Ctrl+Backspace
bindkey '\e[3;5~'  kill-word                # Ctrl+Delete

# Line navigation
bindkey '\e[H'     beginning-of-line        # Home
bindkey '\e[F'     end-of-line              # End
bindkey '\e[1~'    beginning-of-line        # Home (alternate)
bindkey '\e[4~'    end-of-line              # End (alternate)

# Buffer navigation (for multi-line commands or history)
bindkey '\e[1;5H'  beginning-of-buffer-or-history  # Ctrl+Home
bindkey '\e[1;5F'  end-of-buffer-or-history        # Ctrl+End

# Line editing shortcuts
bindkey '^K'       kill-line                # Ctrl+K: kill to end of line
bindkey '^U'       backward-kill-line       # Ctrl+U: kill to start of line
bindkey '^X'       kill-whole-line          # Ctrl+X: cut entire line
bindkey '^L'       clear-screen             # Ctrl+L: clear screen

# Search
bindkey '^R'       history-incremental-pattern-search-backward  # Incremental history search

# Insert last argument of previous command
bindkey '\e.'      insert-last-word         # Alt+.

# Use fzf for history search if available
if (( $+commands[fzf] )); then
  bindkey '^R' fzf-history-widget
fi
