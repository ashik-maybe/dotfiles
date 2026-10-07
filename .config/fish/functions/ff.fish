# ff — find FILES by name (find -type f -iname): case-insensitive glob, files only.
#   ff '*.md'                 # every markdown file below here
#   ff 'docker*'              # names starting with docker
#   ff '*lock*'               # package-lock, Cargo.lock, yarn.lock
#   ff '*.[ch]'               # C sources (shell-style glob on the basename)
# fn does the same but matches folders too — see fn.fish
function ff --description "Fuzzy find files in current directory subtree"
    if not set -q argv[1]
        echo "usage: ff <pattern>" >&2
        return 2
    end
    command find . -type f -iname $argv
end
