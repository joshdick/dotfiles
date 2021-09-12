if has('nvim')
  finish
endif

" junegunn/fzf.vim depends on junegunn/fzf, which is installed
" in the following location when using <https://github.com/joshdick/dotfiles>:
if isdirectory($HOME . "/.bin/repos/fzf")
  set rtp+=~/.bin/repos/fzf
endif

" Modified from example from `:h fzf-vim-example-advanced-ripgrep-integration`
function! RipgrepFzf(query, fullscreen)
  let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case -- %s || true'
  " Silghtly modified from example; don't do an initial Ripgrep search
  " if the query is empty (:RG is invoked with no arguments.)
  " Mimics Telescope's live_grep.
  let initial_command = len(a:query) == 0 ? 'true' : printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction

command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)

nnoremap <leader>g :RG<CR>
nnoremap <leader>cg :exe ':RG ' . expand('<cword>')<CR>
noremap <C-p> :Files<CR>
nnoremap <C-b> :Buffers<CR>

let g:fzf_action = {
  \ 'ctrl-t': 'tab drop',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

