# l — List files with size and long-ISO date. Directories first.
#   l                         # who is here, how big, when touched
#   l -a                      # include dotfiles
#   l -t                      # newest first (your sort wins over the default)
#   l src/                    # list one directory
# See also: ll, la, ez.
function l --description "List directory contents with sizes and long-ISO dates"
    command ls -lh --time-style=long-iso --group-directories-first -p $argv
end
