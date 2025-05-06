#!/bin/bash

# Set the main download directory
DOWNLOAD_DIR="$HOME/Downloads"

# Function to handle the download link
download_file() {
    local URL="$1"
    local NEW_NAME="$2"

    echo -e "\n📥 Starting download from:"
    echo -e "🔗 $URL\n"
    
    # Start the aria2c download with optimized options
    aria2c -d "$DOWNLOAD_DIR" -x 16 -s 16 --max-connection-per-server=8 --split=16 --disable-ipv6 --no-netrc "$URL"

    # Get the filename of the downloaded file
    FILENAME=$(basename "$URL")
    FILE_EXT="${FILENAME##*.}"

    # Rename the file if a new name is provided
    if [ -n "$NEW_NAME" ]; then
        mv "$DOWNLOAD_DIR/$FILENAME" "$DOWNLOAD_DIR/$NEW_NAME.$FILE_EXT"
        FILENAME="$NEW_NAME.$FILE_EXT"
        echo -e "📝 File renamed to: $NEW_NAME.$FILE_EXT"
    fi

    # Get file size in human-readable format
    FILE_SIZE=$(du -h "$DOWNLOAD_DIR/$FILENAME" | cut -f1)

    echo -e "✅ File saved to: $DOWNLOAD_DIR/$FILENAME"
    echo -e "📏 File size: $FILE_SIZE"
    echo -e "📦 Download complete.\n"
}

# Check if URL is passed as an argument
if [ -z "$1" ]; then
    echo -e "🔗 Enter the download URL:"
    read -p "> " URL
else
    URL="$1"
fi

# Optional renaming
NEW_NAME="${2:-}"

# Download the file
download_file "$URL" "$NEW_NAME"

