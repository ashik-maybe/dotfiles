# lt — colored tree. FORCES: colors (-C), type marks (-F), directories first
#       and .gitignore-aware filtering.
#   lt                        # map of the repo; ignored stuff stays out
#   lt -L 2                   # only two levels deep
#   lt -I 'node_modules'      # extra ignore patterns (append)
#   lt src/                   # one subtree
function lt --description "Display directory tree structure recursively"
    command tree -C -F --dirsfirst --gitignore $argv
end
