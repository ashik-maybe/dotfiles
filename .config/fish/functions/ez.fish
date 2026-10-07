# ez — eza done your way. FORCES: long listing (-l), git status (--git) and
#       directories sorted first.
#   ez                        # files + git state in one glance
#   ez -T                     # tree view
#   ez -T --level 2           # tree, exactly two levels deep
#   ez -la                    # include dotfiles
#   eza                       # raw binary: names-only grid, no forced flags
function ez --description "Long listing with git status via eza"
    command eza -l --git --group-directories-first $argv
end
