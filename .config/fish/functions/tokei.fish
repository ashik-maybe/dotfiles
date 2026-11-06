# tokei — Count lines of code by language.
# Separates code, comments, and blank lines.
#   tokei                     # whole tree
#   tokei src/                # one subtree
#   tokei --sort code         # largest languages first
#   tokei -t Rust,Markdown    # selected languages only
#   tokei -o json | jq        # machine-readable output
function tokei --description "Count lines of code by language"
    command tokei $argv
end
