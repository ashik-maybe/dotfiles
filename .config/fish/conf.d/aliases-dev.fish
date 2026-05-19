# ------------------------------
# Python (uv)
# ------------------------------
alias ur 'uv run'                         # Runs scripts, handles venv, & auto-installs on the fly
alias ua 'uv add'                         # Replaces 'uv pip install' (adds to pyproject.toml correctly)
alias urm 'uv remove'                     # Replaces 'uv pip uninstall'
alias ux 'uvx'                            # Run ephemeral CLI tools (ruff, black, etc.) instantly
alias pyclean 'find . -type d -name "__pycache__" -exec rm -rf {} +' # Keep this, Python cache is annoying

# ------------------------------
# Bun & JS/TS
# ------------------------------
alias bd 'bun run dev'                    # The single most used command in frontend/fullstack
alias br 'bun run'                        # Run any other package.json scripts
alias bx 'bunx --bun'                     # Execute bins with bun speed (great addition)
alias ba 'bun add'                        # Install a package
alias bclean 'rm -rf node_modules bun.lockb && bun install' # Keep this "Nuclear" option for when npm gets weird

# ------------------------------
# Scaffolding
# ------------------------------
alias biome-init 'bun add -D -E @biomejs/biome && bunx --bun @biomejs/biome init'  # Setup Biome
alias create-vite 'bun create vite@latest'          # Create Vite project
alias create-shadcn 'bunx --bun shadcn@latest init' # Create shadcn/ui project
alias autoskills 'bunx autoskills'  # Auto-detect your tech stack and install the best AI agent skills for your project.
