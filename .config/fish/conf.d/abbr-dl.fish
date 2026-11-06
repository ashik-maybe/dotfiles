# Download abbreviations — yt-dlp video/audio and aria2c files.

# Video: download at a fixed resolution. Files go to ~/Downloads/Video with metadata, thumbnail, and English subtitles.
abbr -a ytd1080 'yt-dlp -f "bestvideo[height<=1080]+bestaudio/best[height<=1080]" --merge-output-format mkv --embed-metadata --embed-thumbnail --write-auto-subs --sub-langs "en.*" --embed-subs -o "%(title)s - %(uploader)s [%(height)sp].%(ext)s" -P $HOME/Downloads/Video'

# Video: download at 720p. Same output rules as ytd1080.
abbr -a ytd720 'yt-dlp -f "bestvideo[height<=720]+bestaudio/best[height<=720]" --merge-output-format mkv --embed-metadata --embed-thumbnail --write-auto-subs --sub-langs "en.*" --embed-subs -o "%(title)s - %(uploader)s [%(height)sp].%(ext)s" -P $HOME/Downloads/Video'

# Audio: download as MP3 at best quality. Files go to ~/Downloads/Audio.
abbr -a ytda 'yt-dlp -x --audio-format mp3 --audio-quality 0 --embed-metadata --embed-thumbnail --convert-thumbnails jpg -o "%(artist,uploader)s - %(title)s.%(ext)s" -P $HOME/Downloads/Audio'

# Stream: play at 1080p in mpv with English subtitles. No file is saved.
abbr -a mpv1080 'mpv --ytdl-format="bestvideo[height<=1080]+bestaudio/best[height<=1080]" --slang="en,en-US" --ytdl-raw-options="sub-langs=en.*,write-subs=,write-auto-subs="'

# Stream: play at 720p in mpv with English subtitles.
abbr -a mpv720 'mpv --ytdl-format="bestvideo[height<=720]+bestaudio/best[height<=720]" --slang="en,en-US" --ytdl-raw-options="sub-langs=en.*,write-subs=,write-auto-subs="'

# Files: fast multi-connection download. 16 connections per server, into ~/Downloads.
abbr -a a2 'aria2c -x 16 -s 16 -k 1M -d $HOME/Downloads'

# Files: resume an interrupted download.
abbr -a a2c 'aria2c -c -x 16 -s 16 -k 1M -d $HOME/Downloads'

# Files: download every URL listed in a text file, one URL per line.
abbr -a a2i 'aria2c -x 16 -s 16 -k 1M -d $HOME/Downloads -i'
