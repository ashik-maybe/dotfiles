#!/bin/bash

# Input
if [[ -n "${1:-}" ]]; then
    [[ "$1" =~ ^[0-9]+$ ]] || { echo "error: pages must be a number" >&2; exit 1; }
    pages="$1"
else
    read -rp "pages: " pages
    [[ "$pages" =~ ^[0-9]+$ ]] || { echo "error: invalid number" >&2; exit 1; }
fi

read -rp "pace (default 20): " pace
pace=${pace:-20}
[[ "$pace" =~ ^[0-9]+$ ]] && (( pace > 0 )) || { echo "error: positive number required" >&2; exit 1; }

# Compute
days=$(( (pages + pace - 1) / pace ))
weeks=$(( days / 7 ))
extra=$(( days % 7 ))
months=$(( (days + 15) / 30 ))  # round to nearest month

# Output — clean, minimal, aligned
printf "\n%-12s %d\n" "pages:" "$pages"
printf "%-12s %d/day\n" "pace:" "$pace"
printf "%-12s %d days\n" "duration:" "$days"

if (( weeks > 0 )); then
    if (( extra > 0 )); then
        printf "%-12s %d weeks + %d days\n" " " "$weeks" "$extra"
    else
        printf "%-12s %d weeks\n" " " "$weeks"
    fi
fi

printf "%-12s ~%d month(s)\n" " " "$months"

# Finish date (Linux only)
if command -v date >/dev/null 2>&1 && date --version >/dev/null 2>&1; then
    finish=$(date -d "+$days days" +%Y-%m-%d)
    printf "%-12s %s\n" "finish:" "$finish"
fi

printf "\n"
