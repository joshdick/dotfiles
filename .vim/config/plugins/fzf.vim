if has('nvim')
  finish
endif

" junegunn/fzf.vim depends on junegunn/fzf, which is installed
" in the following location when using <https://github.com/joshdick/dotfiles>:
if isdirectory($HOME . "/.bin/repos/fzf")
  set rtp+=~/.bin/repos/fzf
else
  finish
endif

packadd! fzf.vim

nnoremap <leader>g :RG<CR>
nnoremap <leader>cg :exe ':RG ' . expand('<cword>')<CR>
noremap <C-p> :Files<CR>
nnoremap <C-b> :Buffers<CR>

let g:fzf_action = {
  \ 'ctrl-t': 'tab drop',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

if exists('$TMUX')
  let g:fzf_layout = { 'tmux': '-p90%,60%' }
else
  let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6 } }
endif
