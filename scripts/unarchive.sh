#!/bin/bash
#
# x - Extract archives
#

set -euo pipefail

readonly CYAN='\033[0;36m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly RED='\033[0;31m'
readonly DIM='\033[2m'
readonly NC='\033[0m'

log() {
  printf '%b%-%10s %s%b\n' "${CYAN}" "$1" "$2" "${NC}"
}

result() {
  printf '%b%-%10s %s%b\n' "${GREEN}" "$1" "$2" "${NC}"
}

error() {
  printf '%bError: %s%b\n' "${RED}" "$1" "${NC}" >&2
  exit 1
}

show_help() {
  grep "^#" "${BASH_SOURCE[0]}" | sed 's/^# //;s/^#//'
  exit 0
}

if [[ $# -eq 0 ]] || [[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]; then
  show_help
fi

for cmd in unzip unrar 7z; do
  if ! command -v "$cmd" &>/dev/null; then
    printf '%bWarning: %s not found%b\n' "${YELLOW}" "$cmd" "${NC}" >&2
  fi
done

extract_file() {
  local file="$1"
  local filename=""
  local target_dir=""
  local file_size=""
  local start_time end_time elapsed_time
  local extracted_size=""

  [[ -f "$file" ]] || error "'$file' is not a valid file."

  filename=$(basename "$file")
  target_dir="${filename%%.*}"

  mkdir -p "$target_dir" || error "Failed to create target directory '$target_dir'."

  file_size=$(stat -c%s "$file" 2>/dev/null || stat -f%z "$file" 2>/dev/null)

  log "Input:" "$filename"
  log "Size:" "$(numfmt --to=iec "$file_size")"
  log "Output:" "./$target_dir/"

  start_time=$(date +%s)

  case "$file" in
    *.tar.*|*.tar)
      tar -xf "$file" -C "$target_dir"
      ;;
    *.gz)
      gunzip -c "$file" > "$target_dir/${filename%.gz}"
      ;;
    *.bz2)
      bunzip2 -c "$file" > "$target_dir/${filename%.bz2}"
      ;;
    *.xz)
      unxz -c "$file" > "$target_dir/${filename%.xz}"
      ;;
    *.lzma)
      unlzma -c "$file" > "$target_dir/${filename%.lzma}"
      ;;
    *.Z)
      uncompress -c "$file" > "$target_dir/${filename%.Z}"
      ;;
    *.zip)
      unzip -q "$file" -d "$target_dir"
      ;;
    *.rar)
      unrar x -inul "$file" "$target_dir/"
      ;;
    *.7z)
      7z x "$file" -o"$target_dir" >/dev/null
      ;;
    *)
      error "Unsupported file type: '$file'"
      ;;
  esac

  end_time=$(date +%s)
  elapsed_time=$((end_time - start_time))
  extracted_size=$(du -sb "$target_dir" | cut -f1)

  result "Result:" "$(numfmt --to=iec "$extracted_size") extracted"
  result "Time:" "${elapsed_time}s"
  result "Done:" "Completed"
  echo
}

for archive in "$@"; do
  extract_file "$archive"
done
