function cat --description "Inspect raw file formatting, invisible characters, and line endings"
    command cat --number --squeeze-blank --show-all $argv | less -RFX -+N --mouse
end
