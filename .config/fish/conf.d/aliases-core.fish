# ==============================================================================
# 📁 Navigation
# ==============================================================================
alias ..='cd ..'                                # Go up one directory
alias ...='cd ../..'                            # Go up two directories
alias ....='cd ../../..'                        # Go up three directories
alias c='clear'                                 # Clear terminal screen
alias q='exit'                                  # Quit the shell
alias cdd='cd ~/Downloads'                      # Jump to Downloads folder
alias cdp='cd ~/Documents/projects/'            # Jump to projects folder

# ==============================================================================
# 📂 File Operations
# ==============================================================================
alias mkdir='mkdir -pv'                         # Make directory with verbose output and parent dirs
alias cp='cp -iv'                               # Copy with interactive prompt and verbose output
alias mv='mv -iv'                               # Move/rename with interactive prompt and verbose output
alias rm='rm -Iv'                               # Remove with interactive prompt and verbose output
alias rmdir='rmdir -v'                          # Remove empty directory with verbose output

# ==============================================================================
# ⚙️ Clean, Native CLI Replacements
# ==============================================================================
alias ls='ls --color=auto --group-directories-first' # Native colored ls
alias l='ls -lh'                                     # Long format with human sizes
alias la='ls -A'                                     # Show hidden (excluding . and ..)
alias ll='ls -lAh'                                   # Long + hidden + human sizes
alias lt='tree -C'                                   # Pure native tree view (Fedora default)
alias zj='zellij --layout compact'                   # Compact Zellij

# ==============================================================================
# 🛠️ Core Native Tooling Aliases
# ==============================================================================
alias df='df -h -t btrfs -t ext4 -t vfat -t xfs'
alias du='du -h --max-depth=1 2>/dev/null | sort -h'
alias find='find . -name'                            # Simple native find syntax
alias grep='grep --color=auto -in'                   # Colorized, case-insensitive, line-numbered grep
alias ff='find . -type f 2>/dev/null'                # Pure native file list
