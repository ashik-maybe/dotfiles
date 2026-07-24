function du --description "Estimate file and directory space usage with human-readable totals"
    command du -h -d 1 $argv
end
