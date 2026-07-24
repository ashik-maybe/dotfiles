function l --description "List directory contents in compact view"
    command ls -lh --time-style=long-iso --group-directories-first -p $argv
end
