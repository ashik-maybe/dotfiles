# ~/.zsh/aliases-dev.zsh — Developer Aliases
# Aliases to speed up common dev tasks: Git, GitHub, Podman, Node, Python, and CLI tools

# 🐍 Python Virtualenv
alias av="source venv/bin/activate"     # Activates your Python virtual environment (if you have a 'venv' folder)
alias dv="deactivate"                   # Deactivates the current Python virtual environment

# 🟢 Node.js / NPM Starters
alias vite='npm create vite@latest'         # Starts a new Vite project (frontend tool for fast dev)
alias nextjs='npx create-next-app@latest'   # Starts a new Next.js project (React-based web framework)
alias t3='pnpm create t3-app@latest'        # Starts a new T3 Stack project (TypeScript + tRPC + Tailwind)

# 🧠 Git Aliases
alias g='git'

# 🐳 Docker Aliases
alias d='docker'

# 🐳 Podman Aliases
alias p='podman'

# 🧪 Misc Dev Tools

alias ports='ss -tuln'                      # Lists open ports and listening services
alias ipinfo='curl ipinfo.io'               # Shows your public IP address and location info
alias serve='python3 -m http.server 8000'   # Starts a simple web server on port 8000 (great for testing)
