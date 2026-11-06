# tldr — Quick examples for a command. Shorter than man pages.
#   tldr tar                  # the common tar commands
#   tldr ssh                  # same for any command
#   tldr -u                   # refresh the page cache (tealdeer)
#   man tar                   # full reference when examples are not enough
function tldr --description "Simplified man pages with practical examples"
    command tldr $argv
end
