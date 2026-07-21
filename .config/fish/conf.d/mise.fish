# ~/.config/fish/conf.d/mise.fish

# https://mise.jdx.dev/
# https://github.com/jdx/mise

# Safely exit if mise is not installed
if not type -q mise
    return 0
end

# Lazy-load mise on first prompt render for 0ms shell startup cost
function __active_mise_lazy --on-event fish_prompt
    functions -e __active_mise_lazy
    mise activate fish | source
end
