# ~/.config/fish/conf.d/abbr-dev.fish

# ==============================================================================
# 1. NAVIGATION & MULTIPLEXER
# ==============================================================================
abbr -a cdd 'cd ~/Downloads'                  # Open Downloads
abbr -a cdp 'cd ~/Documents/projects/'        # Open Projects
abbr -a zj 'zellij --layout compact'          # Compact Zellij session

# ==============================================================================
# 2. MISE (Dev Environment & Tooling)
# ==============================================================================
# Daily Workflow
abbr -a m 'mise'                              # Core CLI shortener
abbr -a mx 'mise x --'                        # Run one-off command
abbr -a mr 'mise run'                         # Run mise.toml tasks

# Tool Management
abbr -a mu 'mise use'                         # Local tool version
abbr -a mug 'mise use -g'                     # Global tool version
abbr -a mi 'mise install'                     # Install directory tools
abbr -a mls 'mise ls'                         # List active tools

# ==============================================================================
# 3. PROJECT SCAFFOLDING & ONE-OFF RUNS
# ==============================================================================
abbr -a cv 'mise x -- bun create vite@latest'
abbr -a cs 'mise x -- bunx --bun shadcn@latest init'
abbr -a cb 'mise x -- bunx --bun @biomejs/biome init'
abbr -a ask 'mise x -- bunx autoskills'

# ==============================================================================
# 4. SMART MAINTENANCE & CLEANUP
# ==============================================================================
function mc --description "Smart clean for Python (uv) and JS/TS build artifacts"
    set -l found 0

    # Python Artifacts
    if test -f pyproject.toml -o -f requirements.txt -o -f setup.py
        echo "🐍 Cleaning Python artifacts..."
        find . -type d \( -name "__pycache__" -o -name ".pytest_cache" -o -name ".ruff_cache" -o -name ".venv" \) -exec rm -rf {} + 2>/dev/null
        set found 1
    end

    # JS / TS Artifacts
    if test -f package.json -o -f bun.lockb -o -f pnpm-lock.yaml
        echo "⚡ Cleaning JS/TS artifacts..."
        find . -type d \( -name "node_modules" -o -name ".next" -o -name "dist" -o -name ".turbo" -o -name "build" \) -exec rm -rf {} + 2>/dev/null
        set found 1
    end

    # Generic Fallback
    if test $found -eq 0
        echo "🧹 No stack files found. Running generic cache sweep..."
        find . -type d \( -name "__pycache__" -o -name "node_modules" -o -name "dist" \) -exec rm -rf {} + 2>/dev/null
    end

    echo "✨ Done!"
end
cd
