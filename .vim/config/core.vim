" vim:fdm=marker

"Basic Settings {{{

set encoding=utf-8

"Work around https://github.com/vim/vim/issues/3117 < https://github.com/vim/vim/issues/3117#issuecomment-406853295 >
if has('python3') && !has('patch-8.1.201')
  silent! python3 1
endif

set autoindent
set nowrap
filetype plugin indent on
syntax on

set softtabstop=2
set tabstop=2
set shiftwidth=2

set backspace=2 "Allow backspace to work properly
set cursorline
set hidden "Allow more than one unsaved buffer
set list "Show invisible characters by default
set listchars=tab:→\ "This comment prevents trailing whitespace removal from removing the escaped space. :)
set mouse=a
set nobackup
set nowritebackup
set shortmess+=I "Disable splash screen/[I]ntro message
set switchbuf=usetab,newtab "If a buffer is already open in a window in any tab, switch to that tab/window < https://stackoverflow.com/a/3476411/278810 >

" command-line completion
" Settings found at: <https://www.reddit.com/r/vim/comments/oo9gms/any_way_to_get_vim_to_not_defaulting_to_the_first/>
set wildmode=longest:full,full
set wildmenu
set wildignore=*.o,*~
set wildignorecase

" TODO:
" https://github.com/thoughtbot/dotfiles/issues/655#issuecomment-605019271
" https://www.micahsmith.com/blog/2019/11/fixing-vim-invalid-argument-diffopt-iwhite/
if has('nvim-0.3.2') || has('patch-8.1.0360')
  set diffopt=filler,internal,algorithm:histogram,indent-heuristic
endif

"Line numbers
"< https://www.reddit.com/r/vim/comments/m736j3/how_do_people_move_vertically/grae7ak?context=3 >
set number relativenumber
augroup relnum_focus
    autocmd FocusLost,InsertEnter * setl norelativenumber
    autocmd FocusGained,InsertLeave * setl relativenumber
augroup END

"Note: By default, <leader> is backslash
let mapleader="\<Space>"
let maplocalleader="_"

if executable('rg')
  "< https://github.com/BurntSushi/ripgrep/issues/425#issuecomment-702244167 >
  set grepprg=rg\ --vimgrep\ --no-heading\ --smart-case\ --follow\ --no-ignore-vcs\ --hidden\ --glob\ '!node_modules'\ --glob\ '!.git'
  set grepformat=%f:%l:%c:%m,%f:%l:%m
endif

"Built-in extended '%' matching
runtime macros/matchit.vim

"}}}

"Statusline {{{

if exists('vimpager')
  set statusline=%<%F%h%m%r%h%w%y\ %{&ff}\ %{strftime(\"%c\",getftime(expand(\"%:p\")))}\ %=\ lin:%l\/%L\ col:%c%V\ %P
else
  set statusline=%<%F%h%m%r%h%w%y\ %{&ff}\ %{strftime(\"%c\",getftime(expand(\"%:p\")))}\ %{fugitive#statusline()}\ %=\ lin:%l\/%L\ col:%c%V\ %P
endif
set laststatus=2

"}}}

"Cursor Styling {{{

if !empty($ITERM_PROFILE) && !has('nvim') "We're running non-Neovim inside iterm2
  if empty($TMUX)
    "iTerm2 per <http://vim.wikia.com/wiki/Change_cursor_shape_in_different_modes>
    let &t_SI="\<Esc>]50;CursorShape=1\x7"
    let &t_SR="\<Esc>]50;CursorShape=2\x7"
    let &t_EI="\<Esc>]50;CursorShape=0\x7"
  else
    "tmux + iterm2 per <http://vim.wikia.com/wiki/Change_cursor_shape_in_different_modes>
    let &t_SI="\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
    let &t_SR="\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=2\x7\<Esc>\\"
    let &t_EI="\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
  endif
endif

"OS-Specific Settings {{{

"Fallback for detecting the OS
if !exists('g:os')
  if has('win32') || has('win16')
    let g:os = 'Windows'
  else
    let g:os = substitute(system('uname'), '\n', '', '')
  endif
endif

if has('gui') "Instead of gui_running, in case :gui is run manually on *NIX

  "Font settings
  set guifont=MonoLisa\ Light:h15
  set linespace=-3
  set antialias

  if g:os == 'Darwin'
    "set guioptions=egmrt "Hide toolbar by default in MacVim
    "if has('transparency') "Background transparency is a MacVim-specific feature, so prevent errors in other vims
      "set transparency=2 "Enable background transparency in MacVim
    "endif
    "Map CMD-[ and CMD-] to indent while preserving any Visual mode selection as appropriate
    nnoremap <D-[> <<
    nnoremap <D-]> >>
    xnoremap <D-[> <gv
    xnoremap <D-]> >gv
  endif

  "if g:os == 'Linux'
  "endif

  if g:os == 'Windows'
    "See :help behave
    behave mswin
    source $VIMRUNTIME/mswin.vim "Enable expected keyboard shortcuts for Windows
    set keymodel-=stopsel "Make Visual mode work as expected when mswin.vim is sourced
  endif

endif

"}}}

