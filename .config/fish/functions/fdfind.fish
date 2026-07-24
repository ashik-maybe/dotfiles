# Install on Fedora: sudo dnf install fd-find
function fdfind --description "Fast and user-friendly alternative to find"
    command fdfind --hidden --exclude .git $argv
end
