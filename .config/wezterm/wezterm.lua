-- WezTerm — Eye Care theme. Follows the system light/dark appearance.

local wezterm = require 'wezterm'
local mux = wezterm.mux
local config = wezterm.config_builder()


-- Palette: same ANSI colors as kitty, ghostty, alacritty, and foot.
local eye_care_day = {
  foreground = '#4c4f69',
  background = '#e6ead2',
  cursor_bg = '#4c4f69',
  cursor_fg = '#e6ead2',
  cursor_border = '#4c4f69',
  selection_fg = '#4c4f69',
  selection_bg = '#d8d0b4',
  scrollbar_thumb = '#a89984',
  split = '#446e78',
  ansi = {
    '#3c3836', -- black
    '#b14444', -- red
    '#626d2a', -- green
    '#935c07', -- yellow
    '#446e78', -- blue
    '#8c5879', -- magenta
    '#467156', -- cyan
    '#4c4f69', -- white
  },
  brights = {
    '#665c54', -- black
    '#9c5353', -- red
    '#5e6e36', -- green
    '#886120', -- yellow
    '#456f6f', -- blue
    '#825d76', -- magenta
    '#47715d', -- cyan
    '#4c4f69', -- white
  },
}

local eye_care_night = {
  foreground = '#d5dae2',
  background = '#1d2021',
  cursor_bg = '#a89984',
  cursor_fg = '#1d2021',
  cursor_border = '#a89984',
  selection_fg = '#d5dae2',
  selection_bg = '#665c54',
  scrollbar_thumb = '#665c54',
  split = '#7daea3',
  ansi = {
    '#3c3836', -- black
    '#ea6962', -- red
    '#a9b665', -- green
    '#e09853', -- yellow
    '#7daea3', -- blue
    '#d3869b', -- magenta
    '#89b482', -- cyan
    '#d5dae2', -- white
  },
  brights = {
    '#7c6f64', -- black
    '#fcbfaf', -- red
    '#c3d282', -- green
    '#eee0b7', -- yellow
    '#a0c8be', -- blue
    '#f0b4af', -- magenta
    '#a5cd9e', -- cyan
    '#eee0b7', -- white
  },
}

config.color_schemes = {
  ['Eye Care Day'] = eye_care_day,
  ['Eye Care Night'] = eye_care_night,
}


-- Appearance: Day for light, Night for dark. WezTerm reloads this file when the
-- system appearance changes. The mux server has no GUI, so fall back to Day.
local function scheme_for_appearance(appearance)
  if appearance:find 'Dark' then
    return 'Eye Care Night'
  end
  return 'Eye Care Day'
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
