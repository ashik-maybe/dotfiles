# grep — Search text for a pattern.
# FORCES: ignore case, line numbers, skip binaries, skip .git, node_modules, __pycache__, .venv, env.
#   grep -rn 'api' src/       # recursive search with line numbers
#   grep -rn -C3 'panic' src/ # 3 lines of context per match
#   grep -rln 'useState'      # file names only
#   grep -rv 'debug' src/     # lines without the match
#   grep -rw 'parse' src/     # whole words only
#   command grep -q pat file  # bypass this wrapper for raw output
# See also: rg.
function grep --description "Search plain-text data sets for lines matching a regular expression"
    command grep --color=auto -inI \
        --exclude-dir=.git \
        --exclude-dir=node_modules \
        --exclude-dir=__pycache__ \
        --exclude-dir=.venv \
        --exclude-dir=env \
        $argv
end
