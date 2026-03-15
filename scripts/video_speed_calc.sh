#!/bin/bash
#
# vidlen - Calculate watch time at different speeds
#

set -euo pipefail

readonly YTDL_PATH="${YTDL_PATH:-$(command -v yt-dlp || echo 'yt-dlp')}"

readonly CYAN='\033[0;36m'
readonly GREEN='\033[0;32m'
readonly RED='\033[0;31m'
readonly DIM='\033[2m'
readonly NC='\033[0m'

to_sec() {
  local input="$1"
  IFS=':' read -ra p <<<"$input"
  local s=0
  case ${#p[@]} in
    1) s=${p[0]} ;;
    2) s=$((10#${p[0]}*60 + 10#${p[1]})) ;;
    3) s=$((10#${p[0]}*3600 + 10#${p[1]}*60 + 10#${p[2]})) ;;
    *) return 1 ;;
  esac
  if ! [[ "$s" =~ ^[0-9]+$ ]] || (( ${p[1]:-0} >= 60 )) || (( ${p[2]:-0} >= 60 )); then
    return 1
  fi
  echo "$s"
}

to_hms() {
  local sec="$1"
  printf "%02d:%02d:%02d" $((sec/3600)) $(((sec%3600)/60)) $((sec%60))
}

format_save() {
  local sec="$1"
  if ((sec >= 3600)); then
    printf "%dh %dm" $((sec/3600)) $(((sec%3600)/60))
  elif ((sec >= 60)); then
    printf "%dm %ds" $((sec/60)) $((sec%60))
  else
    printf "%ds" "$sec"
  fi
}

truncate() {
  local str="$1"
  local max="$2"
  if ((${#str} > max)); then
    echo "${str:0:$((max-3))}..."
  else
    echo "$str"
  fi
}

get_domain() {
  local url="$1"
  echo "$url" | sed -E 's|https?://([^/]+).*|\1|' | sed 's|www\.||'
}

fetch_duration() {
  local url="$1"
  local title=""
  local duration=""
  local count=1
  local durations=()

  title=$("$YTDL_PATH" --print title "$url" 2>/dev/null | head -n1)

  mapfile -t durations < <("$YTDL_PATH" --flat-playlist --print duration "$url" 2>/dev/null)
  count=${#durations[@]}

  if [[ $count -eq 0 ]]; then
    duration=$("$YTDL_PATH" --print duration "$url" 2>/dev/null)
    count=1
  else
    duration=0
    for d in "${durations[@]}"; do
      [[ "$d" =~ ^[0-9]+$ ]] && duration=$((duration + d))
    done
  fi

  if [[ -z "$duration" ]] || [[ "$duration" == "None" ]]; then
    return 1
  fi

  echo "$title|$duration|$count"
}

show_results() {
  local title="$1"
  local total_sec="$2"
  local count="$3"
  local domain="$4"

  local total_hms=$(to_hms "$total_sec")

  if [[ -n "$title" ]]; then
    printf '\n%b%s%b\n' "$CYAN" "$title ($domain)" "$NC"
  fi

  if [[ "$count" -gt 1 ]]; then
    printf '%b%d videos • %s%b\n' "$DIM" "$count" "$total_hms" "$NC"
  else
    printf '%bDuration: %s%b\n' "$DIM" "$total_hms" "$NC"
  fi

  echo
  local saved=""
  saved=$(format_save $((total_sec - total_sec * 100 / 125)))
  printf '%b  1.25x → %s (save %b%s%b)%b\n' "$DIM" "$(to_hms $((total_sec * 100 / 125)))" "$GREEN" "$saved" "$NC" "$NC"

  saved=$(format_save $((total_sec - total_sec * 2 / 3)))
  printf '%b  1.5x  → %s (save %b%s%b)%b\n' "$DIM" "$(to_hms $((total_sec * 2 / 3)))" "$GREEN" "$saved" "$NC" "$NC"

  saved=$(format_save $((total_sec - total_sec * 100 / 175)))
  printf '%b  1.75x → %s (save %b%s%b)%b\n' "$DIM" "$(to_hms $((total_sec * 100 / 175)))" "$GREEN" "$saved" "$NC" "$NC"

  saved=$(format_save $((total_sec / 2)))
  printf '%b  2.0x  → %s (save %b%s%b)%b\n' "$DIM" "$(to_hms $((total_sec / 2)))" "$GREEN" "$saved" "$NC" "$NC"
}

if ! command -v bc &>/dev/null; then
  printf '%bError: bc is required%b\n' "$RED" "$NC" >&2
  exit 1
fi

if [[ -z "${1:-}" ]]; then
  printf '%bEnter duration (HH:MM:SS):%b ' "$DIM" "$NC"
  read -r dur
  if [[ -z "$dur" ]]; then
    exit 1
  fi
  total_sec=$(to_sec "$dur") || exit 1
  show_results "" "$total_sec" 1 ""
  exit 0
fi

if [[ "$1" =~ ^[0-9:]+$ ]]; then
  total_sec=$(to_sec "$1") || exit 1
  show_results "" "$total_sec" 1 ""
  exit 0
fi

if [[ "$1" =~ ^https?:// ]]; then
  url="$1"
  domain=$(get_domain "$url")

  result=$(fetch_duration "$url") || {
    printf '%bCould not fetch duration, entering manual mode...%b\n' "$DIM" "$NC"
    printf '%bEnter duration (HH:MM:SS):%b ' "$DIM" "$NC"
    read -r dur
    total_sec=$(to_sec "$dur") || exit 1
    show_results "" "$total_sec" 1 ""
    exit 0
  }

  IFS='|' read -r title duration_str count <<<"$result"
  if [[ "$duration_str" =~ ^[0-9]+$ ]]; then
    total_sec="$duration_str"
  else
    total_sec=$(to_sec "$duration_str") || exit 1
  fi
  title=$(truncate "$title" 50)

  show_results "$title" "$total_sec" "$count" "$domain"
  exit 0
fi

printf '%bUsage: vidlen [URL or HH:MM:SS]%b\n' "$DIM" "$NC" >&2
exit 1
