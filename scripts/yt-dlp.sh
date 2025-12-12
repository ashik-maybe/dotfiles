#!/bin/bash
#
# yt - A Better yt-dlp Script
#
# Usage:
#   yt [OPTIONS] <URL> [URL2] [URL3] ... [NEW_NAME]
#
# Options: (same as before)
#   -a, --audio           Download best audio → 320K MP3
#   -v, --video RES       Download video: 480, 720, 1080 (H.264 in MKV/MP4)
#   -b, --best            Best quality (H.264 + audio)
#   --subs [LANG]         Download official subs first, fallback to auto
#   --sb [CATS]           Remove SponsorBlock segments (e.g. sponsor,intro)
#   --sb-mark [CATS]      Mark SponsorBlock segments as chapters
#   --mp4                 Output as MP4 (better thumbnail & device support)
#   --resume              Resume partial downloads
#   -q, --quiet           Quiet mode
#   -h, --help            Show this help
#
# Examples:
#   yt -a "url1" "url2"
#   yt -v 720 "url1" "url2" "MyPlaylist"
#

YTDL_PATH="${YTDL_PATH:-$(command -v yt-dlp || echo 'yt-dlp')}"
FFMPEG_PATH="${FFMPEG_PATH:-$(command -v ffmpeg || echo 'ffmpeg')}"
VIDEO_DOWNLOAD_DIR="$HOME/Downloads/Video"
AUDIO_DOWNLOAD_DIR="$HOME/Downloads/Audio"
QUIET=false
RESUME=false
SUBS_LANG="en"
NEW_NAME=""
FORMAT=""
OUTPUT_DIR=""
EXTRA_OPTS=()
SPONSORBLOCK_REMOVE=""
SPONSORBLOCK_MARK=""
USE_MP4=false

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log() { ! $QUIET && echo -e "${BLUE}📺$NC $*"; }
success() { ! $QUIET && echo -e "${GREEN}✅$NC $*"; }
warn() { ! $QUIET && echo -e "${YELLOW}⚠️$NC $*"; }
error() { echo -e "${RED}❌$NC $*"; exit 1; }

show_help() {
    grep "^# " "${BASH_SOURCE[0]}" | sed 's/^# //'
}

sanitize() {
    echo "$1" | \
        sed 's/[<>:"/\\|?*]/_/g' | \
        tr -s '_' | \
        sed 's/^_*//;s/_*$//'
}

parse_args() {
    local positional=()
    while [[ $# -gt 0 ]]; do
        case $1 in
            -a|--audio)
                FORMAT="bestaudio"
                OUTPUT_DIR="$AUDIO_DOWNLOAD_DIR"
                EXTRA_OPTS+=(
                    -x --audio-format mp3 --audio-quality 320K
                    --embed-thumbnail --add-metadata
                    --embed-info-json
                )
                shift
                ;;
            -v|--video)
                local res="$2"
                if [[ -z "$res" ]]; then
                    error "Missing resolution for --video."
                fi
                FORMAT="bestvideo[height<=${res}][vcodec^=avc1]+bestaudio[acodec^=mp4a]/best[height<=${res}][vcodec^=avc1]"
                OUTPUT_DIR="$VIDEO_DOWNLOAD_DIR"
                EXTRA_OPTS+=(
                    --embed-thumbnail --add-metadata
                    --embed-chapters
                    --write-subs --write-auto-subs --embed-subs
                    --sub-langs "${SUBS_LANG}.*"
                    --skip-unavailable-fragments
                    --ignore-errors
                    --compat-options no-keep-subs
                    --embed-info-json
                )
                shift 2
                ;;
            -b|--best)
                FORMAT="bestvideo[vcodec^=avc1]+bestaudio/best[vcodec^=avc1]"
                OUTPUT_DIR="$VIDEO_DOWNLOAD_DIR"
                EXTRA_OPTS+=(
                    --embed-thumbnail --add-metadata
                    --embed-chapters
                    --write-subs --write-auto-subs --embed-subs
                    --sub-langs "${SUBS_LANG}.*"
                    --skip-unavailable-fragments
                    --ignore-errors
                    --compat-options no-keep-subs
                    --embed-info-json
                )
                shift
                ;;
            --subs)
                SUBS_LANG="${2:-en}"
                shift 2
                ;;
            --sb)
                SPONSORBLOCK_REMOVE="$2"
                shift 2
                ;;
            --sb-mark)
                SPONSORBLOCK_MARK="$2"
                shift 2
                ;;
            --mp4)
                USE_MP4=true
                shift
                ;;
            --resume)
                RESUME=true
                shift
                ;;
            -q|--quiet)
                QUIET=true
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

    # At least one URL required
    if [[ ${#positional[@]} -eq 0 ]]; then
        error "No URL provided!"
    fi

    # Separate URLs and optional final name
    URLS=()
    if [[ ${#positional[@]} -gt 1 ]]; then
        # If last item doesn't look like a URL (no :// and no youtube.com/vimeo/etc), treat as name
        local last="${positional[-1]}"
        if [[ "$last" != *"://"* ]] && [[ "$last" != *"youtube.com"* ]] && [[ "$last" != *"youtu.be"* ]] && [[ "$last" != *"vimeo.com"* ]]; then
            NEW_NAME="$last"
            URLS=("${positional[@]:0:${#positional[@]}-1}")
        else
            URLS=("${positional[@]}")
        fi
    else
        URLS=("${positional[@]}")
    fi

    # Default format if none selected
    if [ -z "$FORMAT" ]; then
        warn "No format selected! Defaulting to 1080p video."
        FORMAT="bestvideo[height<=1080][vcodec^=avc1]+bestaudio[acodec^=mp4a]/best[height<=1080][vcodec^=avc1]"
        OUTPUT_DIR="$VIDEO_DOWNLOAD_DIR"
        EXTRA_OPTS+=(
            --embed-thumbnail --add-metadata
            --embed-chapters
            --write-subs --write-auto-subs --embed-subs
            --sub-langs "${SUBS_LANG}.*"
            --skip-unavailable-fragments
            --ignore-errors
            --compat-options no-keep-subs
            --embed-info-json
        )
    fi

    if $USE_MP4; then
        EXTRA_OPTS+=(--merge-output-format mp4)
    else
        EXTRA_OPTS+=(--merge-output-format mkv)
    fi

    mkdir -p "$VIDEO_DOWNLOAD_DIR" "$AUDIO_DOWNLOAD_DIR" || \
        error "Failed to create download directories!"
}

download_single() {
    local url="$1"
    local index="$2"
    local total="$3"
    local base_name="$4"  # if set, used as prefix for multi-download

    log "[$index/$total] Downloading: ${url:0:50}..."

    local ytdl_cmd=(
        "$YTDL_PATH"
        -f "$FORMAT"
        --paths "$OUTPUT_DIR"
        --no-overwrites
        --console-title
        --progress
    )

    if [[ "$FORMAT" == "bestaudio"* ]]; then
        ytdl_cmd+=(
            --output "%(artist,creator,uploader)s - %(title)s.%(ext)s"
            --parse-metadata "title:(?P<artist>[^-\[]+?) - .+:artist"
            --parse-metadata "creator:artist"
        )
    else
        ytdl_cmd+=(
            --output "%(uploader)s - %(title)s (%(height)sp).%(ext)s"
        )
    fi

    $RESUME && ytdl_cmd+=(--continue)
    $QUIET && ytdl_cmd+=(--quiet --no-progress)
    ytdl_cmd+=("${EXTRA_OPTS[@]}")
    [ -n "$SPONSORBLOCK_REMOVE" ] && ytdl_cmd+=(--sponsorblock-remove "$SPONSORBLOCK_REMOVE")
    [ -n "$SPONSORBLOCK_MARK" ] && ytdl_cmd+=(--sponsorblock-mark "$SPONSORBLOCK_MARK")
    ytdl_cmd+=("$url")

    if "${ytdl_cmd[@]}"; then
        success "[$index/$total] Done!"
    else
        success "[$index/$total] Completed (errors ignored)."
    fi

    # Handle renaming
    if [[ -n "$base_name" ]]; then
        local last_file=$(find "$OUTPUT_DIR" -type f -not -name ".*" -newermt "2 minutes ago" 2>/dev/null | head -n1)
        if [[ -n "$last_file" ]]; then
            local ext="${last_file##*.}"
            local new_name
            if [[ $total -eq 1 ]]; then
                # Single file → use exact name
                new_name="$base_name.$ext"
            else
                # Multiple → add number
                new_name="${base_name}_$(printf "%02d" "$index").$ext"
            fi
            local new_path="$OUTPUT_DIR/$(sanitize "$new_name")"
            mv "$last_file" "$new_path"
            success "Renamed to: $(basename "$new_path")"
        fi
    fi
}

download_media() {
    local total=${#URLS[@]}
    log "Starting download of $total video(s)..."

    for i in "${!URLS[@]}"; do
        local idx=$((i + 1))
        download_single "${URLS[i]}" "$idx" "$total" "$NEW_NAME"
    done

    ! $QUIET && echo "📁 $OUTPUT_DIR"
}

main() {
    parse_args "$@"
    download_media
}

main "$@"
