#!/usr/bin/env zsh

# unarchive - Extract any supported archive format
# Usage: unarchive <file>
# Options: -n (dry run), -v (verbose), -f (force overwrite)

setopt localoptions no_unset

local file depth=1 verbose=0 dry_run=0

while getopts "vnf" opt; do
  case "$opt" in
    v) verbose=1 ;;
    n) dry_run=1 ;;
    f) depth=0 ;;  # Force overwrite (skip folder creation)
    *) echo "Usage: $0 [-v] [-n] [-f] <file>" >&2; exit 1 ;;
  esac
done
shift $((OPTIND - 1))

[ -z "$1" ] && echo "Usage: unarchive <file>" >&2 && exit 1
[ ! -f "$1" ] && echo "Error: '$1' is not a valid file." >&2 && exit 1

local filename="$(basename -- "$1")"
local target_dir="${filename%.*}"

# Handle nested extensions (e.g., .tar.gz → "file.tar" → "file")
case "$filename" in
  *.tar.gz|*.tar.bz2|*.tar.xz|*.tar.zst)
    target_dir="${target_dir%.*}"
    ;;
esac

# Check dependencies
for cmd in tar gunzip bunzip2 unxz unlzma 7z unzip unrar; do
  command -v "$cmd" >/dev/null || {
    echo "Error: Required command '$cmd' not found." >&2
    exit 1
  }
done

[ "$depth" -eq 1 ] && mkdir -p "$target_dir" || target_dir="."

[ "$verbose" -eq 1 ] && echo "Extracting '$filename' into './$target_dir/'..."

[ "$dry_run" -eq 1 ] && exit 0

# Extraction logic
case "$1" in
  *.tar.bz2|*.tbz2)
    tar --bzip2 -xf "$1" -C "$target_dir"
    ;;
  *.tar.gz|*.tgz)
    tar --gzip -xf "$1" -C "$target_dir"
    ;;
  *.tar.xz|*.txz)
    tar --xz -xf "$1" -C "$target_dir"
    ;;
  *.tar.zst|*.tzst)
    tar --zstd -xf "$1" -C "$target_dir"
    ;;
  *.tar.lz|*.tlz)
    tar --lzip -xf "$1" -C "$target_dir"
    ;;
  *.tar)
    tar -xf "$1" -C "$target_dir"
    ;;
  *.gz)
    gunzip -c "$1" > "$target_dir/${filename%.gz}"
    ;;
  *.bz2)
    bunzip2 -c "$1" > "$target_dir/${filename%.bz2}"
    ;;
  *.xz)
    unxz -c "$1" > "$target_dir/${filename%.xz}"
    ;;
  *.lzma)
    unlzma -c "$1" > "$target_dir/${filename%.lzma}"
    ;;
  *.zst)
    zstd -d "$1" -o "$target_dir/${filename%.zst}"
    ;;
  *.zip)
    unzip "$1" -d "$target_dir"
    ;;
  *.rar)
    unrar x -inul "$1" "$target_dir/"
    ;;
  *.7z)
    7z x "$1" -o"$target_dir" >/dev/null
    ;;
  *.Z)
    uncompress "$1"
    ;;
  *)
    echo "Unsupported file type: $1" >&2
    exit 1
    ;;
esac

[ $? -eq 0 ] && echo "✅ Extraction complete." || {
  echo "❌ Failed to extract '$1'." >&2
  exit 1
}