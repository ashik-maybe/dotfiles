# c — one key for housekeeping: clear the screen, or jump somewhere.
#   c                         # clear the screen (no arguments)
#   c ~/Documents             # cd there instead
#   c ..                      # any cd target works
function c --description "Quickly clear terminal screen or change directory"
    if set -q argv[1]
        builtin cd -- $argv
    else
        clear
    end
end
