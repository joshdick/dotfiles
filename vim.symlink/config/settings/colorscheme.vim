if has('nvim') && empty($VIM_USE_ONEDARK)

  " packadd! tokyonight.nvim
  " let g:tokyonight_style="night"
  " let g:tokyonight_italic_keywords="false"
  " let g:tokyonight_colors = { "gitSigns": { "add": "#A8CD76", "change": "#D8B172", "delete": "#E77D8F" } }
  " colorscheme tokyonight

  packadd! catppuccin

lua << EOF
  local catppuccin = require("catppuccin")

  catppuccin.setup({
    integrations = {
      treesitter = true,
      native_lsp = {
        enabled = true,
      },
      lsp_trouble = true,
      gitgutter = true,
      telescope = true,
    }
  })
  vim.g.catppuccin_flavour = "mocha" -- latte, frappe, macchiato, mocha
  vim.cmd[[colorscheme catppuccin]]
EOF

else
  packadd! onedark.vim

  set termguicolors

  " onedark.vim override: Don't set a background color when running in a terminal;
  " just use the terminal's background color
  " `gui` is the hex color code used in GUI mode/nvim true-color mode
  " `cterm` is the color code used in 256-color mode
  " `cterm16` is the color code used in 16-color mode
  if (has("autocmd") && !has("gui_running"))
    augroup colorset
      autocmd!
      let s:white = { "gui": "#ABB2BF", "cterm": "145", "cterm16" : "7" }
      autocmd ColorScheme * call onedark#set_highlight("Normal", { "fg": s:white }) " `bg` will not be styled since there is no `bg` setting
    augroup END
  endif

  let g:onedark_termcolors=16
  let g:onedark_terminal_italics=1
  "let g:onedark_hide_endofbuffer=1
  colorscheme onedark

endif
