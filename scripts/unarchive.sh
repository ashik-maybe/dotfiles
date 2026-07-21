#!/usr/bin/env bash
#
# x - Extract archives (Optimized for Multi-threading)
#
# Usage: x <archive...>
#

set -euo pipefail

readonly CYAN='\033[0;36m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly RED='\033[0;31m'
readonly NC='\033[0m'

log() { printf '%b%-10s %s%b\n' "${CYAN}" "$1" "$2" "${NC}"; }
result() { printf '%b%-10s %s%b\n' "${GREEN}" "$1" "$2" "${NC}"; }
error() { printf '%bError: %s%b\n' "${RED}" "$1" "${NC}" >&2; exit 1; }

show_help() {
    grep "^#" "${BASH_SOURCE[0]}" | sed 's/^# //;s/^#//'
    exit 0
}

if [[ $# -eq 0 ]] || [[ "${1:-}" == "-h" ]] || [[ "${1:-}" == "--help" ]]; then
    show_help
fi

# Cleanly strip archive extension (handles multi-dot extensions correctly)
get_target_name() {
    local file="$1"
    local name
    name=$(basename "$file")

    case "$name" in
        *.tar.gz|*.tar.xz|*.tar.bz2|*.tar.zst|*.tgz|*.txz)
            echo "${name%.tar.*}"
            ;;
        *.*)
            echo "${name%.*}"
            ;;
        *)
            echo "$name"
            ;;
    esac
}

extract_file() {
    local file="$1"
    local filename target_dir file_size
    local start_time end_time elapsed_time extracted_size

    [[ -f "$file" ]] || error "'$file' is not a valid file."

    filename=$(basename "$file")
    target_dir=$(get_target_name "$filename")

    file_size=$(stat -c%s "$file" 2>/dev/null || stat -f%z "$file" 2>/dev/null || echo "0")

    log "Input:" "$filename"
    log "Size:" "$(numfmt --to=iec "$file_size")"
    log "Output:" "./$target_dir/"

    mkdir -p "$target_dir" || error "Failed to create target directory '$target_dir'."

    start_time=$(date +%s)

    case "$file" in
        *.tar.gz|*.tgz)
            if command -v pigz &>/dev/null; then
                tar -I pigz -xf "$file" -C "$target_dir"
            else
                tar -xzf "$file" -C "$target_dir"
            fi
            ;;
        *.tar.zst|*.tzst)
            tar -I "zstd -T0" -xf "$file" -C "$target_dir"
            ;;
        *.tar.xz|*.txz)
            if command -v pxz &>/dev/null; then
                tar -I pxz -xf "$file" -C "$target_dir"
            else
                tar -I "xz -T0" -xf "$file" -C "$target_dir"
            fi
            ;;
        *.tar.bz2|*.tbz2)
            if command -v pbzip2 &>/dev/null; then
                tar -I pbzip2 -xf "$file" -C "$target_dir"
            else
                tar -xjf "$file" -C "$target_dir"
            fi
            ;;
        *.tar)
            tar -xf "$file" -C "$target_dir"
            ;;
        *.zst)
            zstd -d -T0 "$file" -o "$target_dir/${filename%.zst}"
            ;;
        *.gz)
            if command -v pigz &>/dev/null; then
                pigz -dc "$file" > "$target_dir/${filename%.gz}"
            else
                gunzip -c "$file" > "$target_dir/${filename%.gz}"
            fi
            ;;
        *.xz)
            xz -T0 -dc "$file" > "$target_dir/${filename%.xz}"
            ;;
        *.zip)
            command -v unzip &>/dev/null || error "'unzip' is required to extract .zip files."
            unzip -q "$file" -d "$target_dir"
            ;;
        *.rar)
            command -v unrar &>/dev/null || error "'unrar' is required to extract .rar files."
            unrar x -inul "$file" "$target_dir/"
            ;;
        *.7z)
            command -v 7z &>/dev/null || error "'7z' is required to extract .7z files."
            7z x "$file" -o"$target_dir" >/dev/null
            ;;
        *)
            error "Unsupported file type: '$file'"
            ;;
    esac

    end_time=$(date +%s)
    elapsed_time=$((end_time - start_time))
    extracted_size=$(du -sb "$target_dir" 2>/dev/null | cut -f1 || echo "0")

    result "Result:" "$(numfmt --to=iec "$extracted_size") extracted"
    result "Time:" "${elapsed_time}s"
    result "Done:" "Completed"
    echo
}

for archive in "$@"; do
    extract_file "$archive"
done
