# lt — Show the directory tree, colored, respecting .gitignore.
# FORCES: colors, type marks, directories first.
#   lt                        # repo map; ignored files stay out
#   lt -L 2                   # two levels deep
#   lt -I 'node_modules'      # add ignore patterns
#   lt src/                   # one subtree
# See also: ez -T.
function lt --description "Display directory tree structure recursively"
    command tree -C -F --dirsfirst --gitignore $argv
end
