# c — Clear the screen, or change directory when given a path.
#   c                         # clear the screen
#   c ~/Documents             # change to the path
#   c ..                      # any cd target works
function c --description "Quickly clear terminal screen or change directory"
    if set -q argv[1]
        builtin cd -- $argv
    else
        clear
    end
end
