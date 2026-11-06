# duf — Show disk usage as a dashboard.
# FORCES: --only local,fuse. Network, snap/loop, and special filesystems stay out.
#   duf                       # size, used, available, usage percent
#   duf /mnt/data             # only these mount points
#   duf -sort size            # largest first
#   duf -json | jq            # structured output for scripts
# See also: df, du.
function duf --description 'Disk usage dashboard for local filesystems'
    command duf --only local,fuse $argv
end
