# procs — modern `ps`: colored table, keyword filters, tree and watch modes.
#   procs                     # readable process list
#   procs nginx               # filter by name (matches user/command/docker)
#   procs --tree              # parent/child view
#   procs --watch             # live refresh, like top but still a list
#   procs --or 6000 60000     # numeric keywords match PID/TCP/UDP
function procs --description "Modern replacement for ps"
    command procs $argv
end
