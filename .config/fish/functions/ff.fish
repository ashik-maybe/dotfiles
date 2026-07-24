function ff --description "Fuzzy find files in current directory subtree"
    command find . -type f -iname $argv
end
