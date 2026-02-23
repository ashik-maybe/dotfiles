# --- 🛠️ DEVELOPMENT (Bun / uv) ---

# --- 🧹 Maintenance ---
alias dev-stop="killall node bun 2>/dev/null" # Stop all JS runtimes
alias dev-clean="rm -rf .expo .next out dist build && bun pm cache clean" # Wipe project artifacts
alias dev-rebuild="rm -rf node_modules bun.lockb && bun install" # Fresh install for Bun
alias sys-clean-node="find . -name 'node_modules' -type d -prune -exec rm -rf '{}' +" # Deep nuke node_modules
alias sys-clean-cache="rm -rf ~/.npm/_cacache ~/.bun/install/cache" # Clean JS caches (Fedora path)

# --- 🏗️ Scaffolding ---
alias new-vite="bun create vite"
alias new-next="bun create next-app@latest"
alias new-expo="bun create expo-app"

alias next-lens-pages="bun x next-lens@latest page:list" # List pages directly from the CLI

# --- 🐍 Python (uv) ---
alias py-init="uv init && uv venv"            # Initialize project + venv
alias py-add="uv add"                         # Add dependency
alias py-run="uv run"                         # Run script in venv
alias py-sync="uv sync"                       # Sync lockfile

# --- 🏗️ VERSION CONTROL (GIT) ---

# --- 🌿 Branching & Navigation ---
alias gb='git branch'                         # List branches
alias gcb='git checkout -b'                   # [Create] New feature branch
alias gco='git checkout'                      # [Checkout] Switch branch
alias gcm='git checkout main || git checkout master' # [Main] Jump to primary branch
alias gbd='git branch -d'                     # [Delete] Local branch
alias gbD='git branch -D'                     # [Force Delete] Local branch

# --- 🔄 Syncing & Remote ---
alias gl='git pull'                           # [L] Pull changes
alias glp='git pull && git remote prune origin' # [L] Pull + Prune deleted remote refs
alias gpush='git push -u origin $(git rev-parse --abbrev-ref HEAD)' # [Push] Current branch & set upstream

# --- 📝 Committing & Staging ---
alias gs='git status -s'                      # [S] Short status view
alias ga='git add'                            # [A] Add files
alias gaa='git add -A'                        # [A] Add All files
# [C] Fast commit: gc "feat: msg"
function gc
    git commit -m "$argv"
end
alias gca='git commit --amend --no-edit'      # [C] Amend: add staged changes to last commit
alias g-undo='git reset --soft HEAD~1'        # [Undo] Last commit, keep code changes

# --- 🔍 Logs & Diff ---
alias glg='git log --oneline --graph --all'   # [L] Graph view of history
alias g-last='git diff HEAD~1 HEAD --name-only' # [Last] Files in last commit

# --- 🧹 Maintenance & Cleanup ---
alias gbclean="git branch --merged | grep -v '^\*' | grep -v 'main' | grep -v 'master' | xargs -n 1 git branch -d" # [Clean] Delete merged branches
alias g-compress="git repack -a -d -f --depth=250 --window=250" # [Compress] Performance boost

# --- 🚀 Stack Specific (Bun/uv) ---
alias g-lint-bun='bun x eslint .'             # Lint before you push
alias g-lint-py='uv run ruff check .'         # Python linting
