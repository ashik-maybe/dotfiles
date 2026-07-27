function yazi --description "Blazing fast terminal file manager"
    # Scope tmp locally to prevent polluting shell variables
    set -l tmp (mktemp -t "yazi-cwd.XXXXXX")

    # Run yazi with passed arguments and record target directory
    command yazi $argv --cwd-file="$tmp"

    # Safely read path (handles spaces/newlines) and confirm directory exists
    if read -z cwd < "$tmp"; and [ "$cwd" != "$PWD" ]; and test -d "$cwd"
        builtin cd -- "$cwd"
    end

    # Clean up temp file
    command rm -f -- "$tmp"
end
