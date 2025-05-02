#!/bin/bash

# Set the main download directory
DOWNLOAD_DIR="$HOME/Downloads"

# Function to handle the download link
download_file() {
    local URL="$1"
    local NEW_NAME="$2"
    
    # Start the aria2c download with optimized options for maximum speed
    aria2c -d "$DOWNLOAD_DIR" -x 16 -s 16 --max-connection-per-server=8 --split=16 --disable-ipv6 --no-netrc "$URL"
    
    # Get the filename of the downloaded file
    FILENAME=$(basename "$URL")
    FILE_EXT="${FILENAME##*.}"  # Extract the file extension
    
    # Rename the file if a new name is provided
    if [ -n "$NEW_NAME" ]; then
        mv "$DOWNLOAD_DIR/$FILENAME" "$DOWNLOAD_DIR/$NEW_NAME.$FILE_EXT"
        FILENAME="$NEW_NAME.$FILE_EXT"
    fi

    echo "File downloaded to: $DOWNLOAD_DIR/$FILENAME"
    echo "Download complete."
}

# Check if URL is passed as an argument
if [ -z "$1" ]; then
    # If no URL is passed, prompt for the URL
    echo "Enter the download URL:"
    read -p "> " URL
else
    URL="$1"
fi

# Optional renaming
if [ -n "$2" ]; then
    NEW_NAME="$2"
else
    NEW_NAME=""
fi

# Download the file
download_file "$URL" "$NEW_NAME"