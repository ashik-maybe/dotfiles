# shellcheck — Check shell scripts for common errors.
#   shellcheck build.sh       # all default warnings
#   shellcheck -x build.sh    # also follow sourced files
#   shellcheck -S error s.sh  # fail CI on errors only
#   shellcheck -f gcc s.sh    # compiler-style output for editors
#   # shellcheck disable=SC2086 # silence one warning on a line
function shellcheck --description "Static analysis for shell scripts"
    command shellcheck $argv
end
