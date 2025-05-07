#!/usr/bin/env bash
set -euo pipefail

# archive.sh - Compress a folder to .tar.zst or .zip
# Usage: ./archive.sh [options] <folder>
# Options:
#   -o FILE   Output name (default: foldername.tar.zst or .zip)
#   -f        Force overwrite if archive exists
#   -z        Use .zip format instead of .tar.zst
#   --help    Show this help message
# Examples:
#   ./archive.sh myfolder
#   ./archive.sh -z -f -o backup.zip myfolder
# Requires: tar, zstd (for .tar.zst), zip (for .zip)

OUTFILE=""
FORCE=0
USE_ZIP=0

# Help
if [[ "${1:-}" == "--help" ]]; then
  sed -n '2,12p' "$0" | sed 's/^# //'
  exit 0
fi

while getopts ":o:fz" opt; do
  case "$opt" in
    o) OUTFILE="$OPTARG" ;;
    f) FORCE=1 ;;
    z) USE_ZIP=1 ;;
    *) echo "❌ Invalid option"; exit 1 ;;
  esac
done
shift $((OPTIND - 1))

FOLDER="${1:-}"
[ -z "$FOLDER" ] && echo "❌ Error: No folder specified." && exit 1
[ ! -d "$FOLDER" ] && echo "❌ Error: '$FOLDER' is not a directory." && exit 1

NAME="$(basename "$FOLDER")"

if [ "$USE_ZIP" -eq 1 ]; then
  EXT="zip"
  ARCHIVE="${OUTFILE:-$NAME.zip}"
  [ -f "$ARCHIVE" ] && [ "$FORCE" -ne 1 ] && echo "❌ '$ARCHIVE' exists. Use -f to overwrite." && exit 1
  echo "📁 Folder: $FOLDER"
  echo "🛠 Compressing as .zip (max)"
  zip -r -9 -q "$ARCHIVE" "$FOLDER"
else
  COMP="zstd --ultra -22 -T0"
  EXT="tar.zst"
  ARCHIVE="${OUTFILE:-$NAME.tar.zst}"
  [ -f "$ARCHIVE" ] && [ "$FORCE" -ne 1 ] && echo "❌ '$ARCHIVE' exists. Use -f to overwrite." && exit 1
  echo "📁 Folder: $FOLDER"
  echo "🛠 Compressing with: $COMP"
  if command -v pv &>/dev/null; then
    tar -cf - "$FOLDER" | pv | $COMP -c > "$ARCHIVE"
  else
    tar -cf - "$FOLDER" | $COMP -c > "$ARCHIVE"
  fi
fi

ARCHIVE_SIZE=$(stat -c%s "$ARCHIVE" 2>/dev/null || stat -f%z "$ARCHIVE")
FOLDER_SIZE=$(du -sb "$FOLDER" | cut -f1)

if [ -n "${ARCHIVE_SIZE:-}" ]; then
  SAVED=$((FOLDER_SIZE - ARCHIVE_SIZE))
  RATIO=$(awk "BEGIN {printf \"%.2f\", $ARCHIVE_SIZE * 100 / $FOLDER_SIZE}")
  echo "📊 Original size:   $(numfmt --to=iec $FOLDER_SIZE)"
  echo "📉 Archive size:    $(numfmt --to=iec $ARCHIVE_SIZE)"
  echo "💡 Compression:     $RATIO% of original (~$(numfmt --to=iec $SAVED) saved)"
fi

echo "✅ Done: $ARCHIVE"

