# Mise — activate tool versions in interactive shells.
#
# One mechanism: `mise activate fish` refreshes the environment each prompt.
# Child processes inherit it. For cron or IDE tasks, run `mise x -- <cmd>`.
#
# Fresh install:
# 1. Install mise:             curl https://mise.run | sh
# 2. Verify installation:      mise doctor
# 3. Install usage CLI:        mise use -g usage
# 4. Add shell completions:    mise completion fish > ~/.config/fish/completions/mise.fish

# Interactive shells only: active tools take precedence in PATH.
if status is-interactive
    if test -x "$HOME/.local/bin/mise"
        $HOME/.local/bin/mise activate fish | source
    else if type -q mise
        mise activate fish | source
    end
end
