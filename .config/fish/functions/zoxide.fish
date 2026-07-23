# Install on Fedora: sudo dnf install zoxide
# Usage: zoxide [args]
# Initializes zoxide ONLY on first use. Fails if zoxide is not installed.
function zoxide
    if not functions -q __zoxide_hook
        zoxide init fish | source
    end
    command zoxide $argv
end
