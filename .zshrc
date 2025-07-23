# ────── ENV & PATH ───────────────────────────────
export PATH="$HOME/.local/bin:$HOME/bin:$PATH"
export EDITOR='code'
export VISUAL='code'
# export TERMINAL=foot  # Uncomment if you use a custom terminal

# ────── STARSHIP PROMPT ──────────────────────────
if command -v starship &>/dev/null; then
  eval "$(starship init zsh)"
else
  PROMPT='%n@%m:%~%# '
fi

# ────── HISTORY BEHAVIOR ─────────────────────────
HISTCONTROL=ignoredups
setopt HIST_IGNORE_ALL_DUPS
HISTSIZE=10000
SAVEHIST=20000
HISTFILE=~/.zsh_history
setopt APPEND_HISTORY SHARE_HISTORY INC_APPEND_HISTORY

# ────── ZINIT PLUGIN MANAGER INSTALL & INIT ───────
# Install zinit automatically if missing
if [[ ! -f "${HOME}/.zinit/bin/zinit.zsh" ]]; then
  echo "Installing zinit plugin manager..."
  mkdir -p ~/.zinit
  git clone https://github.com/zdharma-continuum/zinit.git ~/.zinit/bin
fi
source ~/.zinit/bin/zinit.zsh

# ────── LOAD PLUGINS VIA ZINIT ─────────────────────

# zsh-autosuggestions
zinit light zsh-users/zsh-autosuggestions

# zsh-syntax-highlighting (load last for correct highlighting)
zinit light zsh-users/zsh-syntax-highlighting

# zsh-completions for extra completion scripts
zinit light zsh-users/zsh-completions

# fzf tab completion + key bindings (requires fzf installed)
zinit light junegunn/fzf

# git fast info in prompt (optional)
zinit light rupa/z

# ────── ALIASES ───────────────────────────────────

alias c='clear'
alias q='exit'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias d='cd ~/Downloads'
alias p='cd ~/WorkSpace/Projects'

# cd override for zoxide (if installed)
if command -v zoxide &>/dev/null; then
  eval "$(zoxide init zsh)"
else
  cd() {
    if [[ $# -eq 0 ]]; then
      builtin cd ~
    else
      builtin cd "$@"
    fi
  }
fi

alias mkdir='mkdir -pv'
alias cp='cp -iv'
alias mv='mv -iv'
alias rm='rm -iv'
alias rmdir='rmdir -v'

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


if command -v batcat &>/dev/null; then
  alias cat='batcat --paging=never'
elif command -v bat &>/dev/null; then
  alias cat='bat --paging=never'
fi

alias grep='grep --color=auto'

command -v btop &>/dev/null && alias top='btop'

# Git shortcuts
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

# Custom scripts
alias ar='$HOME/scripts/aria2c_script.sh'
alias yt='$HOME/scripts/yt-dlp_script.sh'
alias k='$HOME/scripts/archive_script.sh'
alias x='$HOME/scripts/unarchive_script.sh'
alias zellij='zellij'

# ────── FUNCTIONS ────────────────────────────────

upgrade() {
  echo -e "\033[1m→ Refreshing DNF metadata and upgrading packages...\033[0m"
  sudo dnf upgrade --refresh -y

  echo -e "\033[1m→ Updating Flatpak packages...\033[0m"
  flatpak update -y

  echo -e "\033[1m✓ System fully updated.\033[0m"
}

warp-toggle() {
  local ORANGE=$'%F{214}'
  local LIGHT_ORANGE=$'%F{215}'
  local GREEN=$'%F{2}'
  local RED=$'%F{1}'
  local BOLD=$'%B'
  local RESET=$'%f%b'

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

alias please='sudo $(fc -ln -1)'

# ────── ZSH OPTIONS ───────────────────────────────

setopt autocd            # just type directory name to cd
setopt correct           # autocorrect path typos
setopt extendedglob      # better globbing
setopt share_history     # share history between terminals
setopt hist_ignore_all_dups
setopt append_history
setopt inc_append_history
setopt no_beep           # no terminal beep

# ────── RELOAD ALIAS ─────────────────────────────

alias reload='source ~/.zshrc && echo "Reloaded ~/.zshrc"'
