# --- 🧹 TOOLS ---
# setup Biomejs in a web project
alias setup-biome="bun add -D -E @biomejs/biome && bunx biome init"
# setup Nativewind in Expo project
alias setup-nativewind="$HOME/scripts/setup-nativewind.sh"
# setup React Native Paper in Expo project
alias setup-react-native-paper="$HOME/scripts/setup-react-native-paper.sh"


# --- 🛠️ MAINTENANCE ---
# reset: Use this if the app is glitching or the laptop feels slow
alias reset="rm -rf .expo .next out dist build && bun pm cache clean"
# stop-all: Force kills background processes to free up RAM
alias stop-all="killall node bun"

# --- 🏗️ NEW PROJECTS ---
alias new-next="bun create next-app@latest"
alias new-expo="bun create expo-app"
alias new-vite="bun create vite"

# --- 🐍 PYTHON (UV) ---
alias py-new="uv init && uv venv"
alias py-add="uv add"
alias py-run="uv run"

# --- 🏗️ GIT & SYSTEM ---
# shrink-git: Compacts project size to save disk space
alias shrink-git="git repack -a -d -f --depth=250 --window=250"
