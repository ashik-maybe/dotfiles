# Install on Fedora: sudo dnf install fzf
# Usage: fzf [args]
# Initializes fzf bindings ONLY on first use. Fails if fzf is not installed.
function fzf
    if not functions -q _fzf_search_history
        fzf --fish | source
    end
    command fzf $argv
end
