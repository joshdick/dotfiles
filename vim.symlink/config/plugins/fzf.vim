"junegunn/fzf.vim depends on junegunn/fzf, which is installed
"in the following location when using <https://github.com/joshdick/dotfiles>:
if isdirectory($HOME . "/.bin/repos/fzf")
  set rtp+=~/.bin/repos/fzf
endif

cnoreabbrev rg Rg
nnoremap <Leader>r :Rg<Space>
nnoremap <Leader>gs:exe ':Rg ' . expand("<cword>")<CR>
noremap <C-p> :Files<CR>
