# ~/.config/fish/conf.d/aliases-scripts.fish

# <- Personal tools and helpers from `~/scripts` ->

# ==============================================================================
# 📜 CUSTOM SCRIPTS & ARCHIVERS
# ==============================================================================
abbr -a ar "$HOME/scripts/aria2c.sh"             # Aria2 download helper
abbr -a yt "$HOME/scripts/yt-dlp.sh"             # YouTube downloader wrapper
abbr -a k "$HOME/scripts/archive.sh"             # Archive files with custom logic
abbr -a x "$HOME/scripts/unarchive.sh"           # Extract archives with custom logic

# ==============================================================================
# 🛠️ SYSTEM & MEDIA HELPERS
# ==============================================================================
abbr -a warp "$HOME/scripts/toggle-warp.sh"      # Toggle Cloudflare WARP VPN
abbr -a vidlen "$HOME/scripts/video_speed_calc.sh" # Calculate video length by playback speed

# abbr -a patchvm "sudo $HOME/scripts/patch-vm-network.sh" # Restore VM internet access when Docker breaks libvirt's bridge
