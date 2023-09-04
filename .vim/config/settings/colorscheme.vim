if has('nvim') && empty($VIM_USE_ONEDARK)

"   packadd! tokyonight.nvim

" lua << EOF
  " require("tokyonight").setup({
    " style = "night",
    " styles = {
      " keywords = { italic = false }
    " },
    " on_colors = function(colors)
      " colors.gitSigns = { add = "#A8CD76", change = "#D8B172", delete = "#E77D8F" } 
    " end
  " })
  " vim.cmd[[colorscheme tokyonight]]
" EOF

  packadd! catppuccin_nvim

lua << EOF
  require("catppuccin").setup({
    transparent_background = true,
    integrations = {
      treesitter = true,
      native_lsp = {
        enabled = true,
      },
      lsp_trouble = true,
      gitgutter = true,
      telescope = true,
    },
    highlight_overrides = {
      all = function(colors)
          return {
              -- Undo https://github.com/catppuccin/nvim/pull/383/files
              TroubleNormal = { bg = colors.none },
              TroubleText = { fg = colors.subtext0 }
          }
      end,
    }
  })
  vim.g.catppuccin_flavour = "mocha" -- latte, frappe, macchiato, mocha
  vim.cmd[[colorscheme catppuccin]]
EOF

elseif empty($VIM_USE_ONEDARK)

  set termguicolors
  packadd! catppuccin_vim
  colorscheme catppuccin_mocha

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
