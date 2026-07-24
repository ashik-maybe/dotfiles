function df --description "Display disk space usage per filesystem in human-readable format"
    command df -hT -x tmpfs -x devtmpfs -x squashfs -x overlay $argv
end
