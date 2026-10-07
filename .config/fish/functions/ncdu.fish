# ncdu — interactive disk usage: browse the tree and delete from inside it.
#   ncdu .                    # scan current directory, then navigate
#   sudo ncdu /               # whole system (permission blind spots need root)
#   ncdu -x /                 # stay on one filesystem, skip other mounts
#   ncdu -o scan.json .       # scan now …
#   ncdu -i scan.json         # … browse later, or on another machine
function ncdu --description "NCurses disk usage analyzer"
    command ncdu $argv
end
