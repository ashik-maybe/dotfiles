# fzf — Fuzzy finder. First call per shell installs fish bindings.
#   Ctrl-T     insert a file or directory path at the cursor
#   Ctrl-R     fuzzy-search command history
#   Alt-C      change to a picked directory
#   Shift-Tab  fuzzy completion (plain TAB stays normal)
#   printf '%s\n' a b c | fzf  # filter any piped list
#   fzf -e 'main'              # exact match, less fuzz
#   fzf --preview 'bat -n {}'  # preview pane beside the list
function fzf --description "Interactive general-purpose command-line fuzzy finder"
    if not functions -q fzf-history-widget; and not functions -q _fzf_search_history
        command fzf --fish | source
    end
    command fzf $argv
end
