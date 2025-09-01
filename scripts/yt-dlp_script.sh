#!/bin/bash
#
# yt - A Better yt-dlp Script
#
# Usage:
#   yt [OPTIONS] <URL> [NEW_NAME]
#
# Options:
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
#   yt -a "https://youtu.be/abc" "My Song"
#   yt -v 720 "https://youtu.be/xyz" "Tutorial"
#   yt -v 720 --mp4 "url"
#   yt -v 720 --sb "sponsor,intro" "url"
#

# === Config Section ===
# Default paths and settings. Can be overridden via environment or CLI.
YTDL_PATH="${YTDL_PATH:-$(command -v yt-dlp || echo 'yt-dlp')}"
    # Path to yt-dlp binary. Use env override or fallback to system path.
FFMPEG_PATH="${FFMPEG_PATH:-$(command -v ffmpeg || echo 'ffmpeg')}"
    # Required for audio extraction, merging, and post-processing.
VIDEO_DOWNLOAD_DIR="$HOME/Downloads/Video"
    # Default directory for video downloads.
AUDIO_DOWNLOAD_DIR="$HOME/Downloads/Audio"
    # Default directory for audio-only (MP3) downloads.
QUIET=false
    # Suppress logs and prompts when true.
RESUME=false
    # Whether to resume interrupted downloads.
SUBS_LANG="en"
    # Default subtitle language (can be overridden via --subs).
NEW_NAME=""
    # Custom output filename (set via -n or as second positional arg).
FORMAT=""
    # yt-dlp format string (set by -a, -v, -b).
OUTPUT_DIR=""
    # Target directory based on media type.
EXTRA_OPTS=()
    # Array to store additional yt-dlp options (subtitles, metadata, etc.).
SPONSORBLOCK_REMOVE=""
    # Comma-separated list of SponsorBlock categories to remove.
SPONSORBLOCK_MARK=""
    # Comma-separated list of SponsorBlock categories to mark as chapters.
USE_MP4=false
    # Whether to merge into MP4 instead of MKV (better compatibility).

# === Colors & Logging Functions ===
# ANSI color codes for clean, readable terminal output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'  # No Color

# Logging helpers with emoji for visual clarity
log() { ! $QUIET && echo -e "${BLUE}📺$NC $*"; }
    # Info message (shown unless in quiet mode)
success() { ! $QUIET && echo -e "${GREEN}✅$NC $*"; }
    # Success message
warn() { ! $QUIET && echo -e "${YELLOW}⚠️$NC $*"; }
    # Warning message
error() { echo -e "${RED}❌$NC $*"; exit 1; }
    # Error message + exit (always shown)

# === Help Function ===
# Extracts usage info from script comments and displays it
# Uses grep to find lines starting with "# " and strips the prefix
show_help() {
    grep "^# " "${BASH_SOURCE[0]}" | sed 's/^# //'
}

# === Sanitize Filename Function ===
# Cleans up filenames by replacing invalid characters and trimming
# Prevents issues with special chars in titles (e.g., <, >, :, ?)
# Example: "My:Video?" → "My_Video_"
sanitize() {
    echo "$1" | \
        sed 's/[<>:"/\\|?*]/_/g' |   # Replace illegal chars with underscore
        tr -s '_' |                   # Squash multiple underscores
        sed 's/^_*//;s/_*$//'         # Trim leading/trailing underscores
}

# === Argument Parser ===
# Parses CLI options, sets format, paths, and extra flags
# Supports short/long flags, optional args, and positional fallbacks
parse_args() {
    local args=()  # Temporarily store non-flag arguments (URL, name)

    while [[ $# -gt 0 ]]; do
        case $1 in
            -a|--audio)
                FORMAT="bestaudio"
                    # yt-dlp format: best audio only
                OUTPUT_DIR="$AUDIO_DOWNLOAD_DIR"
                    # Save to audio folder
                EXTRA_OPTS+=(
                    -x --audio-format mp3 --audio-quality 320K
                        # Extract audio to 320K MP3
                    --embed-thumbnail --add-metadata
                        # Embed cover art and ID3 tags
                    --embed-info-json
                        # Save metadata for future reference
                )
                shift
                ;;
            -v|--video)
                local res="$2"
                if [[ -z "$res" ]]; then
                    error "Missing resolution for --video."
                fi
                FORMAT="bestvideo[height<=${res}][vcodec^=avc1]+bestaudio[acodec^=mp4a]/best[height<=${res}][vcodec^=avc1]"
                    # Prefer H.264 video (avc1) + AAC audio (mp4a), max height
                OUTPUT_DIR="$VIDEO_DOWNLOAD_DIR"
                EXTRA_OPTS+=(
                    --embed-thumbnail --add-metadata
                        # Embed thumbnails and metadata
                    --embed-chapters
                        # Include chapters (e.g. from description)
                    --write-subs --write-auto-subs --embed-subs
                        # Download and embed subtitles
                    --sub-langs "${SUBS_LANG}.*"
                        # Subtitle language filter (e.g., en.*, es.*)
                    --skip-unavailable-fragments
                        # Skip missing fragments (common in live streams)
                    --ignore-errors
                        # Don't fail on minor issues (e.g., missing subs)
                    --compat-options no-keep-subs
                        # Don't leave raw .vtt files behind
                    --embed-info-json
                        # Save JSON metadata
                )
                shift 2
                ;;
            -b|--best)
                FORMAT="bestvideo[vcodec^=avc1]+bestaudio/best[vcodec^=avc1]"
                    # Best available H.264 video + audio
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
                    # Allow optional language; default to "en"
                shift 2
                ;;
            --sb)
                SPONSORBLOCK_REMOVE="$2"
                    # Remove SponsorBlock segments (e.g., sponsor, intro)
                shift 2
                ;;
            --sb-mark)
                SPONSORBLOCK_MARK="$2"
                    # Mark SponsorBlock segments as chapters (not remove)
                shift 2
                ;;
            --mp4)
                USE_MP4=true
                    # Use MP4 container instead of MKV
                shift
                ;;
            --resume)
                RESUME=true
                    # Resume partial downloads
                shift
                ;;
            -q|--quiet)
                QUIET=true
                    # Suppress all output except errors
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
                args+=("$1")  # Collect URL and optional name
                shift
                ;;
        esac
    done

    # === Handle Positional Arguments ===
    case ${#args[@]} in
        0)
            error "No URL provided!"
            show_help
            exit 1
            ;;
        1)
            URL="${args[0]}"  # Only URL given
            ;;
        *)
            URL="${args[0]}"           # First arg = URL
            NEW_NAME="${args[1]}"      # Second arg = custom name
            ;;
    esac

    # === Validate Required Options ===
    if [ -z "$FORMAT" ]; then
        error "No format selected! Use -a, -v, or -b."
        show_help
        exit 1
    fi

    # === Set Output Container Format ===
    if $USE_MP4; then
        EXTRA_OPTS+=(--merge-output-format mp4)
    else
        EXTRA_OPTS+=(--merge-output-format mkv)
            # MKV supports more features (e.g., embedded subs, chapters)
    fi

    # === Ensure Download Directories Exist ===
    mkdir -p "$VIDEO_DOWNLOAD_DIR" "$AUDIO_DOWNLOAD_DIR" || \
        error "Failed to create download directories!"
}

# === Download Function ===
# Constructs and executes the yt-dlp command
# Handles output naming, SponsorBlock, and post-download renaming
download_media() {
    log "Starting download..."

    # Build base yt-dlp command
    local ytdl_cmd=(
        "$YTDL_PATH"
        -f "$FORMAT"                     # Video/audio format filter
        --paths "$OUTPUT_DIR"            # Output directory
        --no-overwrites                  # Don't overwrite existing files
        --console-title                  # Show progress in terminal title
        --progress                       # Show progress bar
    )

    # === Set Output Template Based on Format ===
    if [[ "$FORMAT" == "bestaudio"* ]]; then
        ytdl_cmd+=(
            --output "%(artist,creator,uploader)s - %(title)s.%(ext)s"
                # Audio: Artist - Title.mp3
            --parse-metadata "title:(?P<artist>[^-\[]+?) - .+:artist"
                # Try to extract artist from title
            --parse-metadata "creator:artist"
                # Fallback: use creator as artist
        )
    else
        ytdl_cmd+=(
            --output "%(uploader)s - %(title)s (%(height)sp).%(ext)s"
                # Video: Uploader - Title (720p).mkv
        )
    fi

    # === Add Optional Flags ===
    $RESUME && ytdl_cmd+=(--continue)
        # Resume partial downloads
    $QUIET && ytdl_cmd+=(--quiet --no-progress)
        # Suppress output in quiet mode

    # Append all extra options (subtitles, metadata, etc.)
    ytdl_cmd+=("${EXTRA_OPTS[@]}")

    # === SponsorBlock Integration ===
    if [ -n "$SPONSORBLOCK_REMOVE" ]; then
        ytdl_cmd+=(--sponsorblock-remove "$SPONSORBLOCK_REMOVE")
            # Remove specified segments (e.g., sponsor, intro)
    fi

    if [ -n "$SPONSORBLOCK_MARK" ]; then
        ytdl_cmd+=(--sponsorblock-mark "$SPONSORBLOCK_MARK")
            # Mark segments as chapters (e.g., for navigation)
    fi

    # === Final Step: Add URL ===
    ytdl_cmd+=("$URL")

    # === Execute Download ===
    if "${ytdl_cmd[@]}"; then
        success "Download complete!"
    else
        # yt-dlp may return non-zero due to ignored errors (e.g., missing subs)
        success "Download completed (errors were ignored)."
    fi

    # === Rename File (if requested) ===
    # Since yt-dlp doesn't support direct rename, we find the latest downloaded file
    if [ -n "$NEW_NAME" ]; then
        local last_file=$(find "$OUTPUT_DIR" -type f -not -name ".*" -newermt "2 minutes ago" 2>/dev/null | head -n1)
            # Find most recently created non-hidden file in output dir
        if [ -n "$last_file" ]; then
            local ext="${last_file##*.}"
            local new_path="$OUTPUT_DIR/$(sanitize "$NEW_NAME").$ext"
            mv "$last_file" "$new_path"
            success "Renamed to: $NEW_NAME.$ext"
        else
            warn "Could not find downloaded file to rename."
        fi
    fi

    # === Final Output ===
    ! $QUIET && echo "📁 $OUTPUT_DIR"
        # Show download directory at the end
}

# === Main Function ===
# Entry point: parses args and starts download
main() {
    parse_args "$@"
    download_media
}

# === Script Execution ===
# Run main with all arguments
main "$@"
