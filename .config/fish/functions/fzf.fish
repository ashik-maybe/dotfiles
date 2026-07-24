# Install on Fedora: sudo dnf install fzf
function fzf --description "Interactive general-purpose command-line fuzzy finder"
    if not functions -q _fzf_search_history
        fzf --fish | source
    end
    command fzf $argv
end
