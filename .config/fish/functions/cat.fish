# cat — Inspect raw bytes of a file.
# FORCES: line numbers, squeezed blank lines, visible non-printables through less.
# On a TTY only. Piped or redirected output stays byte-exact.
#   cat notes.txt             # TTY view: numbers, ^I tabs, $ line ends
#   cat Makefile              # tabs vs spaces and CRLF stand out
#   cat a.txt > b.txt         # not a TTY: exact copy, nothing added
#   command cat f | sha256sum # bypass this wrapper for raw bytes
# See also: bat.
function cat --description "Inspect raw file formatting, invisible characters, and line endings"
    if not isatty stdout
        command cat $argv
        return
    end
    command cat --number --squeeze-blank --show-all $argv | less -RFX --mouse
    return $pipestatus[1]
end
