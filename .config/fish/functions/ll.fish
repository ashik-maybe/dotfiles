# ll — Full listing: permissions, owner, size, date. Dotfiles included.
#   ll                        # who owns what, what is executable
#   ll -t                     # newest first
#   ll src/                   # list one directory
# See also: l, la, ez.
function ll --description "List directory contents with extended file permissions and size"
    command ls -lAh --time-style=long-iso --group-directories-first -p $argv
end
