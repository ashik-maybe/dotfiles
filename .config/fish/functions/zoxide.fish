# Install on Fedora: sudo dnf install zoxide
function zoxide --description "Smarter cd command with frecency-based directory jumping"
    if not functions -q __zoxide_hook
        zoxide init fish | source
    end
    command zoxide $argv
end
