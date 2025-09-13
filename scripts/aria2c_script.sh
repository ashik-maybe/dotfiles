#!/bin/bash
#
# ar - A Better Aria2 Script
#
# Usage:
#   ar [OPTIONS] <URL...> [NEW_NAME]
#   ar -f FILE [OPTIONS] [NEW_NAME]
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
#   -f, --file FILE     Read URLs from file (one per line)
#   -h, --help          Show help
#
# Examples:
#   ar --jobs 1 "file[1-5].zip"
#   ar -j 3 -d ~/Pics "img[1-10].jpg"
#   ar "part[1-3].rar" "My Course"
#   ar -f urls.txt -d ~/Downloads
#   ar -f list.txt "My Collection"

# === Config Section ===
DOWNLOAD_DIR="${XDG_DOWNLOAD_DIR:-$HOME/Downloads}"
CONCURRENT_DOWNLOADS=16
SPLIT_SIZE=16
MAX_CONN_PER_SERVER=8
MAX_CONCURRENT_DOWNLOADS=2
QUIET=false
RESUME=false
CUSTOM_DIR=""
NEW_NAME=""
FILE_INPUT=""

# === Color Definitions ===
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# === Logging Functions ===
log() { echo -e "${BLUE}📥$NC $*"; }
success() { echo -e "${GREEN}✅$NC $*"; }
warn() { echo -e "${YELLOW}⚠️$NC $*"; }
error() { echo -e "${RED}❌$NC $*"; }

# === Help Function ===
show_help() {
    grep "^# " "${BASH_SOURCE[0]}" | sed 's/^# //'
}

# === Number Padding Function ===
pad_number() {
    local num=$1
    local fmt=$2
    printf "%0${#fmt}d" "$num"
}

# === URL Expansion Function ===
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

# === Argument Parser ===
parse_args() {
    local URLS_INPUT=()
    local INPUT_FILE=""

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
            -f|--file)
                if [[ -f "$2" ]] && [[ -r "$2" ]]; then
                    FILE_INPUT="$2"
                    mapfile -t file_urls < "$2"
                    URLS_INPUT+=("${file_urls[@]}")
                    shift 2
                else
                    error "File not found or unreadable: $2"
                    exit 1
                fi
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

    # If no URLs provided, prompt interactively
    if [ ${#URLS_INPUT[@]} -eq 0 ] && [ -z "$FILE_INPUT" ]; then
        ! $QUIET && read -p "🔗 Enter URL (supports [N-M]) or type 'quit' to exit: " input
        [[ -z "$input" || "$input" == "quit" ]] && error "No URL provided!" && exit 1
        URLS_INPUT=("$input")
    fi

    # === Extract NEW_NAME ===
    local last_idx=$((${#URLS_INPUT[@]} - 1))
    local last="${URLS_INPUT[$last_idx]}"

    # If last arg is NOT a URL or bracket pattern → treat as custom name
    if [[ ! "$last" =~ ^https?:// ]] && [[ ! "$last" == *'['* ]] && [[ ! "$last" == *']'* ]]; then
        NEW_NAME="$last"
        unset 'URLS_INPUT[$last_idx]'
    fi

    # Re-index array
    URLS_INPUT=("${URLS_INPUT[@]}")

    # === Expand all URLs ===
    URLS=()
    for url in "${URLS_INPUT[@]}"; do
        # Skip empty lines
        [[ -z "$url" ]] && continue
        mapfile -t expanded < <(expand_url "$url")
        URLS+=("${expanded[@]}")
    done

    # === Set Final Download Directory ===
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

    # === Cleanup Step: Handle existing files and partials ===
    if ! $RESUME; then
        local urls_to_remove=()

        for url in "${URLS[@]}"; do
            local basename_url=$(basename "$url" | cut -d'?' -f1 | cut -d'#' -f1)
            local filepath="$DOWNLOAD_DIR/$basename_url"
            local control_file="$filepath.aria2"

            local should_remove=false

            if [[ -f "$control_file" ]]; then
                warn "Removing partial control file: $basename_url.aria2"
                rm -f "$control_file"
                should_remove=true
            fi

            if [[ -f "$filepath" ]] && ([[ -f "$control_file" ]] || [[ ! -s "$filepath" ]]); then
                warn "Removing incomplete/corrupted file: $basename_url"
                rm -f "$filepath"
                should_remove=true
            fi

            if [[ -f "$filepath" ]] && [[ ! -f "$control_file" ]]; then
                warn "Completed file already exists: $basename_url"
                if $QUIET; then
                    log "Skipping (quiet mode): $basename_url"
                    urls_to_remove+=("$url")
                else
                    read -p "🔁 Overwrite '$basename_url'? [y/N] " -n1 -r
                    echo
                    if [[ "$REPLY" =~ ^[Yy]$ ]]; then
                        rm -f "$filepath"
                        success "Overwritten: $basename_url"
                    else
                        log "Skipping download: $basename_url"
                        urls_to_remove+=("$url")
                    fi
                fi
            fi
        done

        for url in "${urls_to_remove[@]}"; do
            URLS=("${URLS[@]/$url}")
        done
    fi

    if [ ${#URLS[@]} -eq 0 ]; then
        warn "No downloads to process."
        exit 0
    fi

    # === Final Download Execution ===
    if [ ${#URLS[@]} -eq 1 ] && [ -n "$NEW_NAME" ]; then
        local filename=$(basename "${URLS[0]}" | cut -d'?' -f1 | cut -d'#' -f1)
        local ext="${filename##*.}"
        local final_name="$NEW_NAME.$ext"
        aria_cmd+=(-o "$final_name")
        echo "📁 $DOWNLOAD_DIR/$final_name"
        "${aria_cmd[@]}" "${URLS[0]}"
    else
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

# === Main Function ===
main() {
    local URLS_INPUT=()
    local URLS=()

    parse_args "$@"
    download_files
}

# === Script Entry ===
main "$@"
