# Usage: ll [dir]
# List all (including hidden), detailed, human-readable.
function ll
    command ls -lAh --time-style=long-iso --group-directories-first -p $argv
end
