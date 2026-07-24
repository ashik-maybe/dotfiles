function lt --description "Display directory tree structure recursively"
    command tree -C -F --dirsfirst --gitignore $argv
end
