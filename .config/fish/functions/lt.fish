# Usage: lt [dir]
# Tree view, colored, dirs first, respects .gitignore.
function lt
    command tree -C -F --dirsfirst --gitignore $argv
end
