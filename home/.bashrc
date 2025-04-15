# ~/.bashrc: executed by bash(1) for non-login shells.

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Append to the history file, don't overwrite it
shopt -s histappend

# Save each command immediately after execution
PROMPT_COMMAND='history -a'

# Add custom bin directory to PATH if it exists
if [ -d "$HOME/bin" ]; then
    export PATH="$HOME/bin:$PATH"
fi

# Enable programmable completion features (if available)
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi

# ====================
# General Aliases
# ====================

# Navigation shortcuts
alias ..='cd ..'          # Go up one directory
alias ...='cd ../..'      # Go up two directories
alias d='cd ~/Downloads'  # Shortcut to Downloads folder
alias dc='cd ~/Documents' # Shortcut to ~/Documents folder
alias c='clear'           # Clear the terminal screen

# List files with automatic color support (if terminal supports it)
alias ls='ls --color=auto'  # Enable colors if supported by the terminal
alias ll='ls -lh'          # Long listing with human-readable sizes
alias la='ls -A'           # Show all files, including hidden ones

# Common commands
alias h='history'          # Show command history
alias grep='grep --color=auto'  # Enable colors for grep if supported
alias mkdir='mkdir -p'     # Create parent directories as needed
alias rm='rm -i'           # Prompt before removing files
alias cp='cp -i'           # Prompt before overwriting files
alias mv='mv -i'           # Prompt before overwriting files

# System monitoring
alias top='btop'           # Use btop instead of top (install btop if not available)
alias df='df -h'           # Show disk usage in human-readable format
alias du='du -h --max-depth=1'  # Show directory sizes in human-readable format

# ====================
# Custom Aliases
# ====================

# Your custom script aliases
alias ar='~/bin/aria2c_script.sh'  # Alias for aria2c script
alias yt='~/bin/yt-dlp_script.sh'  # Alias for yt-dlp script

# Example: Add more custom aliases here
# alias example='command_to_run'

# ====================
# Function for extracting any archive
# ====================

extract() {
    if [ -z "$1" ]; then
        echo "Usage: extract <file>"
        return 1
    fi

    local file="$1"
    local filename=$(basename "$file")
    local target_dir="${filename%.*}"

    # Ensure the target directory exists
    mkdir -p "$target_dir"

    echo "Extracting '$file' into './$target_dir/'..."

    case "$file" in
        *.tar.bz2|*.tbz2) tar xjf "$file" -C "$target_dir" ;;
        *.tar.gz|*.tgz)   tar xzf "$file" -C "$target_dir" ;;
        *.tar.xz|*.txz)   tar xJf "$file" -C "$target_dir" ;;
        *.tar.lz|*.tlz)   tar --lzip -xf "$file" -C "$target_dir" ;;
        *.tar.zst|*.tzst) tar --zstd -xf "$file" -C "$target_dir" ;;
        *.tar)            tar xf "$file" -C "$target_dir" ;;
        *.gz)             gunzip -c "$file" > "$target_dir/${filename%.gz}" ;;
        *.bz2)            bunzip2 -c "$file" > "$target_dir/${filename%.bz2}" ;;
        *.xz)             unxz -c "$file" > "$target_dir/${filename%.xz}" ;;
        *.lzma)           unlzma -c "$file" > "$target_dir/${filename%.lzma}" ;;
        *.zip)            unzip "$file" -d "$target_dir" ;;
        *.rar)            unrar x "$file" "$target_dir/" ;;
        *.7z)             7z x "$file" -o"$target_dir" ;;
        *.Z)              uncompress "$file" ;;
        *.deb)            ar x "$file" -C "$target_dir" ;;
        *.rpm)            rpm2cpio "$file" | cpio -idmv -D "$target_dir" ;;
        *)                echo "Unsupported file type: $file" && return 1 ;;
    esac

    echo "Extraction complete."
}

# ====================
# Minimalist Stylized Prompt with Git Support
# ====================

# Function to display Git branch/status in the prompt
parse_git_branch() {
    git rev-parse --is-inside-work-tree &>/dev/null || return
    local branch=$(git branch 2>/dev/null | sed -n '/^\*/s/^\* \(.*\)/\1/p')
    local status=$(git status --porcelain 2>/dev/null)

    # Check for uncommitted changes
    if [[ -n $status ]]; then
        echo "[$branch ✱]"  # Add a star (*) if there are uncommitted changes
    else
        echo "[$branch]"
    fi
}

# Set a minimalist stylized prompt with Git support
export PS1="\u@\h:\w\[\e[38;5;208m\]\$(parse_git_branch)\[\e[0m\] \[\e[38;5;75m\]λ\[\e[0m\] "
