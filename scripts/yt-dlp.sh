#!/bin/bash
#
# yt-dlp wrapper script for downloading video/audio
#

set -euo pipefail

readonly YTDL_PATH="${YTDL_PATH:-$(command -v yt-dlp || echo 'yt-dlp')}"
readonly VIDEO_DIR="$HOME/Downloads/Video"
readonly AUDIO_DIR="$HOME/Downloads/Audio"

readonly CYAN='\033[0;36m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly RED='\033[0;31m'
readonly DIM='\033[2m'
readonly NC='\033[0m'

RESUME=false
NEW_NAME=""
FORMAT=""
OUTPUT_DIR=""
EXTRA_OPTS=()

log() {
  printf '%b\n' "${CYAN}Downloading:${NC} $*"
}

success() {
  printf '%b\n' "${GREEN}Done:${NC} $*"
}

warn() {
  printf '%b\n' "${YELLOW}Warning:${NC} $*"
}

error() {
  printf '%b\n' "${RED}Error:${NC} $*"
  exit 1
}

saved() {
  printf '%b\n' "${DIM}Saved to:${NC} $*"
}

show_help() {
  grep "^#" "${BASH_SOURCE[0]}" | sed 's/^# //;s/^#//'
}

sanitize() {
  echo "$1" | sed 's/[<>:"/\\|?*]/_/g' | tr -s '_' | sed 's/^_*//;s/_*$//'
}

video_opts() {
  echo --embed-thumbnail --add-metadata --embed-chapters \
    --write-subs --write-auto-subs --embed-subs \
    --sub-langs "en.*" --sub-format srt --skip-unavailable-fragments \
    --ignore-errors --embed-info-json
}

parse_args() {
  local positional=()
  local res=""

  while [[ $# -gt 0 ]]; do
    case "$1" in
      -a|--audio)
        FORMAT="bestaudio"
        OUTPUT_DIR="$AUDIO_DIR"
        EXTRA_OPTS+=(-x --audio-format mp3 --audio-quality 320K
                     --embed-thumbnail --add-metadata --embed-info-json)
        shift
        ;;
      -v|--video)
        res="${2:-}"
        if [[ -z "$res" ]]; then
          error "Missing resolution for --video."
        fi
        FORMAT="bestvideo[height<=${res}][vcodec^=avc1]+bestaudio[acodec^=mp4a]/best[height<=${res}][vcodec^=avc1]"
        OUTPUT_DIR="$VIDEO_DIR"
        EXTRA_OPTS+=($(video_opts))
        shift 2
        ;;
      --resume)
        RESUME=true
        shift
        ;;
      -h|--help)
        show_help
        exit 0
        ;;
      -*)
        error "Unknown option: $1"
        ;;
      *)
        positional+=("$1")
        shift
        ;;
    esac
  done

  if [[ ${#positional[@]} -eq 0 ]]; then
    error "No URL provided!"
  fi

  URLS=()
  if [[ ${#positional[@]} -gt 1 ]]; then
    local last="${positional[-1]}"
    if [[ "$last" != *://* ]]; then
      NEW_NAME="$last"
      URLS=("${positional[@]:0:${#positional[@]}-1}")
    else
      URLS=("${positional[@]}")
    fi
  else
    URLS=("${positional[@]}")
  fi

  if [[ -z "$FORMAT" ]]; then
    warn "No format selected, defaulting to 1080p video."
    FORMAT="bestvideo[height<=1080][vcodec^=avc1]+bestaudio[acodec^=mp4a]/best[height<=1080][vcodec^=avc1]"
    OUTPUT_DIR="$VIDEO_DIR"
    EXTRA_OPTS+=($(video_opts))
  fi

  EXTRA_OPTS+=(--merge-output-format mkv)

  mkdir -p "$VIDEO_DIR" "$AUDIO_DIR" || error "Failed to create directories!"
}

download_single() {
  local url="$1"
  local index="$2"
  local total="$3"
  local base_name="$4"
  local ytdl_cmd=()
  local last_file=""
  local new_name=""
  local new_path=""
  local ext=""

  log "[${index}/${total}] ${url:0:50}..."

  ytdl_cmd=("$YTDL_PATH" -f "$FORMAT" --paths "$OUTPUT_DIR"
            --no-overwrites --console-title --progress)

  if [[ "$FORMAT" == "bestaudio"* ]]; then
    ytdl_cmd+=(--output "%(artist,creator,uploader)s - %(title)s.%(ext)s"
               --parse-metadata "title:(?P<artist>[^-\[]+?) - .+:artist"
               --parse-metadata "creator:artist")
  else
    ytdl_cmd+=(--output "%(uploader)s - %(title)s (%(height)sp).%(ext)s")
  fi

  if "$RESUME"; then
    ytdl_cmd+=(--continue)
  fi

  ytdl_cmd+=("${EXTRA_OPTS[@]}")
  ytdl_cmd+=("$url")

  if "${ytdl_cmd[@]}"; then
    success "[${index}/${total}] Download complete"
  else
    warn "[${index}/${total}] Completed with errors"
  fi

  if [[ -n "$base_name" ]]; then
    last_file=$(find "$OUTPUT_DIR" -type f -not -name ".*" -newermt "2 minutes ago" 2>/dev/null | head -n1)
    if [[ -n "$last_file" ]]; then
      ext="${last_file##*.}"
      if [[ $total -eq 1 ]]; then
        new_name="$base_name.$ext"
      else
        new_name="${base_name}_$(printf "%02d" "$index").$ext"
      fi
      new_path="$OUTPUT_DIR/$(sanitize "$new_name")"
      mv "$last_file" "$new_path"
      success "[${index}/${total}] Renamed to $(basename "$new_path")"
    fi
  fi

  local target_file="${new_path:-$(find "$OUTPUT_DIR" -type f -not -name ".*" -newermt "2 minutes ago" -name "*.mkv" 2>/dev/null | head -n1)}"
  if [[ -n "$target_file" ]]; then
    local base_pattern
    base_pattern="$(basename "$target_file" .mkv)"
    find "$OUTPUT_DIR" -type f \( -name "${base_pattern}.*.srt" -o -name "${base_pattern}.*.vtt" \) -delete 2>/dev/null
  fi
}

download_media() {
  local total="${#URLS[@]}"
  local i=""

  for i in "${!URLS[@]}"; do
    download_single "${URLS[$i]}" "$((i + 1))" "$total" "$NEW_NAME"
  done

  saved "$OUTPUT_DIR"
}

main() {
  parse_args "$@"
  download_media
}

main "$@"
