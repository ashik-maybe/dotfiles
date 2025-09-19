#!/usr/bin/env bash
#
# k - Ultra Compression Tool (zstd or zip)
#
# Usage:
#   k [OPTIONS] <FOLDER>
#
# Options:
#   -o FILE     Set output filename (default: <foldername>.tar.zst or .zip)
#   -f          Force overwrite if output exists
#   -z          Use ZIP instead of zstd (faster, less compression)
#
# Features:
#   • Uses zstd ultra -22 for maximum compression by default
#   • Optional ZIP mode for compatibility
#   • Shows size savings and compression ratio
#   • Optional progress bar with 'pv'
#   • Safe: won’t overwrite unless -f is used
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
    *) echo "❌ Invalid option: -$OPTARG" >&2; echo "💡 Run '$0 --help' for usage." >&2; exit 1 ;;
  esac
done
shift $((OPTIND - 1))

FOLDER="${1:-}"
[ -z "$FOLDER" ] && echo "❌ Error: No folder specified." >&2 && exit 1
[ ! -d "$FOLDER" ] && echo "❌ Error: '$FOLDER' is not a directory." >&2 && exit 1

NAME="$(basename "$FOLDER")"

if [ "$USE_ZIP" -eq 1 ]; then
  EXT="zip"
  ARCHIVE="${OUTFILE:-$NAME.zip}"
  [ -f "$ARCHIVE" ] && [ "$FORCE" -ne 1 ] && echo "❌ '$ARCHIVE' exists. Use -f to overwrite." >&2 && exit 1
  echo "📁 Folder: $FOLDER"
  echo "🛠 Compressing with: zip -r -9"
  zip -r -9 -q "$ARCHIVE" "$FOLDER"
else
  COMP="zstd --ultra -22 -T0"
  EXT="tar.zst"
  ARCHIVE="${OUTFILE:-$NAME.tar.zst}"
  [ -f "$ARCHIVE" ] && [ "$FORCE" -ne 1 ] && echo "❌ '$ARCHIVE' exists. Use -f to overwrite." >&2 && exit 1
  echo "📁 Folder: $FOLDER"
  echo "🛠 Compressing with: $COMP"
  if command -v pv &>/dev/null; then
    tar -cf - "$FOLDER" | pv | $COMP -c > "$ARCHIVE"
  else
    tar -cf - "$FOLDER" | $COMP -c > "$ARCHIVE"
  fi
fi

ARCHIVE_SIZE=$(stat -c%s "$ARCHIVE" 2>/dev/null || stat -f%z "$ARCHIVE" 2>/dev/null)
FOLDER_SIZE=$(du -sb "$FOLDER" | cut -f1)

if [ -n "${ARCHIVE_SIZE:-}" ]; then
  SAVED=$((FOLDER_SIZE - ARCHIVE_SIZE))
  RATIO=$(awk "BEGIN {printf \"%.2f\", $ARCHIVE_SIZE * 100 / $FOLDER_SIZE}")
  echo "📊 Original size:   $(numfmt --to=iec $FOLDER_SIZE)"
  echo "📉 Archive size:    $(numfmt --to=iec $ARCHIVE_SIZE)"
  echo "💡 Compression:     $RATIO% of original (~$(numfmt --to=iec $SAVED) saved)"
fi

echo "✅ Done: $ARCHIVE"
