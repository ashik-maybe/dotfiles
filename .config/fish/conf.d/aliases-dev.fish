# --- 🧹 TOOLS ---
alias add-biome="bun add -D -E @biomejs/biome && bunx biome init" # Setup Biome linter/formatter
alias add-tamagui="$HOME/scripts/setup-tamagui.sh"               # Setup Tamagui in Expo
alias add-react-native-paper="$HOME/scripts/setup-react-native-paper.sh" # Setup RN Paper in Expo
alias add-nativewind="$HOME/scripts/setup-nativewind.sh"         # Setup Nativewind Tailwind in Expo
alias add-unistyles="$HOME/scripts/setup-unistyles.sh"           # Setup RN Unistyles in Expo

# --- 🛠️ MAINTENANCE ---
alias dev="[ -f app.json ] && bun expo start || bun dev" # Runs expo if app.json exists, else bun dev

alias stop-all="killall node bun"                                     # Kill all background processes
alias reset="rm -rf .expo .next out dist build && bun pm cache clean" # Clear build artifacts
alias nuke="rm -rf node_modules bun.lockb && bun install"             # Hard reset local project
alias nuke-all="find . -name 'node_modules' -type d -prune -exec rm -rf '{}' +" # Delete all node_modules recursively

alias clean-npm="npm cache clean --force"                             # Clear npm global cache
alias clean-bun="rm -rf ~/.bun/install/cache"                         # Clear Bun global cache

# --- 🏗️ NEW PROJECTS ---
alias new-next="bun create next-app@latest" # New Next.js project
alias new-expo="bun create expo-app"        # New Expo project
alias new-vite="bun create vite"             # New Vite project

# --- 🐍 PYTHON (UV) ---
alias py-new="uv init && uv venv" # Init Python project and venv
alias py-add="uv add"             # Add Python package
alias py-run="uv run"             # Run Python script/module

# --- 🏗️ GIT & SYSTEM ---
alias gcm="git commit -m"        # Git commit with message
alias gca="git commit --amend --no-edit" # Amend last commit
alias gp="git push"              # Push to remote
alias shrink-git="git repack -a -d -f --depth=250 --window=250" # Compress git history
