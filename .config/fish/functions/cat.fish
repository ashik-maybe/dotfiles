# cat — byte-level file inspector. FORCES: line numbers, squeezed blank runs and
#        visible non-printables through less — but ONLY on a TTY: anything
#        redirected or piped gets raw, byte-exact output.
#   cat notes.txt             # TTY view: line #s, ^I tabs, $ ends, no double blanks
#   cat Makefile              # tabs vs spaces, CRLF (^M), trailing spaces jump out
#   cat a.txt > b.txt         # not a TTY → exact copy, nothing injected
#   command cat f | sha256sum # bypass the wrapper when you mean bytes
function cat --description "Inspect raw file formatting, invisible characters, and line endings"
    if not isatty stdout
        command cat $argv
        return
    end
    command cat --number --squeeze-blank --show-all $argv | less -RFX --mouse
    return $pipestatus[1]
end
