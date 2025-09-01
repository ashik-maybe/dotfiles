#!/bin/bash
#
# ar - A Better Aria2 Script
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
#

# === Config Section ===
# Default configuration values. These can be overridden via CLI flags.
DOWNLOAD_DIR="${XDG_DOWNLOAD_DIR:-$HOME/Downloads}"  # Use XDG or fallback to ~/Downloads
CONCURRENT_DOWNLOADS=16           # Number of connections per file (for speed)
SPLIT_SIZE=16                     # How many chunks to split each file into
MAX_CONN_PER_SERVER=8             # Max connections to a single server
MAX_CONCURRENT_DOWNLOADS=2        # Max number of files downloading at once
QUIET=false                       # Whether to suppress prompts and logs
RESUME=false                      # Whether to resume partial downloads
CUSTOM_DIR=""                     # Custom download directory (from -d flag)
NEW_NAME=""                       # Optional custom output filename (if renaming)

# === Color Definitions ===
# ANSI escape codes for colored terminal output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'  # No Color

# === Logging Functions ===
# Helper functions for consistent, colored output
log() { echo -e "${BLUE}📥$NC $*"; }
success() { echo -e "${GREEN}✅$NC $*"; }
warn() { echo -e "${YELLOW}⚠️$NC $*"; }
error() { echo -e "${RED}❌$NC $*"; }

# === Help Function ===
# Displays usage by extracting comments from the top of the script
show_help() {
    grep "^# " "${BASH_SOURCE[0]}" | sed 's/^# //'
}

# === Number Padding Function ===
# Pads a number with leading zeros to match the width of a template number
# Example: pad_number 5 01 → "05"
# Used to preserve zero-padding in URLs like part[01-03].rar
pad_number() {
    local num=$1
    local fmt=$2
    printf "%0${#fmt}d" "$num"
}

# === URL Expansion Function ===
# Expands bracket notation like file[1-3].zip into multiple URLs
# Supports zero-padded ranges by preserving the format of the start number
# Example:
#   expand_url "file[1-3].zip" → file1.zip file2.zip file3.zip
#   expand_url "file[01-03].zip" → file01.zip file02.zip file03.zip
expand_url() {
    local url="$1"

    # Check if URL contains a bracket range [start-end]
    if [[ "$url" =~ \[([0-9]+)-([0-9]+)\] ]]; then
        local start=${BASH_REMATCH[1]}
        local end=${BASH_REMATCH[2]}

        # Validate range
        if (( start > end )); then
            error "Invalid range: [$start-$end] (start > end)"
            exit 1
        fi

        # Extract prefix (before [) and suffix (after ])
        local prefix="${url%%\[*\]*}"
        local suffix="${url#*\]}"

        # Use start number as template for padding (e.g., "01" → two digits)
        local pad_template="$start"

        # Generate each URL in the range
        for ((i=start; i<=end; i++)); do
            local padded=$(pad_number "$i" "$pad_template")
            echo "${prefix}${padded}${suffix}"
        done
    else
        # No range found → return original URL
        echo "$url"
    fi
}

# === Argument Parser ===
# Parses command-line arguments, validates them, expands URLs, and sets variables
# Also handles interactive input if no URLs are given
parse_args() {
    local URLS_INPUT=()  # Stores raw input URLs before expansion

    # Parse arguments using a while loop and case statement
    while [[ $# -gt 0 ]]; do
        case $1 in
            -d|--dir)
                CUSTOM_DIR="$2"  # Set custom download directory
                shift 2
                ;;
            -r|--resume)
                RESUME=true      # Enable resume mode
                shift
                ;;
            -j|--jobs)
                # Validate job count is a positive integer
                if [[ "$2" =~ ^[0-9]+$ ]] && [ "$2" -ge 1 ]; then
                    MAX_CONCURRENT_DOWNLOADS="$2"
                    shift 2
                else
                    error "Invalid job count: $2"
                    exit 1
                fi
                ;;
            -q|--quiet)
                QUIET=true       # Suppress prompts and extra output
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
                URLS_INPUT+=("$1")  # Collect all non-flag arguments as URLs
                shift
                ;;
        esac
    done

    # If no URLs provided, prompt user interactively
    if [ ${#URLS_INPUT[@]} -eq 0 ]; then
        ! $QUIET && read -p "🔗 Enter URL (supports [N-M]): " input
        [[ -z "$input" ]] && error "No URL provided!" && exit 1
        URLS_INPUT=("$input")
    fi

    # === Extract NEW_NAME ===
    # If the last argument is NOT a URL or bracket pattern, treat it as a custom name
    local last_idx=$((${#URLS_INPUT[@]} - 1))
    local last="${URLS_INPUT[$last_idx]}"

    if [[ "$last" =~ ^https?:// ]] || [[ "$last" == *'['* ]] || [[ "$last" == *']'* ]]; then
        # Last arg is a URL or has brackets → all are URLs
        :
    else
        # Last arg is likely a custom name (e.g., "My Course")
        NEW_NAME="$last"
        unset 'URLS_INPUT[$last_idx]'  # Remove name from URLs list
    fi

    # Re-index array after unset
    URLS_INPUT=("${URLS_INPUT[@]}")

    # === Expand all URLs ===
    # Convert bracket ranges into individual URLs
    URLS=()
    for url in "${URLS_INPUT[@]}"; do
        mapfile -t expanded < <(expand_url "$url")
        URLS+=("${expanded[@]}")
    done

    # === Set Final Download Directory ===
    DOWNLOAD_DIR="${CUSTOM_DIR:-$DOWNLOAD_DIR}"
    mkdir -p "$DOWNLOAD_DIR" || { error "Failed to create directory!"; exit 1; }
}

# === Download Function ===
# Orchestrates the actual download process using aria2c
download_files() {
    local total=${#URLS[@]}
    log "Processing $total download(s)..."
    log "ParallelGroup: $MAX_CONCURRENT_DOWNLOADS"

    # Build aria2c command with default options
    local aria_cmd=(
        aria2c
        -d "$DOWNLOAD_DIR"                          # Download directory
        -x "$CONCURRENT_DOWNLOADS"                 # Max connections per file
        -s "$SPLIT_SIZE"                           # Split file into N parts
        --max-concurrent-downloads="$MAX_CONCURRENT_DOWNLOADS"
        --max-connection-per-server="$MAX_CONN_PER_SERVER"
        --disable-ipv6                             # Avoid IPv6 issues
        --no-netrc                                   # Don't use .netrc
        --user-agent="Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36"
        --check-certificate=true                   # Enforce HTTPS cert check
        --continue="$RESUME"                       # Resume partial downloads
        --auto-file-renaming=false                 # Don't rename on conflict
        --console-log-level=warn                   # Only show warnings/errors
        --summary-interval=5                       # Update progress every 5s
    )

    # Add quiet mode if requested
    $QUIET && aria_cmd+=(--quiet=true)

    # Print URLs being downloaded
    ! $QUIET && echo
    log "Starting downloads:"
    for url in "${URLS[@]}"; do
        echo "🔗 $url"
    done

    # === Cleanup Step: Handle existing files and partials ===
    # Only clean up if NOT resuming (since resuming needs .aria2 control files)
    if ! $RESUME; then
        local urls_to_remove=()  # URLs to skip downloading

        for url in "${URLS[@]}"; do
            # Clean up URL: remove query params and fragments
            local basename_url=$(basename "$url" | cut -d'?' -f1 | cut -d'#' -f1)
            local filepath="$DOWNLOAD_DIR/$basename_url"
            local control_file="$filepath.aria2"

            local should_remove=false

            # Case 1: .aria2 control file exists → partial download → safe to clean
            if [[ -f "$control_file" ]]; then
                warn "Removing partial control file: $basename_url.aria2"
                rm -f "$control_file"
                should_remove=true
            fi

            # Case 2: File exists but is incomplete (zero size or paired with .aria2)
            if [[ -f "$filepath" ]] && ([[ -f "$control_file" ]] || [[ ! -s "$filepath" ]]); then
                warn "Removing incomplete/corrupted file: $basename_url"
                rm -f "$filepath"
                should_remove=true
            fi

            # Case 3: File exists and is complete (no .aria2 file) → prompt user
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

        # Remove skipped URLs from the list
        for url in "${urls_to_remove[@]}"; do
            URLS=("${URLS[@]/$url}")
        done
    fi

    # Exit if no downloads remain
    if [ ${#URLS[@]} -eq 0 ]; then
        warn "No downloads to process."
        exit 0
    fi

    # === Final Download Execution ===
    # Special case: single file with custom name → use -o to rename
    if [ ${#URLS[@]} -eq 1 ] && [ -n "$NEW_NAME" ]; then
        local filename=$(basename "${URLS[0]}" | cut -d'?' -f1 | cut -d'#' -f1)
        local ext="${filename##*.}"  # Extract extension
        local final_name="$NEW_NAME.$ext"
        aria_cmd+=(-o "$final_name")
        echo "📁 $DOWNLOAD_DIR/$final_name"
        "${aria_cmd[@]}" "${URLS[0]}"
    else
        # Batch mode: pass URLs via stdin using -i -
        echo "📁 Batch mode: ${#URLS[@]} file(s)"
        printf '%s\n' "${URLS[@]}" | "${aria_cmd[@]}" -i -
    fi

    # Final status check
    if [ $? -eq 0 ]; then
        success "All downloads completed!"
    else
        error "One or more downloads failed."
        exit 1
    fi
}

# === Main Function ===
# Entry point: initializes variables and runs the workflow
main() {
    # Local arrays to avoid global pollution
    local URLS_INPUT=()
    local URLS=()

    parse_args "$@"     # Parse command-line arguments
    download_files      # Start download process
}

# === Script Entry ===
# Call main with all passed arguments
main "$@"
