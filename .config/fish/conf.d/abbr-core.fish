# ~/.config/fish/conf.d/abbr-core.fish

# ==============================================================================
# 📁 Navigation Shortcuts
# ==============================================================================
abbr -a .. 'cd ..'                      # Up 1 dir
abbr -a ... 'cd ../..'                  # Up 2 dirs
abbr -a .... 'cd ../../..'              # Up 3 dirs
abbr -a c 'clear'                       # Clear screen
abbr -a q 'exit'                        # Quit shell

# ==============================================================================
# 📂 Safe File Operations
# ==============================================================================
abbr -a mkdir 'mkdir -pv'               # Safe mkdir
abbr -a cp 'cp -iv'                     # Interactive copy
abbr -a mv 'mv -iv'                     # Interactive move
abbr -a rm 'rm -Iv'                     # Safe remove (>3)
abbr -a rmdir 'rmdir -v'                # Verbose rmdir

# ==============================================================================
# ⚙️ File Listing (Stock `ls` & `tree`)
# ==============================================================================
abbr -a ls 'ls --color=auto --group-directories-first -p'                 # Colored listing
abbr -a l 'ls -lh --time-style=long-iso --group-directories-first -p'     # Long ISO list
abbr -a la 'ls -A --group-directories-first -p'                           # Almost all
abbr -a ll 'ls -lAh --time-style=long-iso --group-directories-first -p'    # Long ISO all
abbr -a lt 'tree -C -F --dirsfirst --gitignore'                           # Git-aware tree

# ==============================================================================
# 🛠️ Stock Tooling (Max Performance)
# ==============================================================================
# df: Displays human sizes, filesystem types (-T), excludes virtual mounts
abbr -a df 'df -hT -x tmpfs -x devtmpfs -x squashfs -x overlay'

# du: Sorts top directories >1MB
abbr -a du 'du -h -d 1 --threshold=1M'

# grep: Line numbers, case-insensitive, ignores binaries (-I) & dev dirs
abbr -a grep 'grep --color=auto -inI --exclude-dir=.git --exclude-dir=node_modules --exclude-dir=__pycache__'

# find helpers: Keeps base `find` stock
abbr -a fn 'find . -iname'              # Case-insensitive find
abbr -a ff 'find . -type f 2>/dev/null' # Files only
abbr -a fd 'find . -type d 2>/dev/null' # Dirs only

# ==============================================================================
# 📄 Environment Pager
# ==============================================================================
set -gx LESS '-R -i -M --shift 5'       # Enhanced less
