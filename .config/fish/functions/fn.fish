# Usage: fn "name"
# Find files/dirs by case-insensitive name.
function fn
    command find . -iname $argv
end
