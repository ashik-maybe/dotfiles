# fn — find ANYTHING by name (find -iname): files AND folders, case-insensitive.
#   fn '*lock*'                # lock files and lock folders alike
#   fn '.venv*'                # locate virtualenvs fast
#   fn 'src'                   # folders named src (ff would miss them)
# ff = files only — see ff.fish
function fn --description "Search for files by name pattern"
    if not set -q argv[1]
        echo "usage: fn <pattern>" >&2
        return 2
    end
    command find . -iname $argv
end
