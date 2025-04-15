#!/bin/bash
set -e

ICON_DIR="$HOME/.icons"
ARCHIVE_DIR="data/icons"

echo "==> Installing icons and cursors..."

rm -rf "$ICON_DIR"
mkdir -p "$ICON_DIR"

for archive in "$ARCHIVE_DIR"/*; do
    [[ -f "$archive" ]] || continue
    echo "-> Extracting $(basename "$archive")"
    case "$archive" in
        *.tar.xz) tar -xJf "$archive" -C "$ICON_DIR" ;;
        *.tar.gz) tar -xzf "$archive" -C "$ICON_DIR" ;;
        *.zip) unzip -o "$archive" -d "$ICON_DIR" ;;
        *) echo "--> Skipping unsupported file: $archive" ;;
    esac
done

echo "✓ Icons/cursors installed to $ICON_DIR"
