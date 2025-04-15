#!/bin/bash

set -e

# ╭──────────────────────────────────────────────────╮
# │             Install Fonts                        │
# │        Auto-extract from local archives → 🖋️     │
# ╰──────────────────────────────────────────────────╯

FONT_ARCHIVES_DIR="data/fonts"
TARGET_DIR="$HOME/.fonts"
BACKUP_FONTS_DIR="$HOME/fonts-backup-$(date +%Y%m%d-%H%M%S)"

# Function to handle errors and exit with a message
error_exit() {
    echo "⚠️  Error: $1"
    exit 1
}

# Function to extract font archives
extract_archives() {
    local src_dir="$1"
    local theme_type="$2"
    echo "⤷ Processing $theme_type archives in '$src_dir'"

    for archive in "$src_dir"/*; do
        [[ -f "$archive" ]] || continue
        echo "→ Extracting $(basename "$archive")"
        case "$archive" in
            *.tar.bz2) tar -xjf "$archive" -C "$TARGET_DIR" || error_exit "Failed to extract $archive" ;;
            *.tar.gz)  tar -xzf "$archive" -C "$TARGET_DIR" || error_exit "Failed to extract $archive" ;;
            *.zip)     unzip -o "$archive" -d "$TARGET_DIR" || error_exit "Failed to extract $archive" ;;
            *) echo "⚠️  Skipping unsupported file: $archive" ;;
        esac
    done
}

# Check if the fonts directory exists
if [[ ! -d "$FONT_ARCHIVES_DIR" ]]; then
    error_exit "Font archives directory '$FONT_ARCHIVES_DIR' not found."
fi

# Check if the target directory exists, if not, create it
if [[ ! -d "$TARGET_DIR" ]]; then
    echo "→ Creating target fonts directory at '$TARGET_DIR'"
    mkdir -p "$TARGET_DIR" || error_exit "Failed to create fonts directory"
fi

# Backup existing fonts if they exist
if [[ -d "$TARGET_DIR" && "$(ls -A $TARGET_DIR)" ]]; then
    echo "→ Existing fonts found. Backing up to '$BACKUP_FONTS_DIR'"
    mv "$TARGET_DIR" "$BACKUP_FONTS_DIR" || error_exit "Failed to move fonts to backup"
fi

# Extract Fonts
echo "⤷ Extracting custom fonts..."
extract_archives "$FONT_ARCHIVES_DIR" "font"

echo
echo "✅ Fonts installed to '$TARGET_DIR'"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✨ Tip: Don't forget to check out the wallpapers repo"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
