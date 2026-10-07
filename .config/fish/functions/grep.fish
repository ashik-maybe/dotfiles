# grep — text search. FORCES: -i (ignore case), -n (line numbers), -I (skip
#        binaries) and skips dirs: .git node_modules __pycache__ .venv env.
#   grep -rn 'api' src/       # recursive + numbered — the everyday one
#   grep -rn -C3 'panic' src/ # 3 lines of context on each side
#   grep -rln 'useState'      # just file names (-l)
#   grep -rv 'debug' src/     # invert: lines WITHOUT the match
#   grep -rw 'parse' src/     # whole words only
#   command grep -q pat file  # raw/quiet — wrapper output is always numbered
function grep --description "Search plain-text data sets for lines matching a regular expression"
    command grep --color=auto -inI \
        --exclude-dir=.git \
        --exclude-dir=node_modules \
        --exclude-dir=__pycache__ \
        --exclude-dir=.venv \
        --exclude-dir=env \
        $argv
end
