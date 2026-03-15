#!/usr/bin/env bash
#
# k - Archive/compress tool (zstd or zip)
#

set -euo pipefail

readonly CYAN='\033[0;36m'
readonly GREEN='\033[0;32m'
readonly DIM='\033[2m'
readonly NC='\033[0m'

OUTFILE=""
FORCE=0
USE_ZIP=0

log() {
  printf '%b%-%10s %s%b\n' "${CYAN}" "$1" "$2" "${NC}"
}

result() {
  printf '%b%-%10s %s%b\n' "${GREEN}" "$1" "$2" "${NC}"
}

warn() {
  printf '%b%-%10s %s%b\n' "${YELLOW}" "$1" "$2" "${NC}"
}

error() {
  printf '%bError: %s%b\n' "${RED}" "$1" "${NC}" >&2
  exit 1
}

show_help() {
  grep "^#" "${BASH_SOURCE[0]}" | sed 's/^# //;s/^#//'
  exit 0
}

if [[ "${1:-}" == "--help" ]] || [[ "${1:-}" == "-h" ]]; then
  show_help
fi

while getopts ":o:fz" opt; do
  case "$opt" in
    o) OUTFILE="$OPTARG" ;;
    f) FORCE=1 ;;
    z) USE_ZIP=1 ;;
    *) error "Invalid option: -$OPTARG" ;;
  esac
done
shift $((OPTIND - 1))

if [[ $# -eq 0 ]]; then
  error "No folder specified."
fi

compress_folder() {
  local folder="$1"
  local name=""
  local archive=""
  local start_time end_time elapsed_time
  local archive_size folder_size saved ratio

  [[ ! -d "$folder" ]] && error "'$folder' is not a directory."

  name="$(basename "$folder")"

  log "Input:" "$folder"

  if [[ "$USE_ZIP" -eq 1 ]]; then
    archive="${OUTFILE:-$name.zip}"
    [[ -f "$archive" ]] && [[ "$FORCE" -ne 1 ]] && error "'$archive' exists. Use -f to overwrite."
    log "Method:" "zip -r -9"
    start_time=$(date +%s)
    zip -r -9 -q "$archive" "$folder"
    end_time=$(date +%s)
  else
    archive="${OUTFILE:-$name.tar.zst}"
    [[ -f "$archive" ]] && [[ "$FORCE" -ne 1 ]] && error "'$archive' exists. Use -f to overwrite."
    log "Method:" "zstd -22"
    start_time=$(date +%s)
    tar -cf - "$folder" | zstd --ultra -22 -T0 -c > "$archive"
    end_time=$(date +%s)
  fi

  elapsed_time=$((end_time - start_time))
  archive_size=$(stat -c%s "$archive" 2>/dev/null || stat -f%z "$archive" 2>/dev/null || echo "0")
  folder_size=$(du -sb "$folder" 2>/dev/null | cut -f1 || echo "0")

  if [[ "$folder_size" -gt 0 ]] && [[ "$archive_size" -gt 0 ]]; then
    saved=$((folder_size - archive_size))
    ratio=$(awk "BEGIN {printf \"%.0f\", $archive_size * 100 / $folder_size}")
    log "Original:" "$(numfmt --to=iec "$folder_size")"
    result "Result:" "$(numfmt --to=iec "$archive_size") (${ratio}% saved)"
  else
    log "Original:" "$(numfmt --to=iec "$folder_size")"
    result "Result:" "$(numfmt --to=iec "$archive_size")"
  fi

  result "Time:" "${elapsed_time}s"
  result "Saved:" "$archive"
  echo
}

for folder in "$@"; do
  compress_folder "$folder"
done
