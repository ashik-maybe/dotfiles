# l — everyday listing: size + long-ISO date, directories first.
#   l                         # who's here, how big, when touched
#   l -a                      # include dotfiles
#   l -t                      # newest first (sort flags win over defaults)
#   l src/                    # just one directory
function l --description "List directory contents with sizes and long-ISO dates"
    command ls -lh --time-style=long-iso --group-directories-first -p $argv
end
