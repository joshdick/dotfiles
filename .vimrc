"Whitespace matching: must appear before the colorscheme is set
"SUMMARY OF BEHAVIOR:
" 1) Apply to all buffers.
" 2) Match all tab characters at all times.
" 3) Inside insert mode, don't match trailing whitespace on the current line.
" 4) Outside insert mode, match all trailing whitespace on the current line.
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\t\|\s\+$/
if has("autocmd")
  autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red
  autocmd BufWinEnter * match ExtraWhitespace /\t\|\s\+$/
  autocmd InsertEnter * match ExtraWhitespace /\t\|\s\+\%#\@<!$/
  autocmd InsertLeave * match ExtraWhitespace /\t\|\s\+$/
  autocmd BufWinLeave * call clearmatches()
endif

if has("gui_running")
  set columns=90 lines=45
  set guifont=Terminus:h13
  set guioptions=egmrt "Hide toolbar by default in MacVim
  if has("transparency") "Background transparency is a MacVim-specific feature, so prevent errors in other vims
    set transparency=5 "Enable background transparency in MacVim
  endif
endif

colorscheme herald
set number
set nobackup
set nowritebackup
set background=dark

set softtabstop=2
set tabstop=2
set shiftwidth=2
set expandtab

set bs=2 "Allow backspace to work properly
set autoindent
set smartindent
set enc=utf-8
set nowrap
hi LineNr guifg=#333333
filetype on
filetype indent on "Enable automatic indentation based on detected filetype
syntax on

"Invisible character colors
highlight NonText guifg=#333333
highlight SpecialKey guifg=#333333

"On Mac, map CMD-[ and CMD-] to indent while preserving any Visual mode selection as appropriate
nmap <D-[> <<
nmap <D-]> >>
vmap <D-[> <gv
vmap <D-]> >gv

":w!! will use sudo to save a non-writable file if you forgot to do 'sudo vim' by accident
cmap w!! %!sudo tee > /dev/null %

"Use the same symbols as TextMate for tabstops and EOLs
set listchars=tab:▸\ ,eol:¬

"Function to run arbitrary commands while preserving state.
"Found here: http://technotales.wordpress.com/2010/03/31/preserve-a-vim-function-that-keeps-your-state/
function! Preserve(command)
  "Preparation: save last search, and cursor position.
  let _s=@/
  let l = line(".")
  let c = col(".")
  "Do the business:
  execute a:command
  "Clean up: restore previous search history, and cursor position
  let @/=_s
  call cursor(l, c)
endfunction

"Shortcut to rapidly toggle 'set list' (Toggles invisible characters. By default, <leader> is backslash.)
nmap <leader>l :set list!<CR>

"Shortcut to strip trailing whitespace
nmap <silent> <leader>$ :call Preserve("%s/\\s\\+$//e")<CR>

"Shortcut to autoindent entire file
nmap <silent> <leader>= :call Preserve("normal gg=G")<CR>

"Shortcut to toggle auto-intenting for code paste
"Found here: http://vim.wikia.com/wiki/Toggle_auto-indenting_for_code_paste
nnoremap <F2> :set invpaste paste?<CR>
set pastetoggle=<F2>
set showmode

"Shortcut to toggle line number visibility
nmap <F3> :set number! number?<cr>
