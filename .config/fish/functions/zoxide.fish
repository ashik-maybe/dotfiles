# zoxide — smart cd by frecency. FIRST call per shell installs:
#   z                         # jump to the best match; bare `z` = $HOME
#   zi                        # interactive picker
#   z -                       # back to the previous directory
#   zoxide query -l           # list the entire jump database
#   zoxide query foo          # show where `z foo` would land
function zoxide --description "Smarter cd command with frecency-based directory jumping"
    if not functions -q __zoxide_hook
        command zoxide init fish | source
    end
    command zoxide $argv
end
