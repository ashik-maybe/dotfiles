# ~/.zshrc — Main Zsh config (modularized)

# 🌱 Environment
export EDITOR="code"
export VISUAL="code"
export PATH="$HOME/.local/bin:$HOME/bin:$PATH"

# 🌟 Prompt
command -v starship >/dev/null && eval "$(starship init zsh)"

# 📜 History
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=20000
setopt HIST_IGNORE_ALL_DUPS SHARE_HISTORY APPEND_HISTORY INC_APPEND_HISTORY
setopt EXTENDED_GLOB CORRECT AUTO_CD NO_BEEP

# ⚡ Completion (cached)
autoload -Uz compinit
[[ ! -f "$ZDOTDIR/.zcompdump" || "$ZDOTDIR/.zcompdump" -ot "$ZDOTDIR/.zshrc" ]] && \
  compinit || compinit -d "$ZDOTDIR/.zcompdump"

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*'
zstyle ':completion:*:descriptions' format '%U%F{blue}%d%f%u'

# 🔌 Plugin Manager (zinit)
ZINIT_HOME="$HOME/.zinit"
[[ ! -f "$ZINIT_HOME/bin/zinit.zsh" ]] && {
  mkdir -p "$ZINIT_HOME"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME/bin"
}
source "$ZINIT_HOME/bin/zinit.zsh"

# 🔌 Plugins (lazy-loaded where possible)
zinit light-mode for \
  zsh-users/zsh-autosuggestions \
  zsh-users/zsh-completions \
  Aloxaf/fzf-tab

zinit ice wait lucid atinit"eval \"\$(zoxide init zsh)\""
zinit light ajeetdsouza/zoxide

zinit light zsh-users/zsh-syntax-highlighting  # must be last

# 🧩 Modular includes
for f in ~/.zsh/*.zsh; do
  source "$f"
done

# 🔍 fzf-tab: preview on tab complete
zstyle ':fzf-tab:complete:cd:*'  fzf-preview 'lsd --color=always $realpath'
zstyle ':fzf-tab:complete:ls:*'  fzf-preview 'lsd --color=always $realpath'
zstyle ':fzf-tab:complete:bat:*' fzf-preview 'bat --color=always --line-range :50 $realpath'
zstyle ':fzf-tab:complete:cat:*' fzf-preview 'head -n 50 $realpath | bat -l txt --color=always'
zstyle ':fzf-tab:complete:*'     fzf-preview 'file $realpath 2>/dev/null || echo "no preview"'
zstyle ':fzf-tab:*' fzf-bindings '?:toggle-preview'

: '
# 🧠 Motivation
echo -e "\n\t  Front-load your pain.\n\tDelay comfort. Earn ease.\n"
# ⏳ Show time left in day/week/month/year
if command -v time-stat &>/dev/null; then
  time-stat -t
else
  echo "⏳ time-stat not found. Did you forget to alias it?"
fi
'
