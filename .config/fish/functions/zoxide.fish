# zoxide — Jump to directories by frequency and recency. First call per shell installs the hook.
#   z                         # best match; bare z goes to $HOME
#   zi                        # interactive picker
#   z -                       # previous directory
#   zoxide query -l           # list the jump database
#   zoxide query foo          # show where z foo lands
function zoxide --description "Smarter cd command with frecency-based directory jumping"
    if not functions -q __zoxide_hook
        command zoxide init fish | source
    end
    command zoxide $argv
end
