# fn — Find files and folders by name. Case-insensitive.
#   fn '*lock*'                # lock files and lock folders
#   fn '.venv*'                # locate virtualenvs fast
#   fn 'src'                   # folders named src
# See also: ff (files only).
function fn --description "Search for files by name pattern"
    if not set -q argv[1]
        echo "usage: fn <pattern>" >&2
        return 2
    end
    command find . -iname $argv
end
