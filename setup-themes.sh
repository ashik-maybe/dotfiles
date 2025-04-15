#!/bin/bash

set -e

# ╭──────────────────────────────────────────────────╮
# │             Theme Setup: Icons & Cursors         │
# │        Auto-extract from local archives → 🖼️     │
# ╰──────────────────────────────────────────────────╯

ICON_ARCHIVES_DIR="data/icons"
CURSOR_ARCHIVES_DIR="data/cursors"
TARGET_DIR="$HOME/.icons"
BACKUP_ICONS_DIR="$HOME/icons-backup-$(date +%Y%m%d-%H%M%S)"

# Function to handle errors and exit with a message
error_exit() {
    echo "⚠️  Error: $1"
    exit 1
}

# Function to extract archives
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

# Check and create target directory
if [[ ! -d "$TARGET_DIR" ]]; then
    echo "→ Creating target icons directory at '$TARGET_DIR'"
    mkdir -p "$TARGET_DIR" || error_exit "Failed to create icons directory"
fi

# Backup existing icons if they exist
if [[ -d "$TARGET_DIR" && "$(ls -A $TARGET_DIR)" ]]; then
    echo "→ Existing icons found. Backing up to '$BACKUP_ICONS_DIR'"
    mv "$TARGET_DIR" "$BACKUP_ICONS_DIR" || error_exit "Failed to move icons to backup"
fi

# Extract Icons and Cursors
echo "⤷ Extracting custom icons..."
extract_archives "$ICON_ARCHIVES_DIR" "icon"

echo "⤷ Extracting custom cursors..."
extract_archives "$CURSOR_ARCHIVES_DIR" "cursor"

echo
echo "✅ Theming assets installed to '$TARGET_DIR'"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✨ Tip: Don't forget to check out the wallpapers repo"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
