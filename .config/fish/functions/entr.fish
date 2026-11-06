# entr — Run a command when a watched file changes.
#   ls *.fish | entr fish -n %  # re-lint a fish file on save
#   ls *.py | entr pytest       # rerun tests on every edit
#   find . -name '*.go' | entr -c go build
# % expands to the changed file path. -c clears the screen first.
function entr --description "Run arbitrary commands when files change"
    command entr $argv
end
