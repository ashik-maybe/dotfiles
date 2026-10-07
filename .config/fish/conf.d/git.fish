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
abbr -a gss 'git stash'                                   # Stash work-in-progress
abbr -a gsp 'git stash pop'                               # Bring stashed work back
abbr -a gsl 'git stash list'                              # See all stashed entries
abbr -a gco 'git switch'                                  # Switch branches
abbr -a gcb 'git switch -c'                               # Create & switch to new branch
abbr -a glog 'git log --oneline'                          # Compact commit log
abbr -a glg 'git log --oneline --graph --all --decorate'  # Visual branch history

# ============================================================================
# HELPERS
# ============================================================================
abbr -a gb 'git branch'                                   # List local branches
abbr -a gd 'git diff'                                     # View unstaged changes
abbr -a gds 'git diff --staged'                           # View staged changes
abbr -a gunstage 'git restore --staged'                   # Unstage an accidental gaa
abbr -a gamend 'git commit --amend --no-edit'             # Add forgotten file to last commit
abbr -a g-undo 'git reset --soft HEAD~1'                  # Undo last commit, keep staged

# ============================================================================
# GITHUB PULL REQUESTS (requires gh — install + `gh auth login` when ready)
# ============================================================================
abbr -a gpr  'gh pr create'                               # Open a pull request
abbr -a gprl 'gh pr list'                                 # List this repo's PRs
abbr -a gprv 'gh pr view'                                 # Current branch's PR (add --web for browser)
abbr -a gprx 'gh pr checkout'                             # Check out a PR locally (x — gpr is create)

# ============================================================================
# HELP
# ============================================================================
function ghelp --description "List all Git abbreviations"
    echo "
Daily:   gs, ga, gaa, gc, gpush, gpl, gss, gsp, gsl, gco, gcb, glog, glg
Helpers: gb, gd, gds, gunstage, gamend, g-undo
PRs:     gpr, gprl, gprv, gprx (needs gh)
"
end

# ============================================================================
# DELTA — pretty git diffs. After installing git-delta, run ONCE (copy-paste):
# ============================================================================
# git config --global core.pager delta
# git config --global interactive.diffFilter "delta --color-only"
# git config --global delta.navigate true
# git config --global delta.line-numbers true
# git config --global delta.side-by-side true
# git config --global merge.conflictStyle zdiff3
