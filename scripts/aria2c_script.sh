#!/bin/bash
#
# ar - Smart Aria2 Downloader
#
# Usage:
#   ar [OPTIONS] <URL...> [NEW_NAME]
#
# Bracket Syntax:
#   http://site/file[1-3].zip        → file1.zip, file2.zip, file3.zip
#   http://site/part[01-03].rar      → part01.rar, part02.rar, part03.rar
#
# Options:
#   -d, --dir DIR       Set download directory
#   -r, --resume        Resume partial downloads
#   -j, --jobs N        Max concurrent downloads (default: 2)
#   -q, --quiet         Quiet mode
#   -h, --help          Show help
#
# Examples:
#   ar --jobs 1 "file[1-5].zip"
#   ar -j 3 -d ~/Pics "img[1-10].jpg"
#   ar "part[1-3].rar" "My Course"

# === Config ===
DOWNLOAD_DIR="${XDG_DOWNLOAD_DIR:-$HOME/Downloads}"
CONCURRENT_DOWNLOADS=16           # per-file connections
SPLIT_SIZE=16                     # per-file split
MAX_CONN_PER_SERVER=8             # per-server limit
MAX_CONCURRENT_DOWNLOADS=2        # total files downloading at once
QUIET=false
RESUME=false
CUSTOM_DIR=""
NEW_NAME=""

# === Colors ===
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log() { echo -e "${BLUE}📥$NC $*"; }
success() { echo -e "${GREEN}✅$NC $*"; }
warn() { echo -e "${YELLOW}⚠️$NC $*"; }
error() { echo -e "${RED}❌$NC $*"; }

# === Help ===
show_help() {
    grep "^# " "${BASH_SOURCE[0]}" | sed 's/^# //'
}

# === Pad number with correct width ===
pad_number() {
    local num=$1
    local fmt=$2
    printf "%0${#fmt}d" "$num"
}

# === Expand [A-B] in URL ===
expand_url() {
    local url="$1"
    if [[ "$url" =~ \[([0-9]+)-([0-9]+)\] ]]; then
        local start=${BASH_REMATCH[1]}
        local end=${BASH_REMATCH[2]}

        if (( start > end )); then
            error "Invalid range: [$start-$end] (start > end)"
            exit 1
        fi

        local prefix="${url%%\[*\]*}"
        local suffix="${url#*\]}"
        local pad_template="$start"

        for ((i=start; i<=end; i++)); do
            local padded=$(pad_number "$i" "$pad_template")
            echo "${prefix}${padded}${suffix}"
        done
    else
        echo "$url"
    fi
}

# === Parse Args ===
parse_args() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            -d|--dir)
                CUSTOM_DIR="$2"
                shift 2
                ;;
            -r|--resume)
                RESUME=true
                shift
                ;;
            -j|--jobs)
                if [[ "$2" =~ ^[0-9]+$ ]] && [ "$2" -ge 1 ]; then
                    MAX_CONCURRENT_DOWNLOADS="$2"
                    shift 2
                else
                    error "Invalid job count: $2"
                    exit 1
                fi
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
                URLS_INPUT+=("$1")
                shift
                ;;
        esac
    done

    # Prompt if no URLs
    if [ ${#URLS_INPUT[@]} -eq 0 ]; then
        ! $QUIET && read -p "🔗 Enter URL (supports [N-M]): " input
        [[ -z "$input" ]] && error "No URL provided!" && exit 1
        URLS_INPUT=("$input")
    fi

    # Extract NEW_NAME if last arg isn't a URL
    local last_idx=$((${#URLS_INPUT[@]} - 1))
    local last="${URLS_INPUT[$last_idx]}"

    if [[ "$last" =~ ^https?:// ]] || [[ "$last" == *'['* ]] || [[ "$last" == *']'* ]]; then
        # All are URLs
        :
    else
        # Last is a custom name
        NEW_NAME="$last"
        unset 'URLS_INPUT[$last_idx]'
        URLS_INPUT=("${URLS_INPUT[@]}") # Re-index
    fi

    # Expand all URLs
    URLS=()
    for url in "${URLS_INPUT[@]}"; do
        mapfile -t expanded < <(expand_url "$url")
        URLS+=("${expanded[@]}")
    done

    # Set download directory
    DOWNLOAD_DIR="${CUSTOM_DIR:-$DOWNLOAD_DIR}"
    mkdir -p "$DOWNLOAD_DIR" || { error "Failed to create directory!"; exit 1; }
}

# === Download Function ===
download_files() {
    local total=${#URLS[@]}
    log "Processing $total download(s)..."
    log "ParallelGroup: $MAX_CONCURRENT_DOWNLOADS"

    local aria_cmd=(
        aria2c
        -d "$DOWNLOAD_DIR"
        -x "$CONCURRENT_DOWNLOADS"
        -s "$SPLIT_SIZE"
        --max-concurrent-downloads="$MAX_CONCURRENT_DOWNLOADS"
        --max-connection-per-server="$MAX_CONN_PER_SERVER"
        --disable-ipv6
        --no-netrc
        --user-agent="Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36"
        --check-certificate=true
        --continue="$RESUME"
        --auto-file-renaming=false
        --console-log-level=warn
        --summary-interval=5
    )

    $QUIET && aria_cmd+=(--quiet=true)

    ! $QUIET && echo
    log "Starting downloads:"
    for url in "${URLS[@]}"; do
        echo "🔗 $url"
    done

    # If single URL and NEW_NAME, use -o
    if [ ${#URLS[@]} -eq 1 ] && [ -n "$NEW_NAME" ]; then
        local filename=$(basename "${URLS[0]}" | cut -d'?' -f1 | cut -d'#' -f1)
        local ext="${filename##*.}"
        local final_name="$NEW_NAME.$ext"
        aria_cmd+=(-o "$final_name")
        echo "📁 $DOWNLOAD_DIR/$final_name"
        "${aria_cmd[@]}" "${URLS[0]}"
    else
        # Batch mode
        echo "📁 Batch mode: ${#URLS[@]} file(s)"
        printf '%s\n' "${URLS[@]}" | "${aria_cmd[@]}" -i -
    fi

    if [ $? -eq 0 ]; then
        success "All downloads completed!"
    else
        error "One or more downloads failed."
        exit 1
    fi
}

# === Main ===
main() {
    local URLS_INPUT=()
    local URLS=()
    parse_args "$@"
    download_files
}

main "$@"
