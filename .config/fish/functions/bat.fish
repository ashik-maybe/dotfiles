# Install on Fedora: sudo dnf install bat
function bat --description "Pretty-print file contents with syntax highlighting and Git status"
    command bat \
        --style=numbers,changes,header-filename \
        --paging=auto \
        --pager="less -RFX -+N --mouse" \
        $argv
end
