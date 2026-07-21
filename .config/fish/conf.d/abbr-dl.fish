# ~/.config/fish/conf.d/abbr-dl.fish
# Modern Fish abbreviations for yt-dlp & aria2c

# ==============================================================================
# YT-DLP: VIDEO SHORTCUTS (Single Clean .mkv Output)
# ==============================================================================

# Quick video download (best quality -> merged MKV + metadata + thumbnail)
abbr -a ytd 'yt-dlp -f "bestvideo+bestaudio/best" --merge-output-format mkv --embed-metadata --embed-thumbnail -P "~/Downloads/Videos"'

# 1080p download with metadata, cover art, and auto-embedded English/Bengali subtitles (No leftover files)
abbr -a ytd1080 'yt-dlp -f "bestvideo[height<=1080]+bestaudio/best[height<=1080]" --merge-output-format mkv --embed-metadata --embed-thumbnail --sub-langs "en.*,bn.*" --embed-subs -P "~/Downloads/Videos"'

# 720p download (lighter file size for fast saving)
abbr -a ytd720 'yt-dlp -f "bestvideo[height<=720]+bestaudio/best[height<=720]" --merge-output-format mkv --embed-metadata --embed-thumbnail -P "~/Downloads/Videos"'

# Download whole playlist into its own subfolder with numbered index
abbr -a ytpl 'yt-dlp -o "~/Downloads/Playlists/%(playlist_title)s/%(playlist_index)s - %(title)s.%(ext)s" --embed-metadata'

# Quick interactive selection (lists available video/audio formats)
abbr -a ytf 'yt-dlp -F'

# ==============================================================================
# YT-DLP: AUDIO, MUSIC & SUBTITLE SHORTCUTS (MP3 ONLY)
# ==============================================================================

# Ultimate Music Downloader (V0/320kbps MP3 + converted JPG cover art + metadata)
abbr -a ytm 'yt-dlp -x --audio-format mp3 --audio-quality 0 --embed-metadata --embed-thumbnail --convert-thumbnails jpg -P "~/Downloads/Music"'

# Quick MP3 extraction (simple audio grab to ~/Downloads/Music)
abbr -a yta 'yt-dlp -x --audio-format mp3 --audio-quality 0 -P "~/Downloads/Music"'

# High-efficiency Opus audio (best for podcasts, streams, and audiobooks)
abbr -a yta-opus 'yt-dlp -x --audio-format opus --embed-metadata -P "~/Downloads/Music"'

# Standalone subtitles downloader (only use this if you want the .vtt file alone)
abbr -a ytsub 'yt-dlp --skip-download --write-subs --sub-langs "en.*,bn.*" --convert-subs vtt -P "~/Downloads/Subs"'

# ==============================================================================
# ARIA2C: GENERAL DOWNLOADS
# ==============================================================================

# Fast multi-connection download (16 threads per server)
abbr -a a2 'aria2c -x 16 -s 16 -k 1M -d ~/Downloads'

# Resume broken/interrupted file download
abbr -a a2c 'aria2c -c -x 16 -s 16 -k 1M -d ~/Downloads'

# Download all URLs listed line-by-line in a text file
abbr -a a2i 'aria2c -x 16 -s 16 -i'

# ==============================================================================
# POWER COMBO: YT-DLP POWERED BY ARIA2C ENGINE
# ==============================================================================

# Turbocharged video download (offloads chunk downloading to aria2c engine)
abbr -a yt-aria 'yt-dlp --downloader aria2c --downloader-args "aria2c:-x 16 -s 16 -k 1M" --merge-output-format mkv --embed-metadata --embed-thumbnail -P "~/Downloads/Videos"'
