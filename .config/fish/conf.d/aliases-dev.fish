# --- 📦 SETUP & TOOLS (pkg-) ---
pkg-biome() {
    if [ -f "package.json" ]; then
        echo "Project detected. Installing Biome..."
        bun add -D -E @biomejs/biome && bunx --bun biome init
    else
        echo "Error: No package.json found. Please run this in your project root."
        return 1
    fi
}

alias pkg-tamagui="$HOME/scripts/setup-tamagui.sh"
alias pkg-paper="$HOME/scripts/setup-react-native-paper.sh"
alias pkg-wind="$HOME/scripts/setup-nativewind.sh"
alias pkg-uni="$HOME/scripts/setup-unistyles.sh"

# --- 🛠️ MAINTENANCE (dev- / sys-) ---
alias dev-stop="killall node bun"
alias dev-clean="rm -rf .expo .next out dist build && bun pm cache clean"
alias dev-rebuild="rm -rf node_modules bun.lockb && bun install"
alias sys-clean-node="find . -name 'node_modules' -type d -prune -exec rm -rf '{}' +"
alias sys-clean-cache="npm cache clean --force && rm -rf ~/.bun/install/cache"

# --- 🏗️ SCAFFOLDING (new-) ---
alias new-next="bun create next-app@latest"
alias new-expo="bun create expo-app"
alias new-vite="bun create vite"

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
