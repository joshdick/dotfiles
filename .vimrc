"Vundle plugin and bundle initialization
set rtp+=~/.vim/vundle.git/
call vundle#rc()
"Git URL bundles
Bundle 'git://git.wincent.com/command-t.git'
"Github Bundles
Bundle 'tpope/vim-fugitive'
Bundle 'scrooloose/nerdcommenter.git'
Bundle 'scrooloose/nerdtree.git'
Bundle 'ervandew/supertab.git'
Bundle 'corntrace/bufexplorer.git'
Bundle 'tpope/vim-vividchalk'

"NOTE: This block was commented out in favor of 'set list'. Uncomment all
"executable lines in this block to restore tab/whitespace hilighting
"functionality.
"
"Whitespace matching: must appear before the colorscheme is set
"SUMMARY OF BEHAVIOR:
" 1) Apply to all buffers.
" 2) Match all tab characters at all times.
" 3) Inside insert mode, don't match trailing whitespace on the current line.
" 4) Outside insert mode, match all trailing whitespace on the current line.
"highlight ExtraWhitespace ctermbg=red guibg=red
"match ExtraWhitespace /\t\|\s\+$/
"if has("autocmd")
"  autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red
"  autocmd BufWinEnter * match ExtraWhitespace /\t\|\s\+$/
"  autocmd InsertEnter * match ExtraWhitespace /\t\|\s\+\%#\@<!$/
"  autocmd InsertLeave * match ExtraWhitespace /\t\|\s\+$/
"  autocmd BufWinLeave * call clearmatches()
"endif

if has("gui") "Instead of gui_running, in cease :gui is run manually on *NIX
  set columns=90 lines=45
  "Set the font based on OS.
  if has("unix")
    "set guifont=Terminus:h13
    set guifont=Monaco:h10
    set linespace=-1
    set noantialias
  else
    "set guifont=Tamsyn7x14
    set guifont=Terminus:h12
    source $VIMRUNTIME/mswin.vim "Enable expected keyboard shortcuts for Windows - see :help :behave
    set keymodel-=stopsel "Make Visual mode work as expected when mswin.vim is sourced
  endif
  set guioptions=egmrt "Hide toolbar by default in MacVim
  if has("transparency") "Background transparency is a MacVim-specific feature, so prevent errors in other vims
    set transparency=5 "Enable background transparency in MacVim
  endif
endif

"Disable splash screen/[I]ntro message
set shortmess+=I

colorscheme wombat256
set number
set nobackup
set nowritebackup
set background=dark
"set list "Show invisible characters by default

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
filetype plugin on
filetype indent on "Enable automatic indentation based on detected filetype
syntax on

"Statusline
if exists("vimpager")
  set statusline=%<%F%h%m%r%h%w%y\ %{&ff}\ %{strftime(\"%c\",getftime(expand(\"%:p\")))}\ %=\ lin:%l\/%L\ col:%c%V\ %P
else
  set statusline=%<%F%h%m%r%h%w%y\ %{&ff}\ %{strftime(\"%c\",getftime(expand(\"%:p\")))}\ %{fugitive#statusline()}\ %=\ lin:%l\/%L\ col:%c%V\ %P
endif
set laststatus=2

"Invisible (list) character colors
"highlight NonText guifg=#555555 "EOL
"highlight SpecialKey guifg=#555555 "Tab

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

"Shortcut to toggle NERDTree
nmap <leader>e :NERDTreeToggle<CR>

"Shortcut to strip trailing whitespace
nmap <silent> <leader>$ :call Preserve("%s/\\s\\+$//e")<CR>

"Shortcut to auto-indent entire file
nmap <silent> <leader>= :call Preserve("normal gg=G")<CR>

"Shortcut to toggle auto-indenting for code paste
"Found here: http://vim.wikia.com/wiki/Toggle_auto-indenting_for_code_paste
nnoremap <F2> :set invpaste paste?<CR>
set pastetoggle=<F2>
set showmode

"Shortcut to toggle line number visibility
nmap <F3> :set number! number?<CR>

"Shorcut to toggle search hilighting
"Found here: http://vim.wikia.com/wiki/Highlight_all_search_pattern_matches
noremap <F4> :set hlsearch! hlsearch?<CR>
