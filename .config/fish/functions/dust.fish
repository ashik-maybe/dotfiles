# dust — du with bars: the space hogs jump out. FORCES: -r (reverse), -d 2
#        (two levels) and a less pager.
#   dust                      # hot folders in the current tree
#   dust ~/code               # survey anywhere
#   dust -n 20                # top 20 entries instead of terminal height
#   dust -F                   # biggest FILES only — find the monster
#   dust -t                   # group by file type: which extension eats disk?
#   dust -e '\.png$'          # only entries matching a regex
#   dust -X node_modules      # hide a directory by name
function dust --description 'Interactive tree-view disk space analyzer'
    command dust -r -d 2 $argv | less -RFX --mouse
    return $pipestatus[1]
end
