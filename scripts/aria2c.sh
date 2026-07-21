#!/usr/bin/env bash
#
# ar - Aria2 wrapper for downloading files
#
# Usage: ar [options] <URL...> [output_name]
# Options:
#   -d, --dir DIR     Custom download directory
#   -r, --resume      Resume partial downloads
#   -j, --jobs N      Max concurrent downloads (default: 2)
#   -f, --file FILE   Read URLs from line-separated file
#   -h, --help        Show help
#

set -euo pipefail

readonly ARIA2C="${ARIA2C:-$(command -v aria2c || echo 'aria2c')}"
readonly DEFAULT_DIR="${XDG_DOWNLOAD_DIR:-$HOME/Downloads}"

readonly CONCURRENT_DOWNLOADS=16
readonly SPLIT_SIZE=16
readonly MAX_CONN_PER_SERVER=8

# Terminal Colors
readonly CYAN='\033[0;36m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly RED='\033[0;31m'
readonly DIM='\033[2m'
readonly NC='\033[0m'

# Configurable Options
RESUME=false
NEW_NAME=""
CUSTOM_DIR=""
MAX_CONCURRENT=2
URLS=()

log() { printf '%b\n' "${CYAN}Downloading:${NC} $*"; }
success() { printf '%b\n' "${GREEN}Done:${NC} $*"; }
warn() { printf '%b\n' "${YELLOW}Warning:${NC} $*"; }
error() { printf '%b\n' "${RED}Error:${NC} $*" >&2; exit 1; }
saved() { printf '%b\n' "${DIM}Saved to:${NC} $*"; }

show_help() {
    grep "^#" "${BASH_SOURCE[0]}" | sed 's/^# //;s/^#//'
}

expand_url() {
    local url="$1"

    if [[ "$url" =~ \[([0-9]+)-([0-9]+)\] ]]; then
        local raw_start="${BASH_REMATCH[1]}"
        local raw_end="${BASH_REMATCH[2]}"
        local start=$((10#$raw_start))
        local end=$((10#$raw_end))

        if ((start > end)); then
            error "Invalid range: [$raw_start-$raw_end] (start > end)"
        fi

        local prefix="${url%%\[*\]*}"
        local suffix="${url#*\]}"
        local width="${#raw_start}"
        local i

        for ((i=start; i<=end; i++)); do
            printf "%s%0*d%s\n" "$prefix" "$width" "$i" "$suffix"
        done
    else
        echo "$url"
    fi
}

parse_args() {
    local urls_input=()
    local input_file=""
    local res=""

    while [[ $# -gt 0 ]]; do
        case "$1" in
            -d|--dir)
                CUSTOM_DIR="$2"
                shift 2
                ;;
            -r|--resume)
                RESUME=true
                shift
                ;;
            -j|--jobs)
                res="${2:-}"
                if [[ -z "$res" ]] || [[ ! "$res" =~ ^[0-9]+$ ]]; then
                    error "Invalid job count: ${2:-empty}"
                fi
                MAX_CONCURRENT="$res"
                shift 2
                ;;
            -f|--file)
                if [[ -f "$2" ]] && [[ -r "$2" ]]; then
                    input_file="$2"
                    mapfile -t file_urls < "$2"
                    urls_input+=("${file_urls[@]}")
                    shift 2
                else
                    error "File not found or unreadable: $2"
                fi
                ;;
            -h|--help)
                show_help
                exit 0
                ;;
            -*)
                error "Unknown option: $1"
                ;;
            *)
                urls_input+=("$1")
                shift
                ;;
        esac
    done

    if [[ ${#urls_input[@]} -eq 0 ]] && [[ -z "$input_file" ]]; then
        read -r -p "Enter URL (supports [N-M]) or 'quit' to exit: " input
        [[ -z "$input" || "$input" == "quit" ]] && error "No URL provided!"
        urls_input=("$input")
    fi

    # Detect if the last argument is a custom output filename (if it's not a URL/Range)
    local last_idx=$((${#urls_input[@]} - 1))
    local last="${urls_input[$last_idx]}"

    if [[ ! "$last" =~ ^https?:// ]] && [[ ! "$last" =~ ^ftp:// ]] && [[ ! "$last" == *'['* ]] && [[ ! "$last" == *']'* ]]; then
        NEW_NAME="$last"
        unset 'urls_input[last_idx]'
    fi

    URLS=()
    local url=""
    local expanded=()
    for url in "${urls_input[@]}"; do
        [[ -z "$url" ]] && continue
        mapfile -t expanded < <(expand_url "$url")
        URLS+=("${expanded[@]}")
    done

    DOWNLOAD_DIR="${CUSTOM_DIR:-$DEFAULT_DIR}"
    mkdir -p "$DOWNLOAD_DIR" || error "Failed to create directory!"
}

download_files() {
    local total="${#URLS[@]}"
    local aria_cmd=()
    local filtered_urls=()
    local url=""
    local basename_url=""
    local filepath=""
    local control_file=""
    local filename=""
    local ext=""
    local final_name=""

    log "Processing $total download(s)..."

    aria_cmd=("$ARIA2C"
        -d "$DOWNLOAD_DIR"
        -x "$CONCURRENT_DOWNLOADS"
        -s "$SPLIT_SIZE"
        --max-concurrent-downloads="$MAX_CONCURRENT"
        --max-connection-per-server="$MAX_CONN_PER_SERVER"
        --disable-ipv6
        --no-netrc
        --user-agent="Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36"
        --check-certificate=true
        --continue="$RESUME"
        --auto-file-renaming=false
        --console-log-level=warn
        --summary-interval=5)

    if ! "$RESUME"; then
        for url in "${URLS[@]}"; do
            basename_url=$(basename "$url" | cut -d'?' -f1 | cut -d'#' -f1)
            filepath="$DOWNLOAD_DIR/$basename_url"
            control_file="$filepath.aria2"

            if [[ -f "$control_file" ]]; then
                warn "Removing partial control file: $basename_url.aria2"
                rm -f "$control_file"
            fi

            if [[ -f "$filepath" ]]; then
                warn "File already exists: $basename_url"
                read -r -p "Overwrite '$basename_url'? [y/N] " -n1 reply
                echo
                if [[ "$reply" =~ ^[Yy]$ ]]; then
                    rm -f "$filepath"
                    success "Overwritten: $basename_url"
                    filtered_urls+=("$url")
                else
                    log "Skipped: $basename_url"
                fi
            else
                filtered_urls+=("$url")
            fi
        done
        URLS=("${filtered_urls[@]}")
    fi

    if [[ ${#URLS[@]} -eq 0 ]]; then
        warn "No downloads to process."
        exit 0
    fi

    local status=0
    if [[ ${#URLS[@]} -eq 1 ]] && [[ -n "$NEW_NAME" ]]; then
        filename=$(basename "${URLS[0]}" | cut -d'?' -f1 | cut -d'#' -f1)
        ext="${filename##*.}"

        # Append extension if NEW_NAME doesn't already have one
        if [[ "$NEW_NAME" == *"."* ]]; then
            final_name="$NEW_NAME"
        else
            final_name="$NEW_NAME.$ext"
        fi

        aria_cmd+=(-o "$final_name")
        log "Saving as: $final_name"

        "${aria_cmd[@]}" "${URLS[0]}" || status=$?
    else
        log "Batch mode: ${#URLS[@]} file(s)"
        printf '%s\n' "${URLS[@]}" | "${aria_cmd[@]}" -i - || status=$?
    fi

    if [[ $status -eq 0 ]]; then
        success "All downloads completed!"
        saved "$DOWNLOAD_DIR"
    else
        error "One or more downloads failed (exit code: $status)."
    fi
}

main() {
    parse_args "$@"
    download_files
}

main "$@"
