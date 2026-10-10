# ~/.config/fish/conf.d/dev.fish

# ==============================================================================
# CORE DEV WORKFLOW (Daily Use)
# ==============================================================================

# Multiplexer
abbr -a zj 'zellij --layout compact'          # Compact Zellij session

# Navigation
abbr -a cdd 'cd ~/Downloads'                  # Open Downloads
abbr -a cdp 'cd ~/Documents/projects'         # Jump to projects directory
abbr -a cdw 'cd ~/Documents/work'             # Jump to work directory

# Mise - Tool Management
abbr -a m 'mise'                              # Core CLI
abbr -a mu 'mise use'                         # Set local tool version
abbr -a mug 'mise use -g'                     # Set global tool version
abbr -a mr 'mise run'                         # Run mise.toml tasks
abbr -a msup 'mise self-update --yes'         # Get latest mise update
abbr -a mup 'mise upgrade --minimum-release-age 0s' # Get latest package upgrades without wait

# ==============================================================================
# PROJECT SCAFFOLDING
# ==============================================================================
    # Create a Vite project via mise (https://vite.dev/)
abbr -a cv 'mise x -- bun create vite'
    # Create a Better-T-Stack project via mise (https://www.better-t-stack.dev/)
abbr -a ct 'mise x -- bunx create-better-t-stack'
