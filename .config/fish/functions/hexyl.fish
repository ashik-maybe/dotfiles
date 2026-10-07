# hexyl — colored hex viewer for binaries, images, fonts, firmware.
#   hexyl firmware.bin        # offset + bytes + ASCII column, color-coded
#   hexyl -n 64 image.png     # first 64 bytes only — check magic numbers
#   hexyl -s 4096 blob.bin    # skip ahead (negative counts from the end)
#   curl -s URL | hexyl       # no file arg → reads stdin
function hexyl --description "Colored hex viewer for binary files"
    command hexyl $argv
end
