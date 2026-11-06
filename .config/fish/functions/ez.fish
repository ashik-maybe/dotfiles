# ez — List files with eza: long view, git status, directories first.
#   ez                        # files plus git state
#   ez -T                     # tree view
#   ez -T --level 2           # tree, two levels deep
#   ez -la                    # include dotfiles
#   eza                       # raw binary: names-only grid, no forced flags
# See also: l, ll, la, lt.
function ez --description "Long listing with git status via eza"
    command eza -l --git --group-directories-first $argv
end
