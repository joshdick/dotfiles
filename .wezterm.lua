local wezterm = require 'wezterm'
local wt_act = wezterm.action

local custom_mocha = wezterm.color.get_builtin_schemes()['Catppuccin Mocha']
-- Overrides with alternate colors from the official Catppuccin Mocha PNG palette:
-- https://github.com/catppuccin/palette/blob/main/png/catppuccin-mocha.png
custom_mocha.ansi[2] = '#E590A8'
custom_mocha.ansi[6] = '#C5A7F2'
custom_mocha.ansi[7] = '#88CFE8'

return {

  color_schemes = {
    ['Custom Mocha'] = custom_mocha,
  },
  color_scheme = 'Custom Mocha',

  font = wezterm.font {
    family = 'MonoLisa Josh',
    weight = 'Light',
    harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' },
  },
  font_size = 16,
  -- cell_width = .9,

  window_frame = {
    font = wezterm.font {
      family = 'MonoLisa Josh',
      weight = 'Light'
    },
    font_size = 14.75,
    active_titlebar_bg = '#111120',
    inactive_titlebar_bg = '#111120',
  },

  use_resize_increments = true,
  pane_focus_follows_mouse = true,
  enable_scroll_bar = true,

  keys = {
    {
      key = 'D',
      mods = 'SUPER',
      action = wt_act.SplitVertical { domain = 'CurrentPaneDomain' },
    },
    {
      key = 'd',
      mods = 'SUPER',
      action = wt_act.SplitHorizontal { domain = 'CurrentPaneDomain' },
    },
    -- Rebind OPT-Left, OPT-Right as ALT-b, ALT-f respectively to match Terminal.app behavior
    -- https://wezfurlong.org/wezterm/config/lua/keyassignment/SendKey.html
    {
      key = 'LeftArrow',
      mods = 'OPT',
      action = wt_act.SendKey { key = 'b', mods = 'ALT' },
    },
    {
      key = 'RightArrow',
      mods = 'OPT',
      action = wt_act.SendKey { key = 'f', mods = 'ALT' },
    }
   },

  colors = {
    -- 15% darker than stock ( https://mdigi.tools/darken-color/#1E1E2E )
    background = '#191927',

    cursor_bg = '#C1CCF1',
    cursor_border = '#C1CCF1',

    tab_bar = {
      inactive_tab_edge = '#575757',

      active_tab = {
        bg_color = '#191927',
        fg_color = '#C0C0C0',
      },

      inactive_tab = {
        bg_color = '#0E0E1B',
        fg_color = '#808080',
      },

      inactive_tab_hover = {
        bg_color = '#292938',
        fg_color = '#7A7A7A',
      }

    },

  }

}
