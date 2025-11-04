# ~/.zsh/aliases-dev.zsh — Developer Aliases
# Aliases to speed up common dev tasks: Git, GitHub, Podman, Node, Python, and CLI tools

# 🐍 Python Virtualenv
alias av="source venv/bin/activate"     # Activates your Python virtual environment (if you have a 'venv' folder)
alias dv="deactivate"                   # Deactivates the current Python virtual environment

# 🟢 Node.js / NPM Starters
alias vite='npm create vite@latest'         # Starts a new Vite project (frontend tool for fast dev)
alias nextjs='npx create-next-app@latest'   # Starts a new Next.js project (React-based web framework)
alias t3='pnpm create t3-app@latest'        # Starts a new T3 Stack project (TypeScript + tRPC + Tailwind)

# 🧠 Git Aliases (Local & Remote)
alias gs='git status'                       # Shows which files are changed, staged, or untracked
alias ga='git add'                          # Stages a file for commit
alias gaa='git add --all'                   # Stages all changes (new, modified, deleted)
alias gc='git commit -v'                    # Commits with a message and shows the diff
alias gcm='git commit -m'                   # Commits with a message (no diff preview)
alias gco='git checkout'                    # Switches to another branch
alias gb='git branch'                       # Lists all local branches
alias gcb='git checkout -b'                 # Creates a new branch and switches to it
alias gl='git log --oneline --graph --decorate'  # Shows commit history as a visual graph
alias gd='git diff'                         # Shows changes that haven’t been staged yet
alias gds='git diff --staged'               # Shows changes that are staged for commit
alias gp='git push'                         # Pushes your changes to the remote repo
alias gpl='git pull'                        # Pulls the latest changes from the remote repo
alias gfp='git fetch --prune'               # Updates remote branches and removes deleted ones
alias gr='git remote -v'                    # Shows the remote URLs for your repo
alias gcl='git clone'                       # Clones a repo from GitHub or another source
alias gmv='git mv'                          # Renames or moves a tracked file
alias grm='git rm'                          # Removes a tracked file
alias gstash='git stash'                    # Temporarily saves changes without committing
alias gstashp='git stash pop'               # Reapplies the last stashed changes
alias gclean='git clean -fd'                # Deletes untracked files and folders

# 🧠 Git QoL & Branch Management
alias gundo='git reset --soft HEAD~1'       # Undoes the last commit but keeps your changes
alias gfix='git commit --amend'             # Updates the last commit (e.g., fix typo in message)
alias gcleanall='git clean -fdx'            # Deletes all untracked and ignored files (use with caution!)
alias gprune='git remote prune origin'      # Cleans up branches that no longer exist on the remote
alias gsync='git pull --rebase && git push' # Pulls latest changes and pushes yours (keeps history clean)
alias gbd='git branch -d'                   # Deletes a branch (only if it’s merged)
alias gbD='git branch -D'                   # Force deletes a branch (even if not merged)
alias gpo='git push origin'                 # Pushes to the origin remote (you’ll need to specify a branch)
alias gpu='git push -u origin HEAD'         # Pushes current branch and sets it as the default upstream
alias gnew='git switch -c'                  # Creates and switches to a new branch (modern Git command)

# 🌐 GitHub Aliases (via CLI gh)
alias gh='gh'                               # Runs the GitHub CLI (must be installed)
alias ghrepo='gh repo view --web'           # Opens the current repo in your browser
alias ghclone='gh repo clone'               # Clones a GitHub repo using the CLI
alias ghpr='gh pr create --fill'            # Creates a pull request with auto-filled title and description
alias ghprs='gh pr status'                  # Shows the status of your pull requests
alias ghissue='gh issue create'             # Creates a new GitHub issue
alias ghview='gh issue view --web'          # Opens a GitHub issue in your browser

# 🐳 Docker Aliases (Container Dev)

alias d='docker'                            # Run Docker CLI
alias dps='docker ps -a'                    # List all containers (running + stopped)
alias dimg='docker images'                  # List all downloaded container images
alias drun='docker run -it --rm'            # Run a container interactively and auto-remove when done
alias dexec='docker exec -it'               # Attach to a running container (manual container ID required)
alias drm='docker rm'                       # Remove a container by ID or name
alias drmi='docker rmi'                     # Remove an image by ID or name
alias dbuild='docker build -t'              # Build an image from Dockerfile with a tag
alias dpull='docker pull'                   # Pull an image from a registry
alias dlogs='docker logs'                   # Show logs from a container
alias dstop='docker stop'                   # Stop a running container
alias dstart='docker start'                 # Start a stopped container
alias dsh='docker exec -it $(docker ps -q | head -n1) sh'       # Open `sh` in the first running container
alias dbash='docker exec -it $(docker ps -q | head -n1) bash'   # Open `bash` in the first running container
alias dprune='docker system prune -a -f'    # Remove all unused containers, images, networks (forcefully)

# 🐳 Podman Aliases (Container Dev – Docker-compatible CLI)

alias p='podman'                            # Run Podman CLI
alias pps='podman ps -a'                    # List all containers (running + stopped)
alias pimg='podman images'                  # List all downloaded container images
alias prun='podman run -it --rm'            # Run a container interactively and auto-remove when done
alias pexec='podman exec -it'               # Attach to a running container (manual container ID/name required)
alias prm='podman rm'                       # Remove a container by ID or name
alias prmi='podman rmi'                     # Remove an image by ID or name
alias pbuild='podman build -t'              # Build an image from Containerfile/Dockerfile with a tag
alias ppull='podman pull'                   # Pull an image from a registry
alias plogs='podman logs'                   # Show logs from a container
alias pstop='podman stop'                   # Stop a running container
alias pstart='podman start'                 # Start a stopped container
alias psh='podman exec -it $(podman ps -q | head -n1) sh'       # Open `sh` in the first running container
alias pbash='podman exec -it $(podman ps -q | head -n1) bash'   # Open `bash` in the first running container
alias pprune='podman system prune -a -f'    # Remove all unused containers, images, networks, volumes (forcefully)
alias pc='podman-compose'                   # Run Podman Compose (Docker Compose-compatible tool)

# 🧪 Misc Dev Tools

alias ports='ss -tuln'                      # Lists open ports and listening services
alias ipinfo='curl ipinfo.io'               # Shows your public IP address and location info
alias serve='python3 -m http.server 8000'   # Starts a simple web server on port 8000 (great for testing)
