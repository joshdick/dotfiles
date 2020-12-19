packadd! onedark.vim

"Use 24-bit (true-color) mode.
"More information about true-color mode in tmux:
"* http://sunaku.github.io/tmux-24bit-color.html#usage
"* https://github.com/tmux/tmux/issues/34
if (has("nvim"))
  "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
  let $NVIM_TUI_ENABLE_TRUE_COLOR=1
endif
"For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
"Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
if (has("termguicolors"))
  if !empty($TMUX)
    "Set Vim-specific sequences for RGB colors; only seems to be needed for Vim 8 running inside tmux with $TERM=tmux
    "Found at < https://github.com/vim/vim/issues/993#issuecomment-255651605 >
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  endif
  set termguicolors
endif

"onedark.vim override: Don't set a background color when running in a terminal;
"just use the terminal's background color
if (has("autocmd") && !has("gui_running"))
  augroup colors
    autocmd!
    let s:white = { "gui": "#ABB2BF", "cterm": "145", "cterm16": "7"}
    autocmd ColorScheme * call onedark#set_highlight("Normal", { "fg": s:white }) "No `bg` setting
  augroup END
endif

"Match background color of material-theme-palenight-2-1 terminal theme
let g:onedark_color_overrides = {
\ "black": {"gui": "#141828", "cterm": "235", "cterm16": "0" },
\}

let g:onedark_termcolors=16
let g:onedark_terminal_italics=1
let g:onedark_hide_endofbuffer=1
colorscheme onedark
