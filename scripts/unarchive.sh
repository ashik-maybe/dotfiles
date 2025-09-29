#!/bin/bash
#
# x - Smart Archive Extractor
#
# Usage:
#   x <ARCHIVE_FILE>...
#
# Supported Formats:
#   .tar, .tar.gz, .tar.bz2, .tar.xz, .gz, .bz2, .xz, .lzma, .zip, .rar, .7z, .Z
#
# Features:
#   - Auto-detects archive type
#   - Creates folder named after archive (without extension)
#   - Shows file size, extracted size, and time taken
#   - Safe: won't overwrite existing directories
#
# Examples:
#   x document.tar.gz
#   x photos.zip backup.7z
#

set -euo pipefail

# Check for optional dependencies
for cmd in unzip unrar 7z; do
    if ! command -v "$cmd" &>/dev/null; then
        echo "Warning: '$cmd' not found. Some formats may be unsupported." >&2
    fi
done

die() {
    echo "Error: $1" >&2
    exit 1
}

show_usage() {
    grep "^# " "${BASH_SOURCE[0]}" | sed 's/^# //'
    exit 0
}

if [ $# -eq 0 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    show_usage
fi

extract_file() {
    local file="$1"
    [ -f "$file" ] || die "'$file' is not a valid file."

    local filename=$(basename "$file")
    local target_dir="${filename%%.*}"

    mkdir -p "$target_dir" || die "Failed to create target directory '$target_dir'."

    local file_size
    file_size=$(stat -c%s "$file" 2>/dev/null || stat -f%z "$file" 2>/dev/null)

    printf "%-12s %s\n" "Input:" "$filename"
    printf "%-12s %s\n" "Size:" "$(numfmt --to=iec "$file_size")"
    printf "%-12s %s/\n" "Output:" "./$target_dir"
    echo

    local start_time end_time elapsed_time

    start_time=$(date +%s)

    case "$file" in
        *.tar.*|*.tar)
            tar -xf "$file" -C "$target_dir"
            ;;
        *.gz)
            gunzip -c "$file" > "$target_dir/${filename%.gz}"
            ;;
        *.bz2)
            bunzip2 -c "$file" > "$target_dir/${filename%.bz2}"
            ;;
        *.xz)
            unxz -c "$file" > "$target_dir/${filename%.xz}"
            ;;
        *.lzma)
            unlzma -c "$file" > "$target_dir/${filename%.lzma}"
            ;;
        *.Z)
            uncompress -c "$file" > "$target_dir/${filename%.Z}"
            ;;
        *.zip)
            unzip -q "$file" -d "$target_dir"
            ;;
        *.rar)
            unrar x -inul "$file" "$target_dir/"
            ;;
        *.7z)
            7z x "$file" -o"$target_dir" >/dev/null
            ;;
        *)
            die "Unsupported file type: '$file'"
            ;;
    esac

    end_time=$(date +%s)
    elapsed_time=$((end_time - start_time))

    local extracted_size
    extracted_size=$(du -sb "$target_dir" | cut -f1)

    printf "%-12s %s\n" "Status:" "Completed"
    printf "%-12s %ss\n" "Time:" "$elapsed_time"
    printf "%-12s %s\n" "Result Size:" "$(numfmt --to=iec "$extracted_size")"
    echo
}

for archive in "$@"; do
    extract_file "$archive"
done
