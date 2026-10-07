# fdfind — fast find. FORCES: hidden files searched and .git skipped; the
#          pattern is regex, smart-case (any UPPERCASE makes it strict).
#   fdfind -e py              # by extension (cleanest)
#   fdfind -g '*.py'          # glob syntax instead of regex
#   fdfind main.rs            # substring match anywhere in the path
#   fdfind --type d           # only directories
#   fdfind -e rs src/         # limit where it looks
function fdfind --description "Fast and user-friendly alternative to find"
    command fdfind --hidden --exclude .git $argv
end
