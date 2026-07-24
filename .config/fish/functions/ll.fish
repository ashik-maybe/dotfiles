function ll --description "List directory contents with extended file permissions and size"
    command ls -lAh --time-style=long-iso --group-directories-first -p $argv
end
