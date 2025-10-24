# ~/.zsh/keybindings.zsh — Keybindings and ZLE widgets for enhanced line editing

# 🧠 Emacs mode (VS Code style)
bindkey -e
autoload -U select-word-style && select-word-style bash  # smarter word boundaries

# 🔀 Word movement
bindkey '\e[1;5D'  backward-word
bindkey '\e[1;5C'  forward-word
bindkey '\ed'      backward-word
bindkey '\e\'      forward-word

# ❌ Delete word
bindkey '\C-w'     backward-kill-word
bindkey '\e[3;5~'  kill-word

# ⏮️ Line navigation
bindkey '\e[H'     beginning-of-line
bindkey '\e[F'     end-of-line
bindkey '\e[1~'    beginning-of-line
bindkey '\e[4~'    end-of-line

# 📜 Buffer navigation (multi-line / history)
bindkey '\e[1;5H'  beginning-of-buffer-or-history
bindkey '\e[1;5F'  end-of-buffer-or-history

# ✂️ Line editing
bindkey '^K'       kill-line
bindkey '^U'       backward-kill-line
bindkey '^X'       kill-whole-line
bindkey '^L'       clear-screen
bindkey '^Z'       undo

# 🔁 Redo (like Ctrl+Y in editors)
redo() { zle undo }
zle -N redo && bindkey '^Y' redo

# 🛑 Cancel line (like Esc in editor)
vi-cancel-line() { zle .reset-prompt; zle -y .kill-line; }
zle -N vi-cancel-line && bindkey '^C' vi-cancel-line

# ↩️ Insert last arg of previous command
bindkey '\e.'      insert-last-word

# 📝 Edit command in $EDITOR (Ctrl+E)
autoload -U edit-command-line
zle -N edit-command-line && bindkey '^E' edit-command-line

# 🔍 History search: fzf if available, fallback to incremental
(( $+commands[fzf] )) && bindkey '^R' fzf-history-widget || \
                         bindkey '^R' history-incremental-pattern-search-backward

# 🧪 Optional: Alt+D to duplicate current line
# edit-line-duplicate() { LBUFFER="$BUFFER"$'\n'"$BUFFER"; }
# zle -N edit-line-duplicate && bindkey '\e\d' edit-line-duplicate
