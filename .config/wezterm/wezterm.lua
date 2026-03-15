-- =============================================================================
-- WEZTERM TERMINAL CONFIGURATION
-- =============================================================================
-- Theme: Catppuccin Mocha
-- Font: IntoneMono Nerd Font
-- Unified with: foot, kitty, alacritty, ghostty

local wezterm = require 'wezterm'
local act = wezterm.action

local config = {}

-- =============================================================================
-- THEME
-- =============================================================================

config.color_scheme = 'Catppuccin Mocha'


-- =============================================================================
-- FONTS
-- =============================================================================

config.font = wezterm.font('IntoneMono Nerd Font')
config.font_size = 12


-- =============================================================================
-- WINDOW
-- =============================================================================

config.window_decorations = "None"
config.window_padding = { left = 1, right = 1, top = 1, bottom = 1 }


-- =============================================================================
-- CURSOR
-- =============================================================================

config.default_cursor_style = 'Beam'
config.cursor_blink_rate = 0


-- =============================================================================
-- SCROLLBACK
-- =============================================================================

config.scrollback_lines = 20000


-- =============================================================================
-- MOUSE
-- =============================================================================

config.hide_mouse_when_typing = true


-- =============================================================================
-- KEYBINDINGS
-- =============================================================================

config.keys = {
  -- Clipboard
  { key = 'C', mods = 'CTRL|SHIFT', action = act.CopyTo 'Clipboard' },
  { key = 'V', mods = 'CTRL|SHIFT', action = act.PasteFrom 'Clipboard' },

  -- Font Scaling
  { key = 'Plus',  mods = 'CTRL|SHIFT', action = act.IncreaseFontSize },
  { key = 'Minus', mods = 'CTRL|SHIFT', action = act.DecreaseFontSize },
  { key = '0',     mods = 'CTRL|SHIFT', action = act.ResetFontSize },

  -- Fullscreen
  { key = 'F11', mods = 'NONE', action = act.ToggleFullScreen },
}


return config
