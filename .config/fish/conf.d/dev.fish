# Dev abbreviations — multiplexer, navigation, mise, and scaffolding.

# Daily: start a compact Zellij session. Use `zj` to enter the multiplexer.
abbr -a zj 'zellij --layout compact'          # Compact Zellij session

# Navigation: jump to common directories.
abbr -a cdd 'cd ~/Downloads'                  # Open Downloads
abbr -a cdp 'cd ~/Documents/projects'         # Jump to projects directory
abbr -a cdw 'cd ~/Documents/work'             # Jump to work directory

# Mise: manage tool versions and run project tasks.
abbr -a m 'mise'                              # Core CLI
abbr -a mu 'mise use'                         # Set local tool version
abbr -a mug 'mise use -g'                     # Set global tool version
abbr -a mr 'mise run'                         # Run mise.toml tasks
abbr -a msup 'mise self-update --yes'         # Get latest mise update
abbr -a mup 'mise upgrade --minimum-release-age 0s' # Get latest package upgrades without wait

# Scaffolding: create a project with mise. See https://vite.dev/ and https://www.better-t-stack.dev/
abbr -a cv 'mise x -- bun create vite'
abbr -a cbt 'mise x -- bunx create-better-t-stack'
