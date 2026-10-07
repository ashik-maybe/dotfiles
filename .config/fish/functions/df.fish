# df — free space per filesystem. FORCES: -hT (human sizes + type column) and
#       hides the noise: tmpfs, devtmpfs, squashfs, overlay.
#   df                        # real disks only, one screen
#   df /home                  # just the filesystem holding that path
#   df -x btrfs               # extra exclusions stack with the built-in ones
#   df --output=source,pcent  # pick your columns (GNU)
function df --description "Display disk space usage per filesystem in human-readable format"
    command df -hT -x tmpfs -x devtmpfs -x squashfs -x overlay $argv
end
