# ~/.config/fish/conf.d/git.fish

# ============================================================================
# DAILY WORKFLOW (The 20% you use 80% of the time)
# ============================================================================
abbr -a gs 'git status -s'                                # Short status view
abbr -a ga 'git add'                                      # Stage specific file
abbr -a gaa 'git add -A'                                  # Stage all changes
abbr -a gc 'git commit -m'                                # Commit with inline message
abbr -a gpush 'git push -u origin (git rev-parse --abbrev-ref HEAD)' # Push current branch
abbr -a gpl 'git pull'                                    # Pull upstream changes
abbr -a gco 'git switch'                                  # Switch branches
abbr -a gcb 'git switch -c'                               # Create & switch to new branch
abbr -a glog 'git log --oneline'                          # Compact commit log

# ============================================================================
# HELPERS
# ============================================================================
abbr -a gb 'git branch'                                   # List local branches
abbr -a gd 'git diff'                                     # View unstaged changes
abbr -a gds 'git diff --staged'                           # View staged changes
abbr -a g-undo 'git reset --soft HEAD~1'                  # Undo last commit, keep staged

# ============================================================================
# HELP
# ============================================================================
function ghelp --description "List all Git abbreviations"
    echo "
Daily:   gs, ga, gaa, gc, gpush, gpl, gco, gcb, glog
Helpers: gb, gd, gds, g-undo
"
end
