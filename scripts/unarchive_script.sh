#!/bin/bash
set -euo pipefail

# Optional tools (only check these)
for cmd in unzip unrar 7z; do
    command -v "$cmd" >/dev/null 2>&1 || { echo "⚠️ Warning: '$cmd' not found. Some formats may not be supported." >&2; }
done

log() {
    echo "$@"
}

die() {
    echo "❌ Error: $1" >&2
    exit 1
}

if [ $# -ne 1 ]; then
    echo "Usage: $0 <file>"
    exit 1
fi

file="$1"
[ -f "$file" ] || die "'$file' is not a valid file."

filename="$(basename "$file")"
target_dir="${filename%%.*}"
mkdir -p "$target_dir" || die "Failed to create target directory '$target_dir'."

# File size for progress info
FILE_SIZE=$(stat -c%s "$file")
log "📁 File:   $filename"
log "📦 Size:   $(numfmt --to=iec $FILE_SIZE)"
log "📂 Extracting into: './$target_dir/'..."

# Start extraction process
start_time=$(date +%s)

case "$file" in
    *.tar.*|*.tar)
        if ! tar -xf "$file" -C "$target_dir"; then
            die "Failed to extract '$file' with tar."
        fi
        ;;
    *.gz)
        if ! gunzip -c "$file" > "$target_dir/${filename%.gz}"; then
            die "Failed to extract '$file' with gunzip."
        fi
        ;;
    *.bz2)
        if ! bunzip2 -c "$file" > "$target_dir/${filename%.bz2}"; then
            die "Failed to extract '$file' with bunzip2."
        fi
        ;;
    *.xz)
        if ! unxz -c "$file" > "$target_dir/${filename%.xz}"; then
            die "Failed to extract '$file' with unxz."
        fi
        ;;
    *.lzma)
        if ! unlzma -c "$file" > "$target_dir/${filename%.lzma}"; then
            die "Failed to extract '$file' with unlzma."
        fi
        ;;
    *.zip)
        if ! unzip -q "$file" -d "$target_dir"; then
            die "Failed to extract '$file' with unzip."
        fi
        ;;
    *.rar)
        if ! unrar x -inul "$file" "$target_dir/"; then
            die "Failed to extract '$file' with unrar."
        fi
        ;;
    *.7z)
        if ! 7z x "$file" -o"$target_dir" >/dev/null; then
            die "Failed to extract '$file' with 7z."
        fi
        ;;
    *.Z)
        if ! uncompress -c "$file" > "$target_dir/${filename%.Z}"; then
            die "Failed to extract '$file' with uncompress."
        fi
        ;;
    *)
        die "Unsupported file type: '$file'"
        ;;
esac

# End extraction time
end_time=$(date +%s)
elapsed_time=$((end_time - start_time))

# Show stats
log "📊 File extraction complete."
log "⏱️ Extraction took: $elapsed_time seconds"

# Calculate and show extracted folder size
EXTRACTED_SIZE=$(du -sb "$target_dir" | cut -f1)
log "📦 Extracted size: $(numfmt --to=iec $EXTRACTED_SIZE)"

# Show progress bar if pv is available
if command -v pv &>/dev/null; then
    log "📈 Showing extraction progress..."
    pv -n "$file" | tar -xf - -C "$target_dir" | awk '{print "Extracted " $1 " bytes"}'
fi

log "✅ Extraction complete."

