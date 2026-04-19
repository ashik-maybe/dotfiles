# 📁 Navigation
alias ..='cd ..'                        # Go up one directory
alias ...='cd ../..'                    # Go up two directories
alias ....='cd ../../..'                # Go up three directories
alias c='clear'                         # Clear terminal screen
alias q='exit'                          # Quit the shell
alias cdd='cd ~/Downloads'               # Jump to Downloads folder
alias cdp='cd ~/Documents/projects/'     # Jump to projects folder

# 📂 File Operations
alias mkdir='mkdir -pv'                 # Make directory with verbose output and parent dirs
alias cp='cp -iv'                       # Copy with interactive prompt and verbose output
alias mv='mv -iv'                       # Move/rename with interactive prompt and verbose output
alias rm='rm -Iv'                       # Remove with interactive prompt and verbose output
alias rmdir='rmdir -v'                  # Remove empty directory with verbose output

# ⚙️ Modern CLI Replacements
alias fetch='fastfetch -c examples/21.jsonc' # Minimal system info
alias sys='fastfetch'                        # Alternative system info trigger
alias z='zoxide'                             # Smarter directory jumping
alias zi='z -i'                              # Interactive directory jumping
alias ls='lsd --color=auto --group-directories-first' # Modern ls
alias l='ls -l'                              # Long format
alias la='ls -a'                             # Show hidden files
alias ll='ls -la'                            # Long format + hidden files
alias lt='ls --tree'                         # Tree view display
alias bat='bat --paging=never'               # Syntax-highlighted cat (no paging)
alias cat='bat'                              # Use bat for all cat calls
alias zj='zellij --layout compact'           # Terminal multiplexer

# 🛠️ Additional Tooling Aliases
alias top='btop'                             # Modern resource monitor
alias htop='btop'                            # Classic habit for btop
alias df='duf'                               # Better disk free overview
alias du='dust -d 1'                         # Visual disk usage (max depth 1)
alias find='fd'                              # Faster, user-friendly find
alias grep='rg'                              # Blazing fast ripgrep
alias ff='fzf --preview "bat --style=numbers --color=always --line-range :500 {}"' # Fuzzy find with preview
