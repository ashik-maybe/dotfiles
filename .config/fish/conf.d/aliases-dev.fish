# --- 🧹 CODE CLEANUP (Biome) ---
# setup: Run this once when starting a new project
alias setup-biome="bun add -D -E @biomejs/biome && bunx biome init"
# fix: Run this to clean up messy code and fix errors
alias fix="bunx biome check --write ."

# --- 🚀 RUN PROJECT ---
# 'start' automatically detects the project type (Mobile vs Web)
function dev
    if test -d .expo
        bunx expo start $argv
    else
        bun run dev $argv
    end
end
# --- 🛠️ MAINTENANCE ---
# reset: Use this if the app is glitching or the laptop feels slow
alias reset="rm -rf .expo .next out dist build && bun pm cache clean"
# stop-all: Force kills background processes to free up RAM
alias stop-all="killall node bun"

# --- 🏗️ NEW PROJECTS ---
alias new-web="bun create next-app@latest"
alias new-mobile="bun create expo"
alias new-vite="bun create vite"

# --- 🐍 PYTHON (UV) ---
alias py-new="uv init && uv venv"
alias py-add="uv add"
alias py-run="uv run"

# --- 🏗️ GIT & SYSTEM ---
# shrink-git: Compacts project size to save disk space
alias shrink-git="git repack -a -d -f --depth=250 --window=250"
