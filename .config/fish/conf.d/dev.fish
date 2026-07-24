# ~/.config/fish/conf.d/dev.fish

# ==============================================================================
# CORE DEV WORKFLOW (Daily Use)
# ==============================================================================

# Multiplexer
abbr -a zj 'zellij --layout compact'          # Compact Zellij session

# Navigation
abbr -a cdd 'cd ~/Downloads'                  # Open Downloads
abbr -a cdp 'cd ~/projects'                   # Jump to projects directory
abbr -a cdw 'cd ~/work'                       # Jump to work directory

# Mise - Tool Management
abbr -a m 'mise'                              # Core CLI
abbr -a mu 'mise use'                         # Set local tool version
abbr -a mug 'mise use -g'                     # Set global tool version
abbr -a mr 'mise run'                         # Run mise.toml tasks

# ==============================================================================
# PROJECT SCAFFOLDING
# ==============================================================================
abbr -a cv 'mise x -- bun create vite@latest'
abbr -a cs 'mise x -- bunx --bun shadcn@latest init'
abbr -a cb 'mise x -- bunx --bun @biomejs/biome init'
abbr -a ask 'mise x -- bunx autoskills'
