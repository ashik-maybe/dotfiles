# tldr — simplified man pages: practical examples instead of prose.
#   tldr tar                  # the 5 commands everyone forgets, instantly
#   tldr ssh                  # same energy for any CLI
#   tldr -u                   # refresh the page cache (tealdeer)
#   man tar                   # when you need the full reference
function tldr --description "Simplified man pages with practical examples"
    command tldr $argv
end
