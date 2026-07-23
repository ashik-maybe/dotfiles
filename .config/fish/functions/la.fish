# Usage: la [dir]
# List all, including hidden (except . and ..).
function la
    command ls -A --group-directories-first -p $argv
end
