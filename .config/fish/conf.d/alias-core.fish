# ~/.config/fish/conf.d/alias-core.fish

# ==============================================================================
# 📁 Essential Navigation
# ==============================================================================
alias .. 'cd ..'                        # Up 1 directory
alias ... 'cd ../..'                    # Up 2 directories
alias .... 'cd ../../..'                # Up 3 directories
alias c 'clear'                         # Clear terminal screen
alias q 'exit'                          # Close shell session

# ==============================================================================
# 📂 Safe File Operations
# ==============================================================================
alias mkdir 'mkdir -pv'                 # Create parents & print created dirs
alias cp 'cp -iv'                       # Prompt before overwrite & print action
alias mv 'mv -iv'                       # Prompt before overwrite & print action
alias rm 'rm -Iv'                       # Prompt once if deleting >3 files

# ==============================================================================
# ⚙️ File Listing (`ls` & `tree`)
# ==============================================================================
alias ls 'ls --color=auto --group-directories-first -p'                 # Colored, dirs first, trailing slashes
alias l 'ls -lh --time-style=long-iso --group-directories-first -p'     # Detailed list with ISO timestamps
alias la 'ls -A --group-directories-first -p'                           # Show hidden files (except . and ..)
alias ll 'ls -lAh --time-style=long-iso --group-directories-first -p'    # Detailed list including hidden files
alias lt 'tree -C -F --dirsfirst --gitignore'                           # Tree view ignoring .gitignore rules

# ==============================================================================
# 🛠️ Core Tool Enhancements
# ==============================================================================
# Auto-paged cat with line numbers & squeezed empty lines
function cat
    command cat -s $argv | less -R -i -N -X -F --shift 5
end

# Colored grep ignoring binary files and common project dependencies (.git, node_modules)
alias grep 'grep --color=auto -inI --exclude-dir=.git --exclude-dir=node_modules --exclude-dir=__pycache__'

# Disk space usage excluding virtual/temp mounts
alias df 'df -hT -x tmpfs -x devtmpfs -x squashfs -x overlay'

# Fast search helpers
alias fn 'find . -iname'                # Find by case-insensitive name
alias ff 'find . -type f'               # Find files only
alias fd 'find . -type d'               # Find directories only

# Quick public IP lookup
alias myip 'curl -s https://icanhazip.com'

# ==============================================================================
# 📄 Environment Pager Settings
# ==============================================================================
# Colors (-R), Smart-case (-i), Line numbers (-N), Auto-exit if small (-F)
set -gx LESS '-R -i -M -N -F -X --shift 5'
