#!/usr/bin/env bash
set -euo pipefail

# Usage: ./archive.sh <folder> [options]
#
# Options:
#   -o FILE     Output archive name (default: foldername.tar.zst or foldername.zip)
#   -f          Force overwrite if archive already exists
#   -a FORMAT   Choose archive format (tar.zst, tar.xz, tar.gz, tar.bz2, tar.lzma, 7z, tar.lz4, zip)
#
# Archive Formats:
#   - tar.zst    (zstd): Fast compression/decompression. Lower compression ratio.
#   - tar.xz    (XZ): Very high compression, slower speed.
#   - tar.gz    (Gzip): Good balance of speed and ratio. Widely supported.
#   - tar.bz2   (Bzip2): Better ratio than gzip, slower.
#   - tar.lzma  (LZMA): High ratio, slower compression.
#   - 7z       (7zip): Excellent ratio, multi-threaded, requires 7z for extraction.
#   - tar.lz4   (LZ4): Extremely fast, lower compression ratio.
#   - zip      (ZIP): Most compatible, lower compression ratio.
#
# Example usage:
#   ./archive.sh myfolder             # Default .tar.zst
#   ./archive.sh -o myarchive.zip -f   # Force overwrite .zip
#   ./archive.sh -a tar.xz myfolder   # .tar.xz archive

OUTFILE=""
FORCE=0
ARCHIVE_FORMAT="tar.zst"  # Default to zstd format

while getopts ":o:f:a:" opt; do
    case "$opt" in
        o) OUTFILE="$OPTARG" ;;
        f) FORCE=1 ;;
        a) ARCHIVE_FORMAT="$OPTARG" ;;
        *) echo "Invalid option"; exit 1 ;;
    esac
done
shift $((OPTIND - 1))

FOLDER="${1:-}"

[ -z "$FOLDER" ] && echo "❌ Error: No folder specified." && exit 1
[ ! -d "$FOLDER" ] && echo "❌ Error: '$FOLDER' is not a directory." && exit 1

# Choose compression based on selected format
case "$ARCHIVE_FORMAT" in
    tar.zst) COMP="zstd --ultra -22 -T0"; EXT="zst" ;;
    tar.xz) COMP="xz -9"; EXT="xz" ;;
    tar.gz) COMP="gzip -9"; EXT="gz" ;;
    tar.bz2) COMP="bzip2 -9"; EXT="bz2" ;;
    tar.lzma) COMP="lzma -9"; EXT="lzma" ;;
    7z) COMP="7z a -mx9"; EXT="7z" ;;
    tar.lz4) COMP="lz4 -9"; EXT="lz4" ;;
    zip) COMP="zip -r -9 -q"; EXT="zip" ;;  # For zip
    *) echo "❌ Error: Unsupported archive format."; exit 1 ;;
esac

NAME="$(basename "$FOLDER")"
ARCHIVE="${OUTFILE:-$NAME.$EXT}"

if [ -f "$ARCHIVE" ] && [ "$FORCE" -ne 1 ]; then
    echo "❌ Error: File '$ARCHIVE' exists. Use -f to overwrite."
    exit 1
fi

# Clean output
echo "📁 Folder:   $FOLDER"
FOLDER_SIZE=$(du -sb "$FOLDER" | cut -f1)

echo "🛠 Compressing with: $COMP"
echo "📦 Output file: $ARCHIVE"

# Archive
if [ "$ARCHIVE_FORMAT" == "zip" ]; then
    $COMP "$ARCHIVE" "$FOLDER"  # Suppress redundant info
else
    if command -v pv &>/dev/null; then
        tar -cf - "$FOLDER" | pv | $COMP -c > "$ARCHIVE"
    else
        tar -cf - "$FOLDER" | $COMP -c > "$ARCHIVE"
    fi
fi

ARCHIVE_SIZE=$(stat -c%s "$ARCHIVE" 2>/dev/null || stat -f%z "$ARCHIVE")

# Show stats
if [ -n "${ARCHIVE_SIZE:-}" ]; then
    SAVED=$((FOLDER_SIZE - ARCHIVE_SIZE))
    RATIO=$(awk "BEGIN {printf \"%.2f\", $ARCHIVE_SIZE * 100 / $FOLDER_SIZE}")
    echo "📊 Original size:   $(numfmt --to=iec $FOLDER_SIZE)"
    echo "📉 Archive size:    $(numfmt --to=iec $ARCHIVE_SIZE)"
    echo "💡 Compression:     $RATIO% of original (~$(numfmt --to=iec $SAVED) saved)"
fi

echo "✅ Done: $ARCHIVE"

