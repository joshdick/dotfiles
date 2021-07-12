"junegunn/fzf.vim depends on junegunn/fzf, which is installed
"in the following location when using <https://github.com/joshdick/dotfiles>:
if isdirectory($HOME . "/.bin/repos/fzf")
  set rtp+=~/.bin/repos/fzf
endif

cnoreabbrev rg Rg
nnoremap <leader>rg :Rg<Space>
nnoremap <leader>gs :exe ':Rg ' . expand("<cword>")<CR>
noremap <C-p> :Files<CR>

let g:fzf_action = {
  \ 'ctrl-t': 'tab drop',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }
