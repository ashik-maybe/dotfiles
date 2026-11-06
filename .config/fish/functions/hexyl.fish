# hexyl — View binary files as colored hex.
#   hexyl firmware.bin        # offset, bytes, and ASCII column
#   hexyl -n 64 image.png     # first 64 bytes only
#   hexyl -s 4096 blob.bin    # skip ahead (negative counts from the end)
#   curl -s URL | hexyl       # no file argument reads stdin
function hexyl --description "Colored hex viewer for binary files"
    command hexyl $argv
end
