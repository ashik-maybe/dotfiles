# bat — Read files with syntax highlighting.
# FORCES: line numbers, git-change marks, file header, auto-paging through less.
#   bat README.md             # numbered view with a file header
#   bat -A notes.txt          # show tabs, line ends, non-printables
#   bat -d src/main.rs        # only lines changed from the git index
#   bat -l rust lib.rs        # force language when the extension is missing
#   bat -pp script.sh         # plain, no pager — clean output for pipes
# See also: cat.
function bat --description "Pretty-print file contents with syntax highlighting and Git status"
    command bat \
        --style=numbers,changes,header-filename \
        --paging=auto \
        --pager="less -RFX --mouse" \
        $argv
end
