if g:os != 'Darwin'
  finish
endif

packadd! dash.vim

nmap <silent> <leader>a <Plug>DashSearch
