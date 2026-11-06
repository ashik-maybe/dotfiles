# lt — Show the directory tree, colored, respecting .gitignore.
# FORCES: colors, type marks, dirs first, gitignore, empty dirs pruned,
#         junk excluded even outside a git repo.
#   lt                        # repo map; ignored files stay out
#   lt -L 2                   # two levels deep
#   lt -a                     # include dotfiles
#   lt src/                   # one subtree
# See also: ez -T.
function lt --description "Display directory tree structure recursively"
    command tree -C -F --dirsfirst --gitignore --prune \
        -I .git -I node_modules -I dist -I build -I __pycache__ \
        -I .venv -I target -I vendor -I .cache $argv
end
