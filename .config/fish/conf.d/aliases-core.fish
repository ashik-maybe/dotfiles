# Navigation, file operations, CLI replacements, and system utilities

# 📁 Navigation
alias ..='cd ..'                         # Go up one directory
alias ...='cd ../..'                     # Go up two directories
alias ....='cd ../../..'                 # Go up three directories
alias c='clear'                          # Clear terminal screen
alias q='exit'                           # Quit the shell
alias cdd='cd ~/Downloads'                # Jump to Downloads folder
alias cdp='cd ~/Documents/projects/'      # Jump to projects folder

# 📂 File Operations
alias mkdir='mkdir -pv'                 # Make directory with verbose output and parent dirs
alias cp='cp -iv'                       # Copy with interactive prompt and verbose output
alias mv='mv -iv'                       # Move/rename with interactive prompt and verbose output
alias rm='rm -Iv'                       # Remove with interactive prompt and verbose output
alias rmdir='rmdir -v'                  # Remove empty directory with verbose output

# ⚙️ Modern CLI Replacements
alias fetch='fastfetch -c examples/21.jsonc'     # Minimal system info
alias vim='nvim'                         # Use Neovim instead of Vim
alias top='btop'                         # Use btop instead of top
alias z='zoxide'                         # Smarter directory jumping
alias ls='lsd --color=auto --group-directories-first'  # Modern ls with colors and grouped dirs
alias bat='bat --paging=never'          # Syntax-highlighted cat with no paging
alias grep='rg'                          # Use ripgrep for fast searching
alias du='dust'                          # Disk usage with better visuals
alias df='duf'                           # Disk free space with better UI
alias find='fd'                          # fd: user-friendly find alternative
alias zj='zellij --layout compact'       # zellij: user-friendly terminal multiplexer

# 🛠️ System & Utilities

alias upgrade-everything="sudo dnf upgrade --refresh -y && flatpak upgrade -y && uv self update && bun upgrade && opencode upgrade && copilot update"

# Run last command with sudo (like "please do it")
function please
    if test (count $history) -gt 0
        set -l last_cmd $history[1]
        sudo $last_cmd
    else
        echo "No previous command found."
    end
end
