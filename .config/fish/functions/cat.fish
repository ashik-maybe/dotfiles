# Usage: cat [file]
# Auto-paged, line numbers, squeezes blank lines.
function cat
    command cat -s $argv | less -R -i -N -X -F --shift 5
end
