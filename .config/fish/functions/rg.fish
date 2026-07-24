# Install on Fedora: sudo dnf install ripgrep
function rg --description "Recursively search current directory for lines matching a pattern"
    command rg --smart-case $argv
end
