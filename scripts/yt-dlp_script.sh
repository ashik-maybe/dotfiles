#!/bin/bash

# Set paths for yt-dlp and ffmpeg
YTDL_PATH="/usr/bin/yt-dlp"
FFMPEG_PATH="/usr/bin/ffmpeg"

# Set download directories
VIDEO_DOWNLOAD_DIR="$HOME/Downloads/Video"
AUDIO_DOWNLOAD_DIR="$HOME/Downloads/Audio"

# Create download directories if they don't exist
mkdir -p "$VIDEO_DOWNLOAD_DIR" "$AUDIO_DOWNLOAD_DIR"

# Function to handle the download process
download_video() {
    local URL=$1
    local FORMAT=$2
    local OUTPUT_DIR=$3
    local EXTRA_OPTS=$4
    local NEW_NAME=$5

    # Download and process media using yt-dlp with specified options
    "$YTDL_PATH" -f "$FORMAT" $EXTRA_OPTS --paths "$OUTPUT_DIR" "$URL"

    # Rename the file if a new name is provided
    if [ -n "$NEW_NAME" ]; then
        FILE_EXT=$(echo "$FORMAT" | grep -q "audio" && echo "mp3" || echo "mp4")
        mv "$OUTPUT_DIR/$(yt-dlp -e --get-filename -o '%(title)s.%(ext)s' "$URL")" "$OUTPUT_DIR/$NEW_NAME.$FILE_EXT"
        echo "File renamed to: $NEW_NAME.$FILE_EXT"
    fi

    echo "Download complete: $URL"
}

# Main functionality
main() {
    URL=$1
    NEW_NAME=$2

    # If no URL is provided, prompt for one
    if [ -z "$URL" ]; then
        read -rp "Enter the video URL: " URL
    fi

    # Prompt for download option selection
    echo "Select download type and quality:"
    echo "0. MP3 (128kbps)"
    echo "1. MP4 (480p)"
    echo "2. MP4 (720p)"
    echo "3. MP4 (1080p)"
    read -rp "Enter option number: " OPTION

    case $OPTION in
        0)
            FORMAT="bestaudio"
            OUTPUT_DIR="$AUDIO_DOWNLOAD_DIR"
            EXTRA_OPTS="-x --audio-format mp3 --audio-quality 128K --embed-thumbnail --add-metadata"
            ;;
        1)
            FORMAT="bestvideo[height<=480]+bestaudio/best[height<=480]"
            OUTPUT_DIR="$VIDEO_DOWNLOAD_DIR"
            EXTRA_OPTS="--embed-thumbnail --add-metadata --merge-output-format mp4 --embed-chapters --write-subs --write-auto-subs --embed-subs --compat-options no-keep-subs --sub-langs en"
            ;;
        2)
            FORMAT="bestvideo[height<=720]+bestaudio/best[height<=720]"
            OUTPUT_DIR="$VIDEO_DOWNLOAD_DIR"
            EXTRA_OPTS="--embed-thumbnail --add-metadata --merge-output-format mp4 --embed-chapters --write-subs --write-auto-subs --embed-subs --compat-options no-keep-subs --sub-langs en"
            ;;
        3)
            FORMAT="bestvideo[height<=1080]+bestaudio/best[height<=1080]"
            OUTPUT_DIR="$VIDEO_DOWNLOAD_DIR"
            EXTRA_OPTS="--embed-thumbnail --add-metadata --merge-output-format mp4 --embed-chapters --write-subs --write-auto-subs --embed-subs --compat-options no-keep-subs --sub-langs en"
            ;;
        *)
            echo "Invalid option selected."
            exit 1
            ;;
    esac

    # Start the download
    download_video "$URL" "$FORMAT" "$OUTPUT_DIR" "$EXTRA_OPTS" "$NEW_NAME"

    # Exit after completing the download
    echo "Exiting script. Run again to download another file."
}

# Execute the script
main "$@"
