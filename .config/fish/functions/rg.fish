# Install on Fedora: sudo dnf install ripgrep
# Usage: rg "pattern" [dir]
# Blazing fast search. Defaults to smart-case (case-insensitive unless uppercase used).
function rg
    command rg --smart-case $argv
end
