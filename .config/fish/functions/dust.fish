function dust --description 'Interactive tree-view disk space analyzer'
    command dust -r -d 2 $argv | less -RFX -+N --mouse
end
