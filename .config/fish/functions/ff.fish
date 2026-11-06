# ff — Find files by name. Case-insensitive, files only.
#   ff '*.md'                 # every markdown file below here
#   ff 'docker*'              # names starting with docker
#   ff '*lock*'               # package-lock, Cargo.lock, yarn.lock
# See also: fn (files and folders).
function ff --description "Fuzzy find files in current directory subtree"
    if not set -q argv[1]
        echo "usage: ff <pattern>" >&2
        return 2
    end
    command find . -type f -iname $argv
end
