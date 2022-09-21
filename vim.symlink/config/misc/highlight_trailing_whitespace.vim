"Adapted from <http://vim.wikia.com/wiki/Highlight_unwanted_spaces>
" * Inside insert mode, don't match trailing whitespace on the current line.
" * Outside insert mode, match all trailing whitespace on the current line.
let ExtraWhitespace_cterm = synIDattr(synIDtrans(hlID('Error')), 'fg', 'cterm') || 'red'
let ExtraWhitespace_gui = synIDattr(synIDtrans(hlID('Error')), 'fg', 'gui')
exe 'highlight ExtraWhitespace ctermbg=' . ExtraWhitespace_cterm . ' guibg=' . ExtraWhitespace_gui
match ExtraWhitespace /\s\+$/
if has('autocmd')
  augroup whitespace_highlighting
    autocmd!
    autocmd ColorScheme * let ExtraWhitespace_cterm = synIDattr(synIDtrans(hlID('Error')), 'fg', 'cterm') || 'red'
    autocmd ColorScheme * let ExtraWhitespace_gui = synIDattr(synIDtrans(hlID('Error')), 'fg', 'gui')
    autocmd ColorScheme * exe 'highlight ExtraWhitespace ctermbg=' . ExtraWhitespace_cterm . ' guibg=' . ExtraWhitespace_gui
    autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
    autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
    autocmd InsertLeave * match ExtraWhitespace /\s\+$/
    autocmd BufWinLeave * call clearmatches()
  augroup END
endif
