"Adapted from <http://vim.wikia.com/wiki/Highlight_unwanted_spaces>
" * Inside insert mode, don't match trailing whitespace on the current line.
" * Outside insert mode, match all trailing whitespace on the current line.
let ExtraWhitespace_cterm = synIDattr(synIDtrans(hlID('Error')), 'fg', 'cterm') || 'red'
let ExtraWhitespace_gui = synIDattr(synIDtrans(hlID('Error')), 'fg', 'gui')
exe 'highlight ExtraWhitespace ctermbg=' . ExtraWhitespace_cterm . ' guibg=' . ExtraWhitespace_gui
if empty(&bt) | match ExtraWhitespace /\s\+$/ | endif
if has('autocmd')
  augroup whitespace_highlighting
    autocmd!
    autocmd ColorScheme * let ExtraWhitespace_cterm = synIDattr(synIDtrans(hlID('Error')), 'fg', 'cterm') || 'red'
    autocmd ColorScheme * let ExtraWhitespace_gui = synIDattr(synIDtrans(hlID('Error')), 'fg', 'gui')
    " autocmd ColorScheme * exe 'highlight ExtraWhitespace ctermbg=' . ExtraWhitespace_cterm . ' guibg=' . ExtraWhitespace_gui
    " autocmd BufWinEnter * if empty(&bt) | match ExtraWhitespace /\s\+$/ | endif
    autocmd InsertEnter * if empty(&bt) | match ExtraWhitespace /\s\+\%#\@<!$/ | endif
    autocmd InsertLeave * if empty(&bt) | match ExtraWhitespace /\s\+$/ | endif
    autocmd BufWinLeave * call clearmatches()
  augroup END
endif
