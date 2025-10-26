#!/bin/bash

# Portable, clean, and actually renders bold text
B=$'\033[1m'   # bold
R=$'\033[0m'   # reset

# Check for bc
if ! command -v bc >/dev/null 2>&1; then
    printf "Error: 'bc' is required.\n" >&2
    exit 1
fi

to_sec() {
    IFS=':' read -ra p <<<"$1"
    case ${#p[@]} in
        1) s=${p[0]} ;;
        2) s=$((10#${p[0]}*60 + 10#${p[1]})) ;;
        3) s=$((10#${p[0]}*3600 + 10#${p[1]}*60 + 10#${p[2]})) ;;
        *) printf "Invalid format\n" >&2; exit 1 ;;
    esac
    if ! [[ "$s" =~ ^[0-9]+$ ]] || (( ${p[1]:-0} >= 60 )) || (( ${p[2]:-0} >= 60 )); then
        printf "Invalid time\n" >&2
        exit 1
    fi
    echo "$s"
}

to_hms() {
    h=$(( $1 / 3600 )); m=$(( ($1 % 3600) / 60 )); s=$(( $1 % 60 ))
    printf "%02d:%02d:%02d" "$h" "$m" "$s"
}

# Input
if [[ -n "${1:-}" ]]; then
    dur="$1"
else
    read -rp "Duration (HH:MM:SS): " dur
fi

orig_sec=$(to_sec "$dur")
orig_hms=$(to_hms "$orig_sec")

# Output — with leading space and proper ANSI rendering
printf "\n"
printf " ${B}Original Video Length:${R} %s\n" "$orig_hms"
printf "\n"
printf " ${B}Speed   New Time    Saved${R}\n"
printf " -------------------------------\n"

for x in 1.25 1.50 1.75 2.00; do
    new_sec=$(printf "%.0f" "$(echo "$orig_sec / $x" | bc -l)")
    saved_sec=$(( orig_sec - new_sec ))
    printf " %-6s  %8s    %8s\n" "$x" "$(to_hms $new_sec)" "$(to_hms $saved_sec)"
done

printf "\n"
