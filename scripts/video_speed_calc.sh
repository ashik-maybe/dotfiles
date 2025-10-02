#!/bin/bash

# Catppuccin Macchiato — minimalist palette
R='\033[0m'                          # reset
sp="\033[38;2;137;180;250m"         # blue: speed
nt="\033[38;2;249;226;175m"         # yellow: new time
sv="\033[38;2;166;227;161m"         # green: saved

to_sec() {
    IFS=':' read -ra p <<<"$1"
    case ${#p[@]} in
        1) s=${p[0]} ;;
        2) s=$((10#${p[0]}*60 + 10#${p[1]})) ;;
        3) s=$((10#${p[0]}*3600 + 10#${p[1]}*60 + 10#${p[2]})) ;;
        *) echo "Invalid format" >&2; exit 1 ;;
    esac
    [[ "$s" =~ ^[0-9]+$ ]] && (( ${p[1]:-0} < 60 && ${p[2]:-0} < 60 )) || { echo "Invalid time" >&2; exit 1; }
    echo "$s"
}

to_hms() {
    h=$(( $1 / 3600 )); m=$(( ($1 % 3600) / 60 )); s=$(( $1 % 60 ))
    printf "%02d:%02d:%02d" "$h" "$m" "$s"
}

# Input
dur=${1:-$(read -p "Duration (HH:MM:SS): " d; echo "$d")}
orig_sec=$(to_sec "$dur")
orig_hms=$(to_hms "$orig_sec")

# Output
echo
echo -e "${sp}Original:${R} ${orig_hms}"
echo -e "${sp}────────────────────────────${R}"
printf "${sp}%-6s ${nt}%-11s ${sv}%-11s${R}\n" "Speed" "Time" "Saved"
echo -e "${sp}────────────────────────────${R}"

for x in 1.25 1.50 1.75 2.00; do
    new_sec=$(printf "%.0f" "$(echo "$orig_sec / $x" | bc -l)")
    saved_sec=$(( orig_sec - new_sec ))
    printf "${sp}%-6s ${nt}%-11s ${sv}%-11s${R}\n" \
           "$x" "$(to_hms $new_sec)" "$(to_hms $saved_sec)"
done
