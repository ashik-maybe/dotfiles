# --- 🛠️ MAINTENANCE (dev- / sys-) ---
alias dev-stop="killall node bun"
alias dev-clean="rm -rf .expo .next out dist build && bun pm cache clean"
alias dev-rebuild="rm -rf node_modules bun.lockb && bun install"
alias sys-clean-node="find . -name 'node_modules' -type d -prune -exec rm -rf '{}' +"
alias sys-clean-cache="npm cache clean --force && rm -rf ~/.bun/install/cache"

# --- 🏗️ SCAFFOLDING (new-) ---
alias new-vite="bun create vite"
alias new-next="bun create next-app@latest"
alias new-svelte="bunx sv create"
alias new-expo="bun create expo-app"

# --- 🐍 PYTHON (py-) ---
alias py-init="uv init && uv venv"
alias py-add="uv add"
alias py-run="uv run"

# --- 🏗️ VERSION CONTROL (g-) ---
alias g-cm="git commit -m"
alias g-ca="git commit --amend --no-edit"
alias g-ps="git push"
alias g-pl="git pull --rebase"
alias g-compress="git repack -a -d -f --depth=250 --window=250"
