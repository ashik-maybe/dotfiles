# bat — syntax-highlighted file reader. FORCES: line numbers + git-change marks
#        (--style=numbers,changes,header-filename) and auto-paging via less.
#   bat README.md             # browse with numbers and a file header banner
#   bat -A notes.txt          # reveal tabs (^I), line ends ($), non-printables
#   bat -d src/main.rs        # only lines differing from the git index
#   bat -l rust lib.rs        # force a language when the extension is missing
#   bat -pp script.sh         # plain + never page: clean text for pipes
#   bat a.rs b.rs             # several files in one numbered stream
function bat --description "Pretty-print file contents with syntax highlighting and Git status"
    command bat \
        --style=numbers,changes,header-filename \
        --paging=auto \
        --pager="less -RFX --mouse" \
        $argv
end
