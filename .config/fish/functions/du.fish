# du — Show folder sizes.
# FORCES: human sizes, depth 1 (one line per top-level entry).
# A -s flag in the arguments removes the depth cap.
#   du                        # size of each entry here
#   du ~/Downloads            # top-level breakdown
#   du -sh .                  # one total for the whole tree
#   du --exclude='*.log'      # skip patterns (GNU du)
# See also: dust, ncdu, df.
function du --description "Estimate file and directory space usage with human-readable totals"
    if string match -qr -- '^--summarize$|^-[a-z]*s[a-z]*$' -- $argv
        command du -h $argv
    else
        command du -h -d 1 $argv
    end
end
