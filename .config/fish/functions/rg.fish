# rg — recursive search at warp speed. FORCES: --smart-case (all-lowercase
#      pattern = ignore case; any UPPERCASE = strict) and respects .gitignore;
#      hidden files are skipped unless you ask for them.
#   rg 'fn parse' src/        # find the needle
#   rg -w 'config'            # whole words only
#   rg -l 'TODO'              # file names only
#   rg -n -C2 'error'         # matches + 2 lines of context
#   rg -t py 'requests'       # only Python files
#   rg --hidden -g '!.git' 'secret'  # dig into hidden files too
function rg --description "Recursively search current directory for lines matching a pattern"
    command rg --smart-case $argv
end
