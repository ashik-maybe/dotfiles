#!/bin/bash
set -e

FONT_DIR="$HOME/.fonts"
ARCHIVE_DIR="data/fonts"

echo "==> Installing fonts..."

rm -rf "$FONT_DIR"
mkdir -p "$FONT_DIR"

for archive in "$ARCHIVE_DIR"/*; do
    [[ -f "$archive" ]] || continue
    echo "-> Extracting $(basename "$archive")"
    case "$archive" in
        *.zip) unzip -o "$archive" -d "$FONT_DIR" ;;
        *.tar.gz) tar -xzf "$archive" -C "$FONT_DIR" ;;
        *.tar.xz) tar -xJf "$archive" -C "$FONT_DIR" ;;
        *) echo "--> Skipping unsupported file: $archive" ;;
    esac
done

fc-cache -f "$FONT_DIR"

echo "✓ Fonts installed to $FONT_DIR"
