# Install on Fedora: sudo dnf install fd-find
# Usage: fdfind "pattern" [dir]
# Fast file finder. Defaults to searching hidden files and ignoring .git.
function fdfind
    command fdfind --hidden --exclude .git $argv
end
