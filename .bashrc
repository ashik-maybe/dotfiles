# ────── 🛠 ENV & PATH ───────────────────────────────
export PATH="$HOME/.local/bin:$HOME/bin:$PATH"
export EDITOR='code'
export VISUAL='code'
# export TERMINAL=foot  # Uncomment if using a custom terminal

# ────── 🌟 STARSHIP PROMPT ──────────────────────────
if command -v starship &>/dev/null; then
  eval "$(starship init bash)"
else
  PS1='\u@\h:\w\$ '
fi

# ────── 🔁 HISTORY BEHAVIOR ─────────────────────────
export HISTCONTROL=ignoredups:erasedups
export HISTSIZE=10000
export HISTFILESIZE=20000
shopt -s histappend
PROMPT_COMMAND="history -a; $PROMPT_COMMAND"

# ────── 🧠 BASH COMPLETION ──────────────────────────
if [ -f /usr/share/bash-completion/bash_completion ]; then
  . /usr/share/bash-completion/bash_completion
elif [ -f /etc/bash_completion ]; then
  . /etc/bash_completion
fi

# Enable completion for aliases
if shopt -q progcomp; then
  complete -cf sudo
fi

# ────── ⚡️ AUTO ENHANCEMENTS ────────────────────────
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
command -v thefuck &>/dev/null && eval "$(thefuck --alias)"
command -v zoxide &>/dev/null && eval "$(zoxide init bash)"

# ────── 🪄 ALIASES ───────────────────────────────────

## 📁 Navigation
alias c='clear'
alias q='exit'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias d='cd ~/Downloads'
alias p='cd ~/WorkSpace/Projects'
alias cd='z'  # zoxide override

## 🗂️ File Operations (safe)
alias mkdir='mkdir -pv'
alias cp='cp -iv'
alias mv='mv -iv'
alias rm='rm -iv'
alias rmdir='rmdir -v'

## 🧾 Enhanced ls
if command -v lsd &>/dev/null; then
  alias ls='lsd --color=auto --group-directories-first'
  alias ll='lsd -lh --group-directories-first'
  alias la='lsd -a --color=auto --group-directories-first'
else
  if command -v eza &>/dev/null; then
    alias ls='eza --icons'
    alias ll='eza -lh --icons'
    alias la='eza -a --icons'
  else
    alias ls='ls --color=auto -h'
    alias ll='ls -lh'
    alias la='ls -A'
  fi
fi

## 🐱 Pretty cat
if command -v batcat &>/dev/null; then
  alias cat='batcat --paging=never'
elif command -v bat &>/dev/null; then
  alias cat='bat --paging=never'
fi

## 🔍 Better grep
alias grep='grep --color=auto'

## 📊 System Monitor
command -v btop &>/dev/null && alias top='btop'

## 🔧 Git Shortcuts
alias ga='git add'
alias gb='git branch'
alias gbr='git branch -r'
alias gc='git commit'
alias gcm='git commit -m'
alias gco='git checkout'
alias gcp='git cherry-pick'
alias gd='git diff'
alias gl='git pull'
alias glg='git log --oneline --graph'
alias gp='git push'
alias gs='git status'
alias gst='git status'

## 🧰 Custom Scripts
alias ar='$HOME/scripts/aria2c_script.sh'
alias yt='$HOME/scripts/yt-dlp_script.sh'
alias k='$HOME/scripts/archive_script.sh'
alias x='$HOME/scripts/unarchive_script.sh'
alias zellij='zellij'

# ────── 📦 CUSTOM FUNCTIONS ──────────────────
upgrade() {
  echo -e "\033[1m→ Refreshing DNF metadata and upgrading packages...\033[0m"
  sudo dnf upgrade --refresh -y

  echo -e "\033[1m→ Updating Flatpak packages...\033[0m"
  flatpak update -y

  echo -e "\033[1m✓ System fully updated.\033[0m"
}

warp-toggle() {
  local ORANGE='\033[38;5;208m'
  local LIGHT_ORANGE='\033[38;5;214m'
  local GREEN='\033[0;32m'
  local RED='\033[0;31m'
  local BOLD='\033[1m'
  local RESET='\033[0m'

  local status=$(warp-cli status 2>/dev/null | grep 'Status update' | awk -F': ' '{print $2}' | tr -d '\r')

  case "$status" in
    Connected)
      echo -e "${LIGHT_ORANGE}→ Disconnecting Cloudflare WARP...${RESET}"
      warp-cli disconnect &>/dev/null && \
        echo -e "${GREEN}✓ Cloudflare WARP ${BOLD}disconnected${RESET}${GREEN}.${RESET}" || \
        echo -e "${RED}✗ Failed to disconnect Cloudflare WARP.${RESET}"
      ;;
    *)
      echo -e "${ORANGE}→ Connecting Cloudflare WARP...${RESET}"
      warp-cli connect &>/dev/null && \
        echo -e "${GREEN}✓ Cloudflare WARP ${BOLD}connected${RESET}${GREEN}.${RESET}" || \
        echo -e "${RED}✗ Failed to connect Cloudflare WARP.${RESET}"
      ;;
  esac
}
alias wt="warp-toggle"

# ────── 🙏 SUDO LAST COMMAND ─────────────────────────
alias please='sudo $(history -p !!)'
