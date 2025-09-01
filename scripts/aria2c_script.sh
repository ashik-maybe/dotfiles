#!/bin/bash
#
# ar - Smart Aria2 Downloader + Auto-Organizer
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
#   -q, --quiet         Quiet mode (no prompts, no organize)
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
    local URLS_INPUT=()
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
    fi
    # Re-index array
    URLS_INPUT=("${URLS_INPUT[@]}")

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

# === Organize Downloads by Type ===
organize_downloads() {
    local moved=0
    local skipped=0

    for filepath in "$DOWNLOAD_DIR"/*; do
        [[ -f "$filepath" ]] || continue

        local filename=$(basename "$filepath")
        local ext="${filename##*.}"
        local moved_flag=false

        # Convert extension to lowercase
        ext=$(echo "$ext" | tr '[:upper:]' '[:lower:]')

        case "$ext" in
            # Video
            mp4|mkv|avi|mov|wmv|flv|webm|m4v)
                dest_dir="${XDG_VIDEOS_DIR:-$HOME/Video}"
                mkdir -p "$dest_dir" && mv -n "$filepath" "$dest_dir/" && moved_flag=true
                ;;

            # Audio
            mp3|flac|wav|ogg|aac|m4a|wma)
                dest_dir="${XDG_MUSIC_DIR:-$HOME/Audio}"
                mkdir -p "$dest_dir" && mv -n "$filepath" "$dest_dir/" && moved_flag=true
                ;;

            # Images
            jpg|jpeg|png|gif|bmp|webp|svg|tiff)
                dest_dir="${XDG_PICTURES_DIR:-$HOME/Images}"
                mkdir -p "$dest_dir" && mv -n "$filepath" "$dest_dir/" && moved_flag=true
                ;;

            # Documents
            pdf|doc|docx|txt|rtf|odt|epub|mobi|djvu|ppt|pptx)
                dest_dir="${XDG_DOCUMENTS_DIR:-$HOME/Documents}"
                mkdir -p "$dest_dir" && mv -n "$filepath" "$dest_dir/" && moved_flag=true
                ;;

            # Archives / ISOs
            zip|rar|7z|tar|gz|bz2|xz|iso|dmg|tgz|tar.gz|tar.xz|tar.bz2)
                dest_dir="${XDG_DOWNLOAD_DIR:-$HOME/Archives}"
                mkdir -p "$dest_dir" && mv -n "$filepath" "$dest_dir/" && moved_flag=true
                ;;
            *)
                ((skipped++))
                continue
                ;;
        esac

        if $moved_flag; then
            success "Moved: $filename → ${dest_dir##*/}/"
            ((moved++))
        else
            warn "Already exists: $filename in ${dest_dir##*/}/ (skipped)"
        fi
    done

    if [ $moved -gt 0 ]; then
        log "Organized $moved file(s) into category folders."
    fi
    if [ $skipped -gt 0 ] && ! $QUIET; then
        warn "Skipped $skipped file(s) — unknown or already exist."
    fi
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

    # === Cleanup: Only remove partials if NOT resuming ===
    if ! $RESUME; then
        local urls_to_remove=()
        for url in "${URLS[@]}"; do
            local basename_url=$(basename "$url" | cut -d'?' -f1 | cut -d'#' -f1)
            local filepath="$DOWNLOAD_DIR/$basename_url"
            local control_file="$filepath.aria2"

            # Case 1: .aria2 control file exists → partial download → clean
            if [[ -f "$control_file" ]]; then
                warn "Removing partial control file: $basename_url.aria2"
                rm -f "$control_file"
            fi

            # Case 2: file exists but control file or zero size → incomplete
            if [[ -f "$filepath" ]] && ([[ -f "$control_file" ]] || [[ ! -s "$filepath" ]]); then
                warn "Removing incomplete/corrupted file: $basename_url"
                rm -f "$filepath"
            fi

            # Case 3: complete file exists
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

        # Remove skipped URLs
        for url in "${urls_to_remove[@]}"; do
            URLS=("${URLS[@]/$url}")
        done
    fi

    # Exit if no URLs left
    if [ ${#URLS[@]} -eq 0 ]; then
        warn "No downloads to process."
        exit 0
    fi

    # Build aria2 command
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

    # === After download: Show size + organize ===
    if [ $? -eq 0 ]; then
        success "All downloads completed!"

        # === Calculate total downloaded size (no bc, no floating point) ===
        local total_bytes=0
        local downloaded_files=()

        # Reconstruct file paths
        if [ ${#URLS[@]} -eq 1 ] && [ -n "$NEW_NAME" ]; then
            local filename=$(basename "${URLS[0]}" | cut -d'?' -f1 | cut -d'#' -f1)
            local ext="${filename##*.}"
            local final_name="$NEW_NAME.$ext"
            downloaded_files+=("$DOWNLOAD_DIR/$final_name")
        else
            for url in "${URLS[@]}"; do
                local filename=$(basename "$url" | cut -d'?' -f1 | cut -d'#' -f1)
                downloaded_files+=("$DOWNLOAD_DIR/$filename")
            done
        fi

        # Sum sizes
        for file in "${downloaded_files[@]}"; do
            [[ -f "$file" ]] || continue
            local size
            size=$(stat -c %s "$file" 2>/dev/null) || continue
            ((total_bytes += size))
        done

        # Format size (B → KB → MB → GB) with integer math
        if [ $total_bytes -lt 1024 ]; then
            log "Total downloaded: ${total_bytes} B"
        elif [ $total_bytes -lt 1048576 ]; then
            log "Total downloaded: $(( (total_bytes + 1023) / 1024 )) KB"
        elif [ $total_bytes -lt 1073741824 ]; then
            log "Total downloaded: $(( (total_bytes + 1048575) / 1048576 )) MB"
        else
            log "Total downloaded: $(( (total_bytes + 1073741823) / 1073741824 )) GB"
        fi

        # Organize unless quiet
        if ! $QUIET; then
            log "Organizing files by type..."
            organize_downloads
        fi
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
