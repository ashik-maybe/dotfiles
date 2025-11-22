local wezterm = require 'wezterm'

-- 🖋 Font setup
local font_name = 'Hack Nerd Font'
local font_size = 12.0

-- 🎨 Auto-switch with fallback to Macchiato
local function scheme_for_appearance(appearance)
  if appearance:find 'Dark' then
    return 'Catppuccin Macchiato'
  else
    return 'Catppuccin Latte'
  end
end

-- 🪟 Window appearance
local window_padding = { left = 2, right = 2, top = 2, bottom = 2 }

return {
  font = wezterm.font(font_name),
  font_size = font_size,
  color_scheme = scheme_for_appearance(wezterm.gui.get_appearance()),
  window_padding = window_padding,
  hide_tab_bar_if_only_one_tab = true,
  use_fancy_tab_bar = false,
  enable_scroll_bar = false,
  window_close_confirmation = 'NeverPrompt',
  window_decorations = 'NONE',
  enable_wayland = true,
  default_cursor_style = 'BlinkingBlock',
  cursor_blink_rate = 750,
}
