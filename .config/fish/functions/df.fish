# df — Show free space per filesystem.
# FORCES: human sizes, type column, hides tmpfs, devtmpfs, squashfs, overlay.
#   df                        # real disks only
#   df /home                  # filesystem that holds the path
#   df -x btrfs               # add exclusions to the built-in list
# See also: duf, du, dust.
function df --description "Display disk space usage per filesystem in human-readable format"
    command df -hT -x tmpfs -x devtmpfs -x squashfs -x overlay $argv
end
