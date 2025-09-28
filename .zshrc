# ~/.zshrc

# Environment
export EDITOR="code"
export VISUAL="code"
export PATH="$HOME/.local/bin:$HOME/bin:$PATH"

# Prompt
command -v starship >/dev/null && eval "$(starship init zsh)"

# History
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=20000
setopt HIST_IGNORE_ALL_DUPS SHARE_HISTORY APPEND_HISTORY INC_APPEND_HISTORY
setopt EXTENDED_GLOB CORRECT AUTO_CD NO_BEEP

# Completion (cached)
autoload -Uz compinit
[[ ! -f "$ZDOTDIR/.zcompdump" || "$ZDOTDIR/.zcompdump" -ot "$ZDOTDIR/.zshrc" ]] && \
  compinit || compinit -d "$ZDOTDIR/.zcompdump"

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*'
zstyle ':completion:*:descriptions' format '%U%F{blue}%d%f%u'

# Plugin Manager (zinit)
ZINIT_HOME="$HOME/.zinit"
[[ ! -f "$ZINIT_HOME/bin/zinit.zsh" ]] && {
  mkdir -p "$ZINIT_HOME"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME/bin"
}
source "$ZINIT_HOME/bin/zinit.zsh"

# Plugins (lazy-loaded where possible)
zinit light-mode for \
  zsh-users/zsh-autosuggestions \
  zsh-users/zsh-completions \
  Aloxaf/fzf-tab

zinit ice wait lucid atinit"eval \"\$(zoxide init zsh)\""
zinit light ajeetdsouza/zoxide

zinit light zsh-users/zsh-syntax-highlighting  # must be last

# Aliases: Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias c='clear'
alias q='exit'
alias d='cd ~/Downloads'
alias p='cd ~/Documents/WorkSpace/'

# Aliases: File ops
alias mkdir='mkdir -pv'
alias cp='cp -iv'
alias mv='mv -iv'
alias rm='rm -Iv'
alias rmdir='rmdir -v'

# Aliases: Modern replacements
alias neofetch='fastfetch'
alias top='btop'
alias ls='lsd --color=auto --group-directories-first'
alias cat='bat --paging=never'
alias grep='rg'
alias du='dust'
alias df='duf'
alias find='fdfind'

# 🛠️ SYSTEM & UTILS
please() { sudo $(fc -lLn -1); }
alias upgrade='sudo dnf upgrade --refresh -y && flatpak update -y'

# 🐍 Python Essentials
alias av="source venv/bin/activate"     # Activate virtualenv
alias dv="deactivate"                   # Deactivate virtualenv

# 🟢 Node.js / NPM Essentials
alias vite='npm create vite@latest'

# 🐳 Containerization Essentials
alias docker='podman'
alias lzd='lazydocker'                  # https://github.com/jesseduffield/lazydocker

# Aliases: Custom scripts
alias ar="$HOME/scripts/aria2c_script.sh"
alias yt="$HOME/scripts/yt-dlp_script.sh"
alias k="$HOME/scripts/archive_script.sh"
alias x="$HOME/scripts/unarchive_script.sh"
alias warp="$HOME/scripts/toggle-warp_script.sh"

# Keybindings: Emacs mode (VS Code style)
bindkey -e
autoload -U select-word-style && select-word-style bash  # smarter word boundaries

# Word movement
bindkey '\e[1;5D'  backward-word
bindkey '\e[1;5C'  forward-word
bindkey '\ed'      backward-word
bindkey '\e\'      forward-word

# Delete word
bindkey '\C-w'     backward-kill-word
bindkey '\e[3;5~'  kill-word

# Line navigation
bindkey '\e[H'     beginning-of-line
bindkey '\e[F'     end-of-line
bindkey '\e[1~'    beginning-of-line
bindkey '\e[4~'    end-of-line

# Buffer navigation (multi-line / history)
bindkey '\e[1;5H'  beginning-of-buffer-or-history
bindkey '\e[1;5F'  end-of-buffer-or-history

# Line editing
bindkey '^K'       kill-line
bindkey '^U'       backward-kill-line
bindkey '^X'       kill-whole-line
bindkey '^L'       clear-screen
bindkey '^Z'       undo

# Redo (like Ctrl+Y in editors)
redo() { zle undo }
zle -N redo && bindkey '^Y' redo

# Cancel line (like Esc in editor)
vi-cancel-line() { zle .reset-prompt; zle -y .kill-line; }
zle -N vi-cancel-line && bindkey '^C' vi-cancel-line

# Insert last arg of prev command
bindkey '\e.'      insert-last-word

# Edit command in $EDITOR (Ctrl+E)
autoload -U edit-command-line
zle -N edit-command-line && bindkey '^E' edit-command-line

# fzf-tab: preview on tab complete
zstyle ':fzf-tab:complete:cd:*'  fzf-preview 'lsd --color=always $realpath'
zstyle ':fzf-tab:complete:ls:*'  fzf-preview 'lsd --color=always $realpath'
zstyle ':fzf-tab:complete:bat:*' fzf-preview 'bat --color=always --line-range :50 $realpath'
zstyle ':fzf-tab:complete:cat:*' fzf-preview 'head -n 50 $realpath | bat -l txt --color=always'
zstyle ':fzf-tab:complete:*'     fzf-preview 'file $realpath 2>/dev/null || echo "no preview"'
zstyle ':fzf-tab:*' fzf-bindings '?:toggle-preview'

# History search: fzf if available, fallback to incremental
(( $+commands[fzf] )) && bindkey '^R' fzf-history-widget || \
                         bindkey '^R' history-incremental-pattern-search-backward

# Optional: Alt+D to duplicate current line
# edit-line-duplicate() { LBUFFER="$BUFFER"$'\n'"$BUFFER"; }
# zle -N edit-line-duplicate && bindkey '\e\d' edit-line-duplicate
