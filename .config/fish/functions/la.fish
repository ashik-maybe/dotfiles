function la --description "List all files including hidden entries with detailed attributes"
    command ls -A --group-directories-first -p $argv
end
