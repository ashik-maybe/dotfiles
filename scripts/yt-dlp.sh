#!/usr/bin/env bash
#
# yt - yt-dlp wrapper script for downloading video/audio with SponsorBlock
#
# Usage: yt [options] <URL...> [custom_title]
# Options:
#   -a, --audio       Extract best quality MP3 audio
#   -v, --video RES   Download video at max resolution (e.g. -v 1080, -v 2160)
#   --resume          Resume incomplete downloads
#   -h, --help        Show help
#

set -euo pipefail

readonly YTDL_PATH="${YTDL_PATH:-$(command -v yt-dlp || echo 'yt-dlp')}"
readonly VIDEO_DIR="$HOME/Downloads/Video"
readonly AUDIO_DIR="$HOME/Downloads/Audio"

# Terminal Colors
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
URLS=()

log() { printf '%b\n' "${CYAN}Downloading:${NC} $*"; }
success() { printf '%b\n' "${GREEN}Done:${NC} $*"; }
warn() { printf '%b\n' "${YELLOW}Warning:${NC} $*"; }
error() { printf '%b\n' "${RED}Error:${NC} $*" >&2; exit 1; }
saved() { printf '%b\n' "${DIM}Saved to:${NC} $*"; }

show_help() {
    grep "^#" "${BASH_SOURCE[0]}" | sed 's/^# //;s/^#//'
}

video_opts() {
    echo --embed-thumbnail \
         --add-metadata \
         --embed-chapters \
         --write-subs \
         --write-auto-subs \
         --embed-subs \
         --sub-langs "en.*" \
         --sub-format srt \
         --skip-unavailable-fragments \
         --ignore-errors \
         --sponsorblock-remove sponsor,intro,outro,selfpromo,interaction
}

parse_args() {
    local positional=()
    local res=""

    while [[ $# -gt 0 ]]; do
        case "$1" in
            -a|--audio)
                FORMAT="bestaudio/best"
                OUTPUT_DIR="$AUDIO_DIR"
                EXTRA_OPTS+=(-x --audio-format mp3 --audio-quality 320K
                             --embed-thumbnail --add-metadata
                             --sponsorblock-remove sponsor,intro,outro,selfpromo)
                shift
                ;;
            -v|--video)
                res="${2:-}"
                if [[ -z "$res" ]]; then
                    error "Missing resolution for --video."
                fi
                FORMAT="bestvideo[height<=${res}]+bestaudio/best[height<=${res}]"
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
        FORMAT="bestvideo[height<=1080]+bestaudio/best[height<=1080]"
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
    local custom_name="$4"
    local ytdl_cmd=()

    log "[${index}/${total}] ${url}..."

    ytdl_cmd=("$YTDL_PATH"
        -f "$FORMAT"
        --paths "$OUTPUT_DIR"
        --no-overwrites
        --console-title
        --progress)

    if [[ -n "$custom_name" ]]; then
        if [[ $total -eq 1 ]]; then
            ytdl_cmd+=(--output "${custom_name}.%(ext)s")
        else
            ytdl_cmd+=(--output "${custom_name}_$(printf "%02d" "$index").%(ext)s")
        fi
    else
        if [[ "$OUTPUT_DIR" == "$AUDIO_DIR" ]]; then
            ytdl_cmd+=(--output "%(artist,uploader)s - %(title)s.%(ext)s")
        else
            ytdl_cmd+=(--output "%(uploader)s - %(title)s (%(height)sp).%(ext)s")
        fi
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
