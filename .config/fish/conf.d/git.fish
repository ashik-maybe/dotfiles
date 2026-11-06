# Git abbreviations — daily workflow, helpers, and pull requests.

# Daily: the 20% of git you use most.
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

# Helpers: inspect and undo without leaving the shell.
abbr -a gb 'git branch'                                   # List local branches
abbr -a gd 'git diff'                                     # View unstaged changes
abbr -a gds 'git diff --staged'                           # View staged changes
abbr -a gunstage 'git restore --staged'                   # Unstage an accidental gaa
abbr -a gamend 'git commit --amend --no-edit'             # Add forgotten file to last commit
abbr -a gundo 'git reset --soft HEAD~1'                  # Undo last commit, keep staged

# Pull requests: requires gh. Install gh, then run `gh auth login`.
abbr -a gpr  'gh pr create'                               # Open a pull request
abbr -a gprl 'gh pr list'                                 # List this repo's PRs
abbr -a gprv 'gh pr view'                                 # Current branch's PR (add --web for browser)
abbr -a gprx 'gh pr checkout'                             # Check out a PR locally (x — gpr is create)

# Help: list all git abbreviations.
function ghelp --description "List all Git abbreviations"
    echo "
Daily:   gs, ga, gaa, gc, gpush, gpl, gss, gsp, gsl, gco, gcb, glog, glg
Helpers: gb, gd, gds, gunstage, gamend, gundo
PRs:     gpr, gprl, gprv, gprx (needs gh)
"
end

# Delta: pretty diffs. After installing git-delta, run once:
# git config --global core.pager delta
# git config --global interactive.diffFilter "delta --color-only"
# git config --global delta.navigate true
# git config --global delta.line-numbers true
# git config --global delta.side-by-side true
# git config --global merge.conflictStyle zdiff3
