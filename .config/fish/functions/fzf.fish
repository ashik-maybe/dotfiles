# fzf — the fuzzy finder. FIRST call per shell wires up the bindings:
#   Ctrl-T     insert a file/dir path at the cursor
#   Ctrl-R     fuzzy-search command history (press again to re-sort)
#   Alt-C      cd into a picked directory
#   Shift-Tab  fuzzy completion (plain TAB still behaves normally)
#   printf '%s\n' a b c | fzf  # pipe any list in, get one pick back
#   fzf -e 'main'              # --exact: literal match, less fuzz
#   fzf --preview 'bat -n {}'  # preview pane alongside the list
function fzf --description "Interactive general-purpose command-line fuzzy finder"
    if not functions -q fzf-history-widget; and not functions -q _fzf_search_history
        command fzf --fish | source
    end
    command fzf $argv
end
