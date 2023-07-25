if has('nvim') && empty($VIM_USE_ONEDARK)
  "let s:colorscheme = 'tokyonight'
  finish
elseif empty($VIM_USE_ONEDARK)
  let s:colorscheme = 'catppuccin_mocha'
else
  let s:colorscheme = 'onedark'
endif

packadd! lightline.vim

set noshowmode

let g:lightline = {
  \ 'colorscheme': s:colorscheme,
  \ 'active': {
  \   'left': [ [ 'mode', 'paste' ], [ 'fugitive', 'filename' ] ],
  \   'right': [ [ 'lineinfo' ], ['percent'], [ 'fileformat', 'fileencoding', 'filetype' ] ]
  \ },
  \ 'component_function': {
  \   'fugitive': 'LightlineFugitive',
  \   'filename': 'LightlineFilename',
  \   'fileformat': 'LightlineFileformat',
  \   'filetype': 'LightlineFiletype',
  \   'fileencoding': 'LightlineFileencoding',
  \   'mode': 'LightlineMode',
  \ },
  \ 'separator': { 'left': '', 'right': '' },
  \ 'subseparator': { 'left': '', 'right': '' }
  \ }

function! LightlineModified()
  return &ft =~ 'help' ? '' : &modified ? '+' : &modifiable ? '' : '-'
endfunction

function! LightlineReadonly()
  return &ft !~? 'help' && &readonly ? 'RO' : ''
endfunction

function! LightlineFilename()
  let fname = expand('%:t')
  return fname == '__Tagbar__' ? g:lightline.fname :
    \ fname =~ '__Gundo' ? '' :
    \ &ft == 'vimfiler' ? vimfiler#get_status_string() :
    \ &ft == 'unite' ? unite#get_status_string() :
    \ &ft == 'vimshell' ? vimshell#get_status_string() :
    \ ('' != LightlineReadonly() ? LightlineReadonly() . ' ' : '') .
    \ ('' != fname ? fname : '[No Name]') .
    \ ('' != LightlineModified() ? ' ' . LightlineModified() : '')
endfunction

function! LightlineFugitive()
  try
    if expand('%:t') !~? 'Tagbar\|Gundo\|NERD' && &ft !~? 'vimfiler' && exists('*fugitive#head')
      let mark = ' '
      let branch = fugitive#head()
      return branch !=# '' ? mark.branch : ''
    endif
  catch
  endtry
  return ''
endfunction

function! LightlineFileformat()
  return winwidth(0) > 70 ? &fileformat : ''
endfunction

function! LightlineFiletype()
  return winwidth(0) > 70 ? (&filetype !=# '' ? &filetype : 'no ft') : ''
endfunction

function! LightlineFileencoding()
  return winwidth(0) > 70 ? (&fenc !=# '' ? &fenc : &enc) : ''
endfunction

function! LightlineMode()
  let fname = expand('%:t')
  return fname == '__Tagbar__' ? 'Tagbar' :
    \ fname == '__Gundo__' ? 'Gundo' :
    \ fname == '__Gundo_Preview__' ? 'Gundo Preview' :
    \ fname =~ 'NetrwTreeListing' ? 'Tree Listing' :
    \ &ft == 'unite' ? 'Unite' :
    \ &ft == 'vimfiler' ? 'VimFiler' :
    \ &ft == 'vimshell' ? 'VimShell' :
    \ winwidth(0) > 60 ? lightline#mode() : ''
endfunction

let g:tagbar_status_func = 'TagbarStatusFunc'

function! TagbarStatusFunc(current, sort, fname, ...) abort
    let g:lightline.fname = a:fname
  return lightline#statusline(0)
endfunction

let g:unite_force_overwrite_statusline = 0
let g:vimfiler_force_overwrite_statusline = 0
let g:vimshell_force_overwrite_statusline = 0

" Show the current working directory in tab names.
" Per <https://github.com/itchyny/lightline.vim/issues/245>
function! CustomTabname(n) abort
  return fnamemodify(getcwd(tabpagewinnr(a:n), a:n), ':t')
endfunction

let g:lightline.tab_component_function = {
  \ 'custom_tabname': 'CustomTabname',
  \ 'modified': 'lightline#tab#modified',
  \ 'readonly': 'lightline#tab#readonly',
  \ 'tabnum': 'lightline#tab#tabnum'
  \ }

let g:lightline.tab = {
  \ 'active': [ 'tabnum', 'custom_tabname', 'modified' ],
  \ 'inactive': [ 'tabnum', 'custom_tabname', 'modified' ] }

let g:lightline.tabline_separator = { 'left': '', 'right': '' }
let g:lightline.tabline_subseparator = { 'left': '‖', 'right': '‖' }

let g:lightline.mode_map = {
  \ 'n' : '🅝',
  \ 'i' : '🅘',
  \ 'R' : '🅡',
  \ 'v' : '🅥',
  \ 'V' : '🅥 🅛',
  \ "\<C-v>": '🅥 🅑',
  \ 'c' : '🅒',
  \ 's' : '🅢',
  \ 'S' : '🅢 🅛',
  \ "\<C-s>": '🅢 🅑',
  \ 't': '🅣',
  \ }
