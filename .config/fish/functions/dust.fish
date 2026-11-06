# dust — Show disk usage with bars, largest first.
# FORCES: -r (reverse), -d 2 (two levels), paged through less.
#   dust                      # hot folders in the current tree
#   dust ~/code               # survey another directory
#   dust -n 20                # top 20 entries
#   dust -F                   # largest files only
#   dust -t                   # group by file type
# See also: du, ncdu.
function dust --description 'Interactive tree-view disk space analyzer'
    command dust -r -d 2 $argv | less -RFX --mouse
    return $pipestatus[1]
end
