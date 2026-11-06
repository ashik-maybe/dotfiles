# rg — Search files for a pattern. Respects .gitignore.
# FORCES: --smart-case (lowercase pattern ignores case, any uppercase is strict).
# Hidden files stay out unless requested.
#   rg 'fn parse' src/        # find the needle
#   rg -w 'config'            # whole words only
#   rg -l 'TODO'              # file names only
#   rg -n -C2 'error'         # matches plus 2 lines of context
#   rg -t py 'requests'       # Python files only
#   rg --hidden 'secret'      # include hidden files
# See also: grep.
function rg --description "Recursively search current directory for lines matching a pattern"
    command rg --smart-case $argv
end
