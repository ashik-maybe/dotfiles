# la — quick inventory: dotfiles included, directories first, names only.
#   la                        # what's hidden in here
#   la -l                     # add details (your flags append to the defaults)
#   la src/                   # just one directory
function la --description "List all files including hidden entries, directories first"
    command ls -A --group-directories-first -p $argv
end
