# ~/.config/fish/conf.d/mise.fish
#
# One mechanism: activate — dynamic env each prompt, interactive shells only;
# children of your terminal inherit it. For cron/IDE tasks: mise x -- <cmd>.
#
# Fresh Install Instructions:
# 1. Install mise:             curl https://mise.run | sh
# 2. Verify installation:      mise doctor
# 3. Install usage CLI:        mise use -g usage
# 4. Add shell completions:    mise completion fish > ~/.config/fish/completions/mise.fish

# Interactive terminal activation — active tools take precedence in PATH
if status is-interactive
    if test -x "$HOME/.local/bin/mise"
        $HOME/.local/bin/mise activate fish | source
    else if type -q mise
        mise activate fish | source
    end
end
