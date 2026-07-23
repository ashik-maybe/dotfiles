# Usage: df
# Disk space, human-readable, excludes virtual/temp filesystems.
function df
    command df -hT -x tmpfs -x devtmpfs -x squashfs -x overlay $argv
end
