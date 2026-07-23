# Usage: l [dir]
# Detailed, human-readable, ISO timestamps, dirs first.
function l
    command ls -lh --time-style=long-iso --group-directories-first -p $argv
end
