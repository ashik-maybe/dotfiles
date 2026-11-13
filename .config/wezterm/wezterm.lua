-- WezTerm — Catppuccin theme. Follows the system light/dark appearance.

local wezterm = require 'wezterm'
local mux = wezterm.mux
local config = wezterm.config_builder()


-- Palette: Catppuccin Latte (light) and Catppuccin Macchiato (dark).
local catppuccin_latte = {
  foreground = '#4c4f69',
  background = '#eff1f5',
  cursor_bg = '#dc8a78',
  cursor_fg = '#eff1f5',
  cursor_border = '#dc8a78',
  selection_fg = '#eff1f5',
  selection_bg = '#dc8a78',
  scrollbar_thumb = '#acb0be',
  split = '#ccd0da',
  ansi = {
    '#5c5f77', -- black
    '#d20f39', -- red
    '#40a02b', -- green
    '#df8e1d', -- yellow
    '#1e66f5', -- blue
    '#ea76cb', -- magenta
    '#179299', -- cyan
    '#acb0be', -- white
  },
  brights = {
    '#6c6f85', -- black
    '#d20f39', -- red
    '#40a02b', -- green
    '#df8e1d', -- yellow
    '#1e66f5', -- blue
    '#ea76cb', -- magenta
    '#179299', -- cyan
    '#bcc0cc', -- white
  },
}

local catppuccin_macchiato = {
  foreground = '#cad3f5',
  background = '#24273a',
  cursor_bg = '#f4dbd6',
  cursor_fg = '#24273a',
  cursor_border = '#f4dbd6',
  selection_fg = '#24273a',
  selection_bg = '#f4dbd6',
  scrollbar_thumb = '#5b6078',
  split = '#363a4f',
  ansi = {
    '#494d64', -- black
    '#ed8796', -- red
    '#a6da95', -- green
    '#eed49f', -- yellow
    '#8aadf4', -- blue
    '#f5bde6', -- magenta
    '#8bd5ca', -- cyan
    '#b8c0e0', -- white
  },
  brights = {
    '#5b6078', -- black
    '#ed8796', -- red
    '#a6da95', -- green
    '#eed49f', -- yellow
    '#8aadf4', -- blue
    '#f5bde6', -- magenta
    '#8bd5ca', -- cyan
    '#a5adcb', -- white
  },
}

config.color_schemes = {
  ['Catppuccin Latte'] = catppuccin_latte,
  ['Catppuccin Macchiato'] = catppuccin_macchiato,
}


-- Appearance: Latte for light, Macchiato for dark. WezTerm reloads this file when
-- the system appearance changes. The mux server has no GUI, so fall back to Latte.
local function scheme_for_appearance(appearance)
  if appearance:find 'Dark' then
    return 'Catppuccin Macchiato'
  end
  return 'Catppuccin Latte'
end

local appearance = 'Light'
if wezterm.gui then
  appearance = wezterm.gui.get_appearance()
end
config.color_scheme = scheme_for_appearance(appearance)


-- Font: JetBrainsMono Nerd Font Mono, 12pt. Bold and italic follow the font.
config.font = wezterm.font 'JetBrainsMono Nerd Font Mono'
config.font_size = 12.0


-- Window: maximize at startup, full decorations, 1px padding, no tab bar for one tab.
config.window_decorations = 'TITLE | RESIZE'
config.window_padding = { left = 1, right = 1, top = 1, bottom = 1 }
config.window_close_confirmation = 'NeverPrompt'
config.adjust_window_size_when_changing_font_size = false
config.hide_tab_bar_if_only_one_tab = true

wezterm.on('gui-startup', function(cmd)
  local tab, pane, window = mux.spawn_window(cmd or {})
  window:gui_window():maximize()
end)


-- Cursor: blinking bar, pointer hides while typing.
config.default_cursor_style = 'BlinkingBar'
config.cursor_thickness = 2
config.hide_mouse_cursor_when_typing = true


-- Scrollback: 20000 lines, no scrollbar.
config.scrollback_lines = 20000
config.enable_scroll_bar = false


-- Bell: silent, like alacritty.
config.audible_bell = 'Disabled'


-- Keyboard: clipboard, font scaling, fullscreen. Same as alacritty, foot, and kitty.
config.keys = {
  { key = 'C', mods = 'CTRL|SHIFT', action = wezterm.action.CopyTo 'Clipboard' },
  { key = 'V', mods = 'CTRL|SHIFT', action = wezterm.action.PasteFrom 'Clipboard' },

  { key = '=', mods = 'CTRL|SHIFT', action = wezterm.action.IncreaseFontSize },
  { key = '+', mods = 'CTRL|SHIFT', action = wezterm.action.IncreaseFontSize },
  { key = '-', mods = 'CTRL|SHIFT', action = wezterm.action.DecreaseFontSize },
  { key = '0', mods = 'CTRL|SHIFT', action = wezterm.action.ResetFontSize },

  { key = 'F11', action = wezterm.action.ToggleFullScreen },
}

return config
