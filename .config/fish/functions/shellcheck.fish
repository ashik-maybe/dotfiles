# shellcheck — static analysis for shell scripts; catches the classic gotchas.
#   shellcheck build.sh       # all default warnings
#   shellcheck -x build.sh    # also follow `source`d files
#   shellcheck -S error s.sh  # gate CI on errors only
#   shellcheck -f gcc s.sh    # compiler-style output editors understand
#   # shellcheck disable=SC2086  # inline: silence one intentional case
function shellcheck --description "Static analysis for shell scripts"
    command shellcheck $argv
end
