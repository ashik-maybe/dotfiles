#!/usr/bin/env bash
set -euo pipefail

# ----------------------------------------
# archive.sh - Compress a folder with maximum compression (.tar.zst)
#
# Usage:
#   ./archive.sh <folder> [options]
#
# Options:
#   -o FILE     Output archive name (default: foldername.tar.zst)
#   -f          Force overwrite if archive already exists
#
# Examples:
#   ./archive.sh myfolder
#   ./archive.sh -o docs.tar.zst -f myfolder
#
# Dependencies:
#   tar, zstd (for compression)
# ----------------------------------------

OUTFILE=""
FORCE=0

while getopts ":o:f" opt; do
    case "$opt" in
        o) OUTFILE="$OPTARG" ;;
        f) FORCE=1 ;;
        *) echo "Invalid option"; exit 1 ;;
    esac
done
shift $((OPTIND - 1))

FOLDER="${1:-}"

[ -z "$FOLDER" ] && echo "❌ Error: No folder specified." && exit 1
[ ! -d "$FOLDER" ] && echo "❌ Error: '$FOLDER' is not a directory." && exit 1

# Default to .tar.zst format with maximum compression
COMP="zstd --ultra -22 -T0"; EXT="zst"

NAME="$(basename "$FOLDER")"
ARCHIVE="${OUTFILE:-$NAME.tar.$EXT}"

if [ -f "$ARCHIVE" ] && [ "$FORCE" -ne 1 ]; then
    echo "❌ Error: File '$ARCHIVE' exists. Use -f to overwrite."
    exit 1
fi

echo "📁 Folder:   $FOLDER"
FOLDER_SIZE=$(du -sb "$FOLDER" | cut -f1)

echo "🛠 Compressing with: $COMP"
echo "📦 Output file: $ARCHIVE"

# Archive
if command -v pv &>/dev/null; then
    tar -cf - "$FOLDER" | pv | $COMP -c > "$ARCHIVE"
else
    tar -cf - "$FOLDER" | $COMP -c > "$ARCHIVE"
fi

ARCHIVE_SIZE=$(stat -c%s "$ARCHIVE" 2>/dev/null || stat -f%z "$ARCHIVE")  # POSIX fallback

# Show stats
if [ -n "${ARCHIVE_SIZE:-}" ]; then
    SAVED=$((FOLDER_SIZE - ARCHIVE_SIZE))
    RATIO=$(awk "BEGIN {printf \"%.2f\", $ARCHIVE_SIZE * 100 / $FOLDER_SIZE}")
    echo "📊 Original size:   $(numfmt --to=iec $FOLDER_SIZE)"
    echo "📉 Archive size:    $(numfmt --to=iec $ARCHIVE_SIZE)"
    echo "💡 Compression:     $RATIO% of original (~$(numfmt --to=iec $SAVED) saved)"
fi

echo "✅ Done: $ARCHIVE"
