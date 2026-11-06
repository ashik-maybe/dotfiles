# la — List names only. Dotfiles included, directories first.
#   la                        # what is hidden here
#   la -l                     # add details; your flags append to the defaults
#   la src/                   # list one directory
# See also: l, ll, ez.
function la --description "List all files including hidden entries, directories first"
    command ls -A --group-directories-first -p $argv
end
