function grep --description "Search plain-text data sets for lines matching a regular expression"
    command grep --color=auto -inI \
        --exclude-dir=.git \
        --exclude-dir=node_modules \
        --exclude-dir=__pycache__ \
        --exclude-dir=.venv \
        --exclude-dir=env \
        $argv
end
