# procs — List processes in a colored table.
#   procs                     # readable process list
#   procs nginx               # filter by name
#   procs --tree              # parent and child view
#   procs --watch             # live refresh
#   procs --or 6000 60000     # match PID or ports
function procs --description "Modern replacement for ps"
    command procs $argv
end
