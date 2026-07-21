# ~/.config/fish/conf.d/git.fish

# ============================================================================
# 1. DAILY WORKFLOW (Abbreviations)
# ============================================================================
abbr -a gs 'git status -s'                                # Short status view
abbr -a ga 'git add'                                      # Stage specific file
abbr -a gaa 'git add -A'                                  # Stage all changes
abbr -a gc 'git commit -m'                                # Commit with inline message
abbr -a gpush 'git push -u origin (git rev-parse --abbrev-ref HEAD)' # Push current branch to remote
abbr -a gpl 'git pull'                                    # Pull upstream changes
abbr -a gco 'git switch'                                  # Switch branches
abbr -a gcb 'git switch -c'                               # Create & switch to new branch
abbr -a glog 'git log --oneline'                          # Compact commit log
abbr -a gmain 'git switch main 2>/dev/null; or git switch master' # Jump to main/master branch
abbr -a g- 'git switch -'                                 # Switch to previous branch

abbr -a gfix 'git commit --amend --no-edit'               # Amend staged changes into last commit
abbr -a gpa 'git push origin --all'                       # Push all local branches to remote
abbr -a gpla 'git fetch --all'                            # Fetch all remote branches

# ============================================================================
# 2. HELPERS (Abbreviations)
# ============================================================================
abbr -a gb 'git branch'                                   # List local branches
abbr -a gd 'git diff'                                     # View unstaged changes
abbr -a gds 'git diff --staged'                           # View staged changes
abbr -a gst 'git stash push -m'                           # Stash changes with message
abbr -a gstp 'git stash pop'                              # Restore last stashed changes
abbr -a gstl 'git stash list'                             # List all stashes
abbr -a g-undo 'git reset --soft HEAD~1'                  # Undo last commit, keep changes staged
abbr -a gclean 'git clean -fd'                            # Force remove untracked files/dirs

# ============================================================================
# 3. SMART FUNCTIONS
# ============================================================================
function gpf --description "Safe force push with lease"
    git push --force-with-lease $argv
end

function grb --description "Rebase current branch onto main/master"
    git rebase main 2>/dev/null; or git rebase master $argv
end

function gbdone --description "Clean up completed feature branch"
    set -l current (git rev-parse --abbrev-ref HEAD)

    if test "$current" = "main" -o "$current" = "master"
        echo "⚠️  You are already on $current!"
        return 1
    end

    git switch main 2>/dev/null; or git switch master
    git pull
    git branch -d $current                        # Delete former feature branch safely
end

function greset-hard --description "Nuclear option: reset all tracked changes"
    read -P "Type 'yes' to confirm hard reset: " -l confirm
    if test "$confirm" = "yes"
        git reset --hard                          # Destroy all uncommitted local changes
        echo "💥 Hard reset executed."
    else
        echo "Cancelled."
    end
end

function gwho --description "Git blame ignoring whitespace and moves"
    git blame -w -M $argv                         # Blame line authors, ignoring whitespace
end

# ============================================================================
# 4. WIZARDS
# ============================================================================
function gwiz-commit --description "Guided conventional commit"
    read -P "Type [feat/fix/docs/style/refactor/test/chore] (feat): " -l type
    test -z "$type"; and set type "feat"

    read -P "Description: " -l desc
    test -z "$desc"; and echo "Cancelled: Description required." && return 1

    echo -e "\nCommit message -> $type: $desc"
    read -P "Commit all changes? (y/N): " -l confirm

    if test "$confirm" = "y" -o "$confirm" = "Y"
        git add -A && git commit -m "$type: $desc"
    else
        echo "Cancelled."
    end
end

function gwiz-branch --description "Guided branch creator"
    read -P "Type [feat/fix/hotfix/docs/refactor/chore] (feat): " -l type
    test -z "$type"; and set type "feat"

    read -P "Branch name: " -l name
    if test -n "$name"
        git switch -c "$type/$name"
    else
        echo "Cancelled: Name required."
    end
end

# ============================================================================
# 5. HELP
# ============================================================================
function ghelp --description "List all Git abbreviations & functions"
    echo "
Daily:   gs, ga, gaa, gc, gpush, gpl, gco, gcb, glog, gmain, g-
Helpers: gb, gd, gds, gst, gstp, gstl, g-undo, gfix, gclean, gpa, gpla
Smart:   gpf, grb, gbdone, greset-hard, gwho
Wizards: gwiz-commit, gwiz-branch
"
end
