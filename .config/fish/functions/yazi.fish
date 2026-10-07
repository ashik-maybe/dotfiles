# yazi — terminal file manager. Quit it with `q` and your shell lands in the
#        folder you were last browsing (cwd-file handshake below).
#   yazi                      # open in the current directory
#   yazi ~/Downloads          # start somewhere else (args pass through)
#   yazi .                    # then press q inside to "cd here" on exit
function yazi --description "Blazing fast terminal file manager"
    # Temp file yazi writes the target directory into (abort cleanly if mktemp fails)
    set -l tmp (mktemp -t "yazi-cwd.XXXXXX")
    or return 1

    # Run yazi with passed arguments and record its exit status
    command yazi $argv --cwd-file="$tmp"
    set -l yazi_status $status

    # Safely read path (handles spaces/newlines) and confirm directory exists
    set -l cd_status 0
    if read -z cwd < "$tmp"; and [ "$cwd" != "$PWD" ]; and test -d "$cwd"
        builtin cd -- "$cwd"
        or set cd_status $status
    end

    # Clean up temp file, then report the most meaningful status
    command rm -f -- "$tmp"
    if test $cd_status -ne 0
        return $cd_status
    end
    return $yazi_status
end
