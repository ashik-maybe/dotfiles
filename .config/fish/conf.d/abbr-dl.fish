# ~/.config/fish/conf.d/abbr-dl.fish
# Modern Fish abbreviations for yt-dlp & aria2c

# ==============================================================================
# YT-DLP: VIDEO SHORTCUTS
# ==============================================================================

# 1080p download
abbr -a ytd1080 'yt-dlp -f "bestvideo[height<=1080]+bestaudio/best[height<=1080]" --merge-output-format mkv --embed-metadata --embed-thumbnail --write-auto-subs --sub-langs "en.*" --embed-subs -o "%(title)s - %(uploader)s [%(height)sp].%(ext)s" -P "~/Downloads/Videos"'

# 720p download
abbr -a ytd720 'yt-dlp -f "bestvideo[height<=720]+bestaudio/best[height<=720]" --merge-output-format mkv --embed-metadata --embed-thumbnail --write-auto-subs --sub-langs "en.*" --embed-subs -o "%(title)s - %(uploader)s [%(height)sp].%(ext)s" -P "~/Downloads/Videos"'

# mp3 download
abbr -a ytda 'yt-dlp -x --audio-format mp3 --audio-quality 0 --embed-metadata --embed-thumbnail --convert-thumbnails jpg -o "%(artist,uploader)s - %(title)s.%(ext)s" -P "~/Downloads/Music"'

# ==============================================================================
# ARIA2C: GENERAL DOWNLOADS
# ==============================================================================

# Fast multi-connection download (16 threads per server)
abbr -a a2 'aria2c -x 16 -s 16 -k 1M -d ~/Downloads'

# Resume broken/interrupted file download
abbr -a a2c 'aria2c -c -x 16 -s 16 -k 1M -d ~/Downloads'

# Download all URLs listed line-by-line in a text file
abbr -a a2i 'aria2c -x 16 -s 16 -i'
