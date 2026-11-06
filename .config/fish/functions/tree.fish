# tree — Show directory structure at a glance.
# FORCES: colors, type marks, dirs first, gitignore, depth 3 max,
#         junk excluded, files stay out by default.
#   tree                      # 3 levels, directories only — structure map
#   tree ~/code              # survey another directory
#   tree --files              # full tree, files included
#   tree -L 1                 # your depth wins over the default
#   tree -a                   # include dotfiles
#   command tree              # bypass this wrapper for raw output
# See also: lt (full tree), ez -T.
function tree --description "Display directory structure, directories only by default"
    # Pass --help/--version straight through; forced flags would corrupt them.
    if string match -qr -- '^--(help|version)$' -- $argv
        command tree $argv
        return $status
    end

    # --files flips dirs-only off. -L in argv flips the depth cap off.
    set -l show_files 0
    set -l has_level 0
    set -l args
    for arg in $argv
        switch $arg
            case '--files'
                set show_files 1
            case '-L' '-L*'
                set has_level 1
                set -a args $arg
            case '*'
                set -a args $arg
        end
    end

    set -l forced -C -F --dirsfirst --gitignore --prune \
        -I .git -I node_modules -I dist -I build -I __pycache__ \
        -I .venv -I target -I vendor -I .cache

    if test $has_level -eq 0
        set -a forced -L 3
    end

    if test $show_files -eq 1
        command tree $forced $args
    else
        command tree -d $forced $args
    end
end
