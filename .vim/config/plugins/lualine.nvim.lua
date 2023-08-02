vim.cmd [[packadd lualine.nvim]]

local theme = vim.env.VIM_USE_ONEDARK == nil and 'catppuccin' or 'onedark'

require('lualine').setup({
    options = {
      icons_enabled = true,
      theme = theme,
      component_separators = { '', ' ' },
      section_separators = { '', '' },
    },
    sections = {
      lualine_a = { 'mode' },
      lualine_b = { 'branch' },
      lualine_c = { 'filename' },
      lualine_x = {
        {
          'diagnostics',
          sources = { 'nvim_diagnostic' },
          symbols = {
            error = '🅴 ',
            warn = '🆆 ',
            hint = '🅷 ',
            info = '🅸 '
          },
          sections = { 'error', 'warn', 'info', 'hint' },
        },
        'progress',
      },
      lualine_y = { 'filetype' },
      lualine_z = { 'location' }
    }
  })
