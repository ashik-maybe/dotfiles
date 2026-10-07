# duf — df as a colorful dashboard. FORCES: --only local,fuse so network,
#        snap/loop and special filesystems stay out of the table.
#   duf                       # size / used / avail / usage% at a glance
#   duf /mnt/data             # only these mount points
#   duf -sort size            # biggest first (also: mountpoint|used|avail|usage|inodes)
#   duf -json | jq            # structured output for scripts
function duf --description 'Disk usage dashboard for local filesystems'
    command duf --only local,fuse $argv
end
