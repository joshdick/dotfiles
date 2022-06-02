if has('nvim')

  packadd! tokyonight.nvim

  let g:tokyonight_style="night"
  let g:tokyonight_italic_keywords="false"
  let g:tokyonight_colors = { "gitSigns": { "add": "#A8CD76", "change": "#D8B172", "delete": "#E77D8F" } }
  colorscheme tokyonight

else

  packadd! onedark.vim

  let g:onedark_termcolors=16
  let g:onedark_terminal_italics=1
  "let g:onedark_hide_endofbuffer=1
  colorscheme onedark

endif
