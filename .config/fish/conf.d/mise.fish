# ~/.config/fish/conf.d/mise.fish
#
# Fresh Install Instructions:
# 1. Install mise:               curl https://mise.run | sh
# 2. Reload shell:               exec fish
# 3. Verify installation:        mise doctor
# 4. Install tools (usage):      mise install
# 5. Add shell completions:      mise completion fish > ~/.config/fish/completions/mise.fish

# 1. Interactive terminal activation (runs first so active tools take precedence in PATH)
if status is-interactive
    if test -x "$HOME/.local/bin/mise"
        $HOME/.local/bin/mise activate fish | source
    else if type -q mise
        mise activate fish | source
    end
end

# 2. Fallback for non-interactive tools / IDEs
set -l shims_dir "$HOME/.local/share/mise/shims"
if test -d "$shims_dir"; and not contains "$shims_dir" $PATH
    fish_add_path --append "$shims_dir"
end
