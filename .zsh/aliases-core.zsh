# ~/.zsh/aliases-core.zsh — 🧭 Core Shell Aliases
# Navigation, file operations, CLI replacements, and system utilities

# 📁 Navigation
alias ..='cd ..'                         # Go up one directory
alias ...='cd ../..'                     # Go up two directories
alias ....='cd ../../..'                 # Go up three directories
alias c='clear'                          # Clear terminal screen
alias q='exit'                           # Quit the shell
alias d='cd ~/Downloads'                # Jump to Downloads folder
alias p='cd ~/Documents/projects/'      # Jump to projects folder

# 📂 File Operations
alias mkdir='mkdir -pv'                 # Make directory with verbose output and parent dirs
alias cp='cp -iv'                       # Copy with interactive prompt and verbose output
alias mv='mv -iv'                       # Move/rename with interactive prompt and verbose output
alias rm='rm -Iv'                       # Remove with interactive prompt and verbose output
alias rmdir='rmdir -v'                  # Remove empty directory with verbose output

# ⚙️ Modern CLI Replacements
alias fetch='fastfetch --logo none'     # Minimal system info without logo
alias vim='nvim'                         # Use Neovim instead of Vim
alias top='btop'                         # Use btop instead of top
alias z='zoxide'                         # Smarter directory jumping
alias ls='lsd --color=auto --group-directories-first'  # Modern ls with colors and grouped dirs
alias bat='bat --paging=never'          # Syntax-highlighted cat with no paging
alias grep='rg'                          # Use ripgrep for fast searching
alias du='dust'                          # Disk usage with better visuals
alias df='duf'                           # Disk free space with better UI
alias find='fdfind'                      # fd: user-friendly find alternative

# 🛠️ System & Utilities
please() { sudo $(fc -lLn -1); }         # Run last command with sudo (like "please do it")
