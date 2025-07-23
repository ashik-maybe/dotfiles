# ────── 🛠 ENV & PATH ───────────────────────────────
export PATH="$HOME/.local/bin:$HOME/bin:$PATH"
export EDITOR='code'
export VISUAL='code'
# export TERMINAL=foot  # Uncomment and set if needed

# ────── 🌟 STARSHIP PROMPT ──────────────────────────
command -v starship &>/dev/null && eval "$(starship init bash)"

# ────── 🔁 HISTORY BEHAVIOR ─────────────────────────
export HISTCONTROL=ignoredups:erasedups
export HISTSIZE=10000
export HISTFILESIZE=20000
shopt -s histappend
PROMPT_COMMAND="history -a; $PROMPT_COMMAND"

# ────── 🧠 COMPLETION ───────────────────────────────
if [ -f /etc/bash_completion ]; then
  . /etc/bash_completion
fi

# ────── 🧹 AUTO ENHANCEMENTS ────────────────────────
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
command -v thefuck &>/dev/null && eval "$(thefuck --alias)"

# ────── 🎨 LOGIN WELCOME MESSAGE ────────────────────
command -v neofetch &>/dev/null && neofetch

# ────── 🪄 SMART ALIASES ─────────────────────────────

## Core navigation
alias c='clear'
alias q='exit'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias d='cd ~/Downloads'
alias p='cd ~/WorkSpace/Projects'

## File operations (safe)
alias mkdir='mkdir -pv'
alias cp='cp -iv'
alias mv='mv -iv'
alias rm='rm -iv'
alias rmdir='rmdir -v'

## Enhanced ls
if command -v exa &>/dev/null; then
  alias ls='exa --icons'
  alias ll='exa -lh --icons'
  alias la='exa -a --icons'
else
  alias ls='ls --color=auto -h'
  alias ll='ls -lh'
  alias la='ls -A'
fi

## Enhanced cat
if command -v batcat &>/dev/null; then
  alias cat='batcat --paging=never'
elif command -v bat &>/dev/null; then
  alias cat='bat --paging=never'
fi

## grep highlight
alias grep='grep --color=auto'

## Top replacement
command -v btop &>/dev/null && alias top='btop'

## Git shortcuts
alias gst='git status'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gcm='git commit'
alias gp='git push'
alias gl='git pull'
alias glg='git log --oneline --graph'
alias gb='git branch'
alias gbr='git branch'
alias gd='git diff'
alias gco='git checkout'

## Custom tool aliases
alias z=zellij
alias ar='$HOME/scripts/aria2c_script.sh'
alias yt='$HOME/scripts/yt-dlp_script.sh'
alias k='$HOME/scripts/archive_script.sh'
alias x='$HOME/scripts/unarchive_script.sh'

# ────── 📦 SYSTEM UPDATER FUNCTION ──────────────────
upgrade() {
  echo -e "\033[1m→ Refreshing DNF metadata and upgrading packages...\033[0m"
  sudo dnf upgrade --refresh -y

  echo -e "\033[1m→ Updating Flatpak packages...\033[0m"
  flatpak update -y

  echo -e "\033[1m✓ System fully updated.\033[0m"
}

# ────── 🙏 SUDO LAST COMMAND ─────────────────────────
alias please='sudo $(history -p !!)'
