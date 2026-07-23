# Usage: ff "name"
# Find FILES only by case-insensitive name.
function ff
    command find . -type f -iname $argv
end
