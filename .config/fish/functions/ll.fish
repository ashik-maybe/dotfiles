# ll — full listing: permissions, owner, size, date; dotfiles included.
#   ll                        # who owns what, what's executable
#   ll -t                     # newest first
#   ll src/                   # just one directory
function ll --description "List directory contents with extended file permissions and size"
    command ls -lAh --time-style=long-iso --group-directories-first -p $argv
end
