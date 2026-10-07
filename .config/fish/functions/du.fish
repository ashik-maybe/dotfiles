# du — folder sizes. FORCES: -h and a depth of 1 (one line per top entry);
#       anything you pass wins over the defaults (-s/-sh drop the depth cap).
#   du                        # size of each entry in the current directory
#   du ~/Downloads            # top-level breakdown: find the hog
#   du -sh .                  # one total for the whole tree
#   du -a                     # files too, still capped at depth 1
#   du --exclude='*.log'      # skip patterns (GNU)
function du --description "Estimate file and directory space usage with human-readable totals"
    if string match -qr -- '^--summarize$|^-[a-z]*s[a-z]*$' -- $argv
        command du -h $argv
    else
        command du -h -d 1 $argv
    end
end
