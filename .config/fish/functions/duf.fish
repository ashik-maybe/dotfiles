function duf --description 'Disk usage dashboard for local filesystems'
    command duf --only local,fuse $argv
end
