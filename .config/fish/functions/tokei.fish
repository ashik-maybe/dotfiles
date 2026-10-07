# tokei — lines of code per language; separates code / comments / blanks.
#   tokei                     # stats for the current tree
#   tokei src/                # one subtree, or several paths
#   tokei --sort code         # biggest languages first
#   tokei -t Rust,Markdown    # only these languages
#   tokei -o json | jq        # machine-readable (dashboards, CI badges)
function tokei --description "Count lines of code by language"
    command tokei $argv
end
