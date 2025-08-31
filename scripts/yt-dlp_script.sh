#!/bin/bash
#
# yt - Ultimate yt-dlp Frontend
#
# Usage:
#   yt [OPTIONS] <URL> [NEW_NAME]
#
# Options:
#   -a, --audio           Download best audio → 320K MP3
#   -v, --video RES       Download video: 480, 720, 1080 (H.264 in MKV/MP4)
#   -b, --best            Best quality (H.264 + audio)
#   -n, --name NAME       Rename output file
#   --subs [LANG]         Download official subs first, fallback to auto
#   --sb [CATS]           Remove SponsorBlock segments (e.g. sponsor,intro)
#   --sb-mark [CATS]      Mark SponsorBlock segments as chapters
#   --mp4                 Output as MP4 (better thumbnail & device support)
#   --resume              Resume partial downloads
#   -q, --quiet           Quiet mode
#   -h, --help            Show this help
#
# Examples:
#   yt -a "https://youtu.be/abc" "My Song"
#   yt -v 720 "https://youtu.be/xyz" "Tutorial"
#   yt -v 720 --mp4 "url"
#   yt -v 720 --sb "sponsor,intro" "url"

# === Config ===
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

# === Colors & Logging ===
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log() { ! $QUIET && echo -e "${BLUE}📺$NC $*"; }
success() { ! $QUIET && echo -e "${GREEN}✅$NC $*"; }
warn() { ! $QUIET && echo -e "${YELLOW}⚠️$NC $*"; }
error() { echo -e "${RED}❌$NC $*"; exit 1; }

# === Help ===
show_help() {
    grep "^# " "${BASH_SOURCE[0]}" | sed 's/^# //'
}

# === Sanitize Filename ===
sanitize() {
    echo "$1" | sed 's/[<>:"/\\|?*]/_/g' | tr -s '_' | sed 's/^_*//;s/_*$//'
}

# === Parse Args ===
parse_args() {
    local args=()
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
            -n|--name)
                NEW_NAME="$2"
                shift 2
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
                show_help
                exit 1
                ;;
            *)
                args+=("$1")
                shift
                ;;
        esac
    done

    case ${#args[@]} in
        0)
            error "No URL provided!"
            show_help
            exit 1
            ;;
        1)
            URL="${args[0]}"
            ;;
        *)
            URL="${args[0]}"
            NEW_NAME="${args[1]}"
            ;;
    esac

    if [ -z "$FORMAT" ]; then
        error "No format selected! Use -a, -v, or -b."
        show_help
        exit 1
    fi

    # Set output format
    if $USE_MP4; then
        EXTRA_OPTS+=(--merge-output-format mp4)
    else
        EXTRA_OPTS+=(--merge-output-format mkv)
    fi

    mkdir -p "$VIDEO_DOWNLOAD_DIR" "$AUDIO_DOWNLOAD_DIR" || error "Failed to create download directories!"
}

# === Download Function ===
download_media() {
    log "Starting download..."

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

    # Add extra opts
    ytdl_cmd+=("${EXTRA_OPTS[@]}")

    # Add SponsorBlock support
    if [ -n "$SPONSORBLOCK_REMOVE" ]; then
        ytdl_cmd+=(--sponsorblock-remove "$SPONSORBLOCK_REMOVE")
    fi

    if [ -n "$SPONSORBLOCK_MARK" ]; then
        ytdl_cmd+=(--sponsorblock-mark "$SPONSORBLOCK_MARK")
    fi

    # Add URL
    ytdl_cmd+=("$URL")

    # Run download
    if "${ytdl_cmd[@]}"; then
        success "Download complete!"
    else
        success "Download completed (errors were ignored)."
    fi

    # Rename if requested
    if [ -n "$NEW_NAME" ]; then
        local last_file=$(find "$OUTPUT_DIR" -type f -not -name ".*" -newermt "2 minutes ago" 2>/dev/null | head -n1)
        if [ -n "$last_file" ]; then
            local ext="${last_file##*.}"
            local new_path="$OUTPUT_DIR/$(sanitize "$NEW_NAME").$ext"
            mv "$last_file" "$new_path"
            success "Renamed to: $NEW_NAME.$ext"
        else
            warn "Could not find downloaded file to rename."
        fi
    fi

    # Final message
    ! $QUIET && echo "📁 $OUTPUT_DIR"
}

# === Main ===
main() {
    parse_args "$@"
    download_media
}

main "$@"
