# ===========
# DEV ALIASES
# ===========

# Deep repack (Linus Torvalds' recommended settings): recompresses all objects with maximum delta depth and window.
# Shrinks .git to its theoretical minimum. May take minutes on large repos — ideal for final cleanup.
alias grepack="git repack -a -d -f --depth=250 --window=250"

# ---------
# UTILITIES
# ---------

alias ports="ss -tuln"                                              # show listening ports
alias myip="hostname -I"                                            # local IP addresses

# ----------------
# NODE.JS STARTERS
# ----------------

alias vite="bun create vite"
alias nextjs="bun create next-app@latest"
alias expo="bun create expo-app"
alias tanstack="bun create @tanstack/start@latest"
