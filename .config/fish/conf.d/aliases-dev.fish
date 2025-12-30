# ===========
# DEV ALIASES
# ===========

# ---
# GIT
# ---

alias ga="git add"                                                  # stage files
alias gap="git add -p"                                              # stage interactively
alias gst="git status -sb"                                          # compact status
alias gl="git log --oneline --graph --decorate"                     # visual history
alias gco="git switch"                                              # switch branch
alias gcob="git switch -c"                                          # create & switch branch
alias gf="git fetch --progress"                                     # fetch with progress
alias gpl="git pull --progress"                                     # pull with progress
alias gp="git push --progress"                                      # push with progress
alias gpf="git push --force-with-lease --progress"                  # safe force push
alias gd="git diff"                                                 # unstaged changes
alias gds="git diff --staged"                                       # staged changes
alias gss="git stash push -m"                                       # stash with message
alias gsp="git stash pop"                                           # restore latest stash

# Deep repack (Linus Torvalds' recommended settings): recompresses all objects with maximum delta depth and window.
# Shrinks .git to its theoretical minimum. May take minutes on large repos — ideal for final cleanup.
alias grepack="git repack -a -d -f --depth=250 --window=250"

# ----------
# GITHUB CLI
# ----------

alias ghc="gh repo clone"                                           # clone repo
alias ghs="gh repo view --web"                                      # open in browser
alias ghp="gh pr create --web"                                      # create PR in browser
alias ghpl="gh pr list --limit 10"                                  # list recent PRs
alias ghpc="gh pr checkout"                                         # checkout PR
alias ghi="gh issue create --web"                                   # create issue in browser
alias ghil="gh issue list"                                          # list issues

# ------
# PODMAN
# ------

alias podps="podman ps -a"                                          # list all containers
alias podimg="podman images"                                        # list images
alias podrun="podman run --rm -it"                                  # run disposable container
alias podexec="podman exec -it"                                     # exec into container
alias podlogs="podman logs -f"                                      # follow logs
alias podclean="podman system prune -f"                             # clean unused resources

# ---------
# UTILITIES
# ---------

alias ports="ss -tuln"                                              # show listening ports
alias myip="hostname -I"                                            # local IP addresses

# ----------------
# NODE.JS STARTERS
# ----------------

# alias vite="npm create vite@latest"
# alias nextjs="npx create-next-app@latest"
# alias expo="npx create-expo-app@latest"

alias vite="bun create vite"
alias nextjs="bun create next-app@latest"
alias expo="bun create expo-app"
