# Usage: grep "pattern" [dir/file]
# Colored, case-insensitive, ignores binaries, git, node_modules, python venvs.
function grep
    command grep --color=auto -inI \
        --exclude-dir=.git \
        --exclude-dir=node_modules \
        --exclude-dir=__pycache__ \
        --exclude-dir=.venv \
        --exclude-dir=env \
        $argv
end
