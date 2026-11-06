# ncdu — Browse disk usage interactively and delete from inside.
#   ncdu .                    # scan the current directory
#   sudo ncdu /               # whole system (some paths need root)
#   ncdu -x /                 # stay on one filesystem
#   ncdu -o scan.json .       # scan now, browse later with -i scan.json
# See also: dust, du.
function ncdu --description "NCurses disk usage analyzer"
    command ncdu $argv
end
