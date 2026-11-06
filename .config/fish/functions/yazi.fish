# yazi — Terminal file manager. Press q inside to return to the last folder you browsed.
#   yazi                      # open the current directory
#   yazi ~/Downloads          # start in another directory
#   yazi .                    # press q inside to cd here on exit
function yazi --description "Blazing fast terminal file manager"
    # Temp file for the directory yazi quits in.
    set -l tmp (mktemp -t "yazi-cwd.XXXXXX")
    or return 1

    # Run yazi and record its exit status.
    command yazi $argv --cwd-file="$tmp"
    set -l yazi_status $status

    # Read the target path; change directory only if it exists and differs.
    set -l cd_status 0
    if read -z cwd < "$tmp"; and [ "$cwd" != "$PWD" ]; and test -d "$cwd"
        builtin cd -- "$cwd"
        or set cd_status $status
    end

    # Remove the temp file, then return the meaningful status.
    command rm -f -- "$tmp"
    if test $cd_status -ne 0
        return $cd_status
    end
    return $yazi_status
end
