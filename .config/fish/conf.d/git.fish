# ============================================================================
# git.fish - Minimal Git Helper
# ============================================================================

# ------------------------------
# Daily (90% of work)
# ------------------------------
alias gs 'git status -s'     # Check what's changed
alias ga 'git add'           # Stage specific file
alias gaa 'git add -A'       # Stage all changes
alias gc 'git commit -m'     # Commit with message
alias gpush 'git push -u origin (git rev-parse --abbrev-ref HEAD)' # Push to remote
alias gpl 'git pull'         # Pull from remote
alias gco 'git checkout'     # Switch branches
alias gcb 'git checkout -b'   # Create new branch
alias glog 'git log --oneline' # View history
alias gmain 'git checkout main; or git checkout master' # Jump to main
alias g- 'git checkout -'    # Go back to previous branch

# ------------------------------
# Helpers
# ------------------------------
alias gb 'git branch'         # List branches
alias gd 'git diff'          # See unstaged changes
alias gds 'git diff --staged' # See staged changes
alias gst 'git stash push -m' # Stash work temporarily
alias gstp 'git stash pop'   # Restore stashed work
alias gstl 'git stash list'  # List all stashes
alias g-undo 'git reset --soft HEAD~1' # Undo last commit
alias gfix 'git commit --amend --no-edit' # Quick fix to last commit
alias gclean 'git clean -fd' # Remove untracked files

# ------------------------------
# Smart Functions
# ------------------------------
function gpf
    # Safe force push (use only after rebase!)
    git push --force-with-lease $argv
end

function grb
    # Rebase current branch onto main
    git rebase main; or git rebase master $argv
end

function gbdone
    # Done with branch? Checkout main, pull, delete current
    git checkout main; or git checkout master
    git pull
    set -l current (git rev-parse --abbrev-ref HEAD)
    test "$current" != "main" -a "$current" != "master" && git branch -d $current
end

function greset-hard
    # Nuclear option - destroys ALL changes (requires confirmation)
    echo "Type 'yes' to confirm: "
    read -l confirm
    test "$confirm" = "yes" && git reset --hard
end

function gwho
    # Who wrote this line?
    git blame -w -M $argv
end

# ------------------------------
# Wizards
# ------------------------------
function gwiz-commit
    # Guided commit - helps write proper commit messages
    echo "Type: feat/fix/docs/style/refactor/test/chore"
    read -l type -p "Type: "
    test -z "$type" && set type "feat"
    read -l desc -p "Description: "
    echo ""
    echo "$type: $desc"
    read -l confirm -p "Commit? (y/n): "
    test "$confirm" = "y" && git add -A && git commit -m "$type: $desc"
end

function gwiz-branch
    # Guided branch - similar to gwiz commit style
    echo "Type: feat/fix/hotfix/docs/refactor/test/chore"
    read -l type -p "Type: "
    test -z "$type" && set type "feature"
    read -l name -p "Name: "
    test -n "$name" && git checkout -b "$type/$name"
end

# ------------------------------
# Help
# ------------------------------
function ghelp
    echo "
Daily:   gs,ga,gaa,gc,gpush,gpl,gco,gcb,glog,gmain,g-
Helpers: gb,gd,gds,gst,gstp,gstl,g-undo,gfix,gclean
Smart:   gpf,grb,gbdone,greset-hard,gwho
Wizards: gwiz-commit,gwiz-branch
"
end
