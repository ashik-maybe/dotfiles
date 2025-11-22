#!/usr/bin/env bash
#
# k - Ultra Compression Tool (zstd or zip)
#
# Usage:
#   k [OPTIONS] <FOLDER>...
#
# Options:
#   -o FILE     Set output filename (default: <foldername>.tar.zst or .zip)
#   -f          Force overwrite if output exists
#   -z          Use ZIP instead of zstd (faster, less compression)
#
# Features:
#   - Uses zstd ultra -22 for maximum compression by default
#   - Optional ZIP mode for compatibility
#   - Shows size savings and compression ratio
#   - Safe: won't overwrite unless -f is used
#
# Examples:
#   k MyProject/
#   k -z -o backup.zip Documents/
#   k -f -o final.tar.zst GameAssets/
#

set -euo pipefail

OUTFILE=""
FORCE=0
USE_ZIP=0

if [[ "${1:-}" == "--help" ]] || [[ "${1:-}" == "-h" ]]; then
    grep "^# " "${BASH_SOURCE[0]}" | sed 's/^# //'
    exit 0
fi

while getopts ":o:fz" opt; do
  case "$opt" in
    o) OUTFILE="$OPTARG" ;;
    f) FORCE=1 ;;
    z) USE_ZIP=1 ;;
    *)
      echo "Error: Invalid option -$OPTARG" >&2
      echo "Run '$0 --help' for usage." >&2
      exit 1
      ;;
  esac
done
shift $((OPTIND - 1))

if [ $# -eq 0 ]; then
    echo "Error: No folder specified." >&2
    exit 1
fi

compress_folder() {
    local FOLDER="$1"
    [ ! -d "$FOLDER" ] && echo "Error: '$FOLDER' is not a directory." >&2 && return 1

    local NAME ARCHIVE

    NAME="$(basename "$FOLDER")"

    if [ "$USE_ZIP" -eq 1 ]; then
        ARCHIVE="${OUTFILE:-$NAME.zip}"
        [ -f "$ARCHIVE" ] && [ "$FORCE" -ne 1 ] && echo "Error: '$ARCHIVE' exists. Use -f to overwrite." >&2 && return 1
        printf "%-12s %s\n" "Input:" "$FOLDER"
        printf "%-12s %s\n" "Method:" "zip -r -9"
        local start_time end_time elapsed_time
        start_time=$(date +%s)
        zip -r -9 -q "$ARCHIVE" "$FOLDER"
        end_time=$(date +%s)
        elapsed_time=$((end_time - start_time))
    else
        ARCHIVE="${OUTFILE:-$NAME.tar.zst}"
        [ -f "$ARCHIVE" ] && [ "$FORCE" -ne 1 ] && echo "Error: '$ARCHIVE' exists. Use -f to overwrite." >&2 && return 1
        printf "%-12s %s\n" "Input:" "$FOLDER"
        printf "%-12s %s\n" "Method:" "zstd --ultra -22"
        local start_time end_time elapsed_time
        start_time=$(date +%s)
        tar -cf - "$FOLDER" | zstd --ultra -22 -T0 -c > "$ARCHIVE"
        end_time=$(date +%s)
        elapsed_time=$((end_time - start_time))
    fi

    local ARCHIVE_SIZE FOLDER_SIZE SAVED RATIO

    # Cross-platform stat
    if stat -c%s . &>/dev/null 2>&1; then
        ARCHIVE_SIZE=$(stat -c%s "$ARCHIVE" 2>/dev/null || echo "0")
    else
        ARCHIVE_SIZE=$(stat -f%z "$ARCHIVE" 2>/dev/null || echo "0")
    fi

    FOLDER_SIZE=$(du -sb "$FOLDER" 2>/dev/null | cut -f1 || echo "0")

    echo
    if [ "$FOLDER_SIZE" -gt 0 ] && [ "$ARCHIVE_SIZE" -gt 0 ]; then
        SAVED=$((FOLDER_SIZE - ARCHIVE_SIZE))
        RATIO=$(awk "BEGIN {printf \"%.2f\", $ARCHIVE_SIZE * 100 / $FOLDER_SIZE}")
        printf "%-12s %s\n" "Original:" "$(numfmt --to=iec "$FOLDER_SIZE")"
        printf "%-12s %s\n" "Result:" "$(numfmt --to=iec "$ARCHIVE_SIZE")"
        printf "%-12s %s%% (~%s saved)\n" "Ratio:" "$RATIO" "$(numfmt --to=iec "$SAVED")"
    else
        printf "%-12s %s\n" "Original:" "$(numfmt --to=iec "$FOLDER_SIZE")"
        printf "%-12s %s\n" "Result:" "$(numfmt --to=iec "$ARCHIVE_SIZE")"
        printf "%-12s %s\n" "Ratio:" "N/A"
    fi

    printf "%-12s %ss\n" "Time:" "$elapsed_time"
    printf "%-12s %s\n" "Status:" "Completed"
    printf "%-12s %s\n" "Output:" "$ARCHIVE"
    echo
}

for folder in "$@"; do
    compress_folder "$folder"
done
