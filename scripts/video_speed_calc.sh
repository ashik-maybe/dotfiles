#!/bin/bash

if ! command -v bc >/dev/null 2>&1; then
    printf "error: 'bc' is required\n" >&2
    exit 1
fi

to_sec() {
    IFS=':' read -ra p <<<"$1"
    case ${#p[@]} in
        1) s=${p[0]} ;;
        2) s=$((10#${p[0]}*60 + 10#${p[1]})) ;;
        3) s=$((10#${p[0]}*3600 + 10#${p[1]}*60 + 10#${p[2]})) ;;
        *) printf "invalid format\n" >&2; exit 1 ;;
    esac
    if ! [[ "$s" =~ ^[0-9]+$ ]] || (( ${p[1]:-0} >= 60 )) || (( ${p[2]:-0} >= 60 )); then
        printf "invalid time\n" >&2
        exit 1
    fi
    echo "$s"
}

to_hms() {
    printf "%02d:%02d:%02d" $(($1/3600)) $((($1%3600)/60)) $(($1%60))
}

is_valid_speed() {
    [[ "$1" =~ ^[0-9]*\.?[0-9]+$ ]] && (( $(echo "$1 > 0" | bc -l) ))
}

# Parse args
if [[ -n "${1:-}" ]] && ! [[ "$1" =~ ^[0-9:]+$ ]]; then
    printf "usage: %s [DURATION] [SPEED...]\n" "$0" >&2
    exit 1
fi

if [[ -n "${1:-}" ]] && [[ "$1" =~ ^[0-9:]+$ ]]; then
    dur="$1"
    shift
    custom_speeds=("$@")
else
    read -rp "duration (HH:MM:SS): " dur
    custom_speeds=()
fi

orig_sec=$(to_sec "$dur") || exit 1
orig_hms=$(to_hms "$orig_sec")

# Default speeds
default_speeds=(1.25 1.50 1.75 2.00)

# Merge: if custom speeds given, combine + sort + dedupe
if (( ${#custom_speeds[@]} > 0 )); then
    # Validate and collect all speeds
    all_speeds=("${default_speeds[@]}")
    for s in "${custom_speeds[@]}"; do
        if ! is_valid_speed "$s"; then
            printf "error: invalid speed '%s'\n" "$s" >&2
            exit 1
        fi
        all_speeds+=("$s")
    done

    # Sort numerically and dedupe (using awk)
    speeds=($(printf "%s\n" "${all_speeds[@]}" | awk '!seen[$0]++' | sort -n))
else
    speeds=("${default_speeds[@]}")
fi

# Output
printf "\n%s → \n\n" "$orig_hms"

for x in "${speeds[@]}"; do
    new_sec=$(printf "%.0f" "$(echo "$orig_sec / $x" | bc -l)")
    saved_sec=$((orig_sec - new_sec))
    new_time=$(to_hms "$new_sec")
    delta_m=$((saved_sec / 60))
    delta_s=$((saved_sec % 60))
    printf "  %-6s %s  (-%02d:%02d)\n" "${x}x" "$new_time" "$delta_m" "$delta_s"
done

printf "\n"
