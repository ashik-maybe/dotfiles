# entr — run a command whenever any watched file changes.
#   ls *.fish | entr fish -n %    # re-lint a fish file the moment you save
#   ls *.py | entr pytest         # rerun the suite on every edit
#   find . -name '*.go' | entr -c go build  # -c clears the screen first
#   # % is replaced with the path of the changed file
function entr --description "Run arbitrary commands when files change"
    command entr $argv
end
