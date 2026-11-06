# fdfind — Find files by path pattern.
# FORCES: hidden files included, .git excluded. Pattern is regex, smart-case.
#   fdfind -e py              # by extension
#   fdfind -g '*.py'          # glob syntax instead of regex
#   fdfind main.rs            # substring match anywhere in the path
#   fdfind --type d           # directories only
# See also: ff, fn.
function fdfind --description "Fast and user-friendly alternative to find"
    # Debian/Ubuntu ship the binary as fdfind, Fedora as fd.
    if command -q fdfind
        command fdfind --hidden --exclude .git $argv
    else
        command fd --hidden --exclude .git $argv
    end
end
