function fn --description "Search for files by name pattern"
    command find . -iname $argv
end
