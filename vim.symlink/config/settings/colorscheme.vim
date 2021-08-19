if has("nvim")

  packadd! tokyonight.nvim

  let g:tokyonight_style = "night"
  colorscheme tokyonight

else

  packadd! onedark.vim

  let g:onedark_termcolors=16
  let g:onedark_terminal_italics=1
  "let g:onedark_hide_endofbuffer=1
  colorscheme onedark

endif
