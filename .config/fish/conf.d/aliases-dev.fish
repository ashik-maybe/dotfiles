# ------------------------------
# Python (uv)
# ------------------------------
alias uvi 'uv pip install'                # Fast install
alias uvr 'uv pip uninstall'              # Fast remove
alias uvs 'uv sync'                       # Sync project dependencies
alias uvv 'uv venv'                       # Create .venv
alias uva 'source .venv/bin/activate.fish' # Quick activate (Fish syntax)
alias uvrun 'uv run'                      # Run script in project context
alias py 'python3'
alias pyclean 'find . -type d -name "__pycache__" -exec rm -rf {} +' # Purge cache

# ------------------------------
# Bun & JS/TS
# ------------------------------
alias b 'bun'
alias ba 'bun add'                        # Install package
alias bad 'bun add -D'                    # Install dev-dependency
alias br 'bun run'                        # Run scripts from package.json
alias bx 'bunx --bun'                     # Execute bin with bun speed
alias bi 'bun install'                    # Install all deps
alias brm 'bun remove'                    # Uninstall package
alias binit 'bun init'                    # New bun project
alias bclean 'rm -rf node_modules bun.lockb && bun install' # The "Nuclear" reset

# ------------------------------
# Scaffolding
# ------------------------------
alias biome-init 'bun add -D -E @biomejs/biome && bunx --bun @biomejs/biome init'  # Setup Biome
alias create-vite 'bun create vite@latest'          # Create Vite project
alias create-next 'bun create next-app@latest' # Create Next.js project
alias create-expo 'bun create expo-app@latest'      # Create Expo project
alias create-fastapi 'uv init --app'       # Modern FastAPI scaffold with uv
