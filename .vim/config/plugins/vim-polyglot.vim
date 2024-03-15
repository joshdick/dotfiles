if has('nvim')
  " Prefer treesitter in Neovim.
  " Polyglot runs `syntax enable` which is incompatible with treesitter:
  " https://github.com/nvim-treesitter/nvim-treesitter/issues/5896#issuecomment-1910818227
  finish
endif

packadd! vim-polyglot
