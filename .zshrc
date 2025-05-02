# =============================================================================
# 🧩 Zinit Plugin Manager Setup (MUST be first)
# =============================================================================

# Ensure Zinit is installed
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33}Installing Zinit (zdharma-continuum/zinit)...%f"
    command mkdir -p "$HOME/.local/share/zinit" && chmod g-rwX "$HOME/.local/share/zinit"
    git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" || {
        print -P "%F{160}Zinit installation failed.%f"
        exit 1
    }
fi

# Source Zinit
source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# =============================================================================
# 🔧 Zsh Completion System (MUST come early)
# =============================================================================
# Initialize Zsh's native completion system
autoload -Uz compinit
compinit

# =============================================================================
# 🔌 Core Plugins
# =============================================================================
# Basic completions for common tools (e.g., git, sudo)
zinit light zsh-users/zsh-completions

# Fuzzy tab completion with previews (e.g., cd ../<TAB>)
zinit light Aloxaf/fzf-tab

# Oh My Zsh snippets (Git, sudo, command-not-found)
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::command-not-found

# =============================================================================
# 🚀 Performance-Sensitive Plugins
# =============================================================================
# Delay syntax highlighting to improve startup speed
zinit ice wait'!0'
zinit light zsh-users/zsh-syntax-highlighting

# Delay autosuggestions to avoid slowing down typing
zinit ice wait'2'
zinit light zsh-users/zsh-autosuggestions

# =============================================================================
# 📂 Directory Navigation & History
# =============================================================================
# Fast directory navigation (e.g., `j proj` -> jumps to ~/Projects)
zinit light skywind3000/z.lua
alias j='z'  # Short alias for z.lua

# Incremental history search with Ctrl+R/S
bindkey '^R' history-incremental-search-backward
bindkey '^S' history-incremental-search-forward

# =============================================================================
# ⌨️ Keybindings & Shortcuts
# =============================================================================
# Common keybindings (Ctrl+A/E/K/U for line editing)
bindkey '^A' beginning-of-line
bindkey '^E' end-of-line
bindkey '^K' kill-line
bindkey '^U' backward-kill-line

# Arrow-key fallback for history search
bindkey "^[[A" history-beginning-search-backward
bindkey "^[[B" history-beginning-search-forward

# =============================================================================
# 🧱 Zsh Options & Settings
# =============================================================================
# Enable useful Zsh options
setopt autocd interactivecomments magicequalsubst notify
setopt hist_ignore_all_dups hist_find_no_dups sharehistory appendhistory

# History size (10k entries)
HISTSIZE=10000
SAVEHIST=$HISTSIZE
HISTFILE=~/.zsh_history

# Completion styling (colors, fuzzy matching)
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'

# =============================================================================
# 🌐 Environment Variables
# =============================================================================
# Set default editor to VS Code
export EDITOR='code'
export VISUAL='code'
# export TERMINAL=foot  # Terminal emulator name

# =============================================================================
# 🧰 Aliases & Custom Functions
# =============================================================================
# System shortcuts
alias c='clear'
alias q='exit'
alias ..='cd ..'
alias ...='cd ../..'
alias mkdir='mkdir -pv'
alias cp='cp -iv'
alias mv='mv -iv'
alias rm='rm -iv'
alias rmdir='rmdir -v'
alias grep='grep --color=auto'

# Git shortcuts
alias gst='git status'
alias gco='git checkout'
alias gcm='git commit'
alias gbr='git branch'
alias glg='git log --oneline --graph'

# Custom function: Create and enter a directory
mkcd() { mkdir -p "$1" && cd "$1"; }

# =============================================================================
# 🚀 Starship Prompt
# =============================================================================
# Initialize Starship (https://starship.rs) at the end
eval "$(starship init zsh)"