"Mapping to reload Vim configuration
nnoremap <Leader>VR :source $MYVIMRC<CR>

"Mapping to select the last-changed text
noremap gV `[v`]

"Mapping to toggle netrw
noremap <silent> <leader>e :Lexplore<CR>

"Mapping to toggle search hilighting
"Found at <http://vim.wikia.com/wiki/Highlight_all_search_pattern_matches>
noremap <leader>h :set hlsearch! hlsearch?<CR>

inoremap ;; <Esc>

"Mapping that uses sudo to save a non-writable file when accidentally forgetting to start vim as root
cnoremap w!! %!sudo tee > /dev/null %

"Mappings for opening new splits
"Found at <http://technotales.wordpress.com/2010/04/29/vim-splits-a-guide-to-doing-exactly-what-you-want/>
"Window
nnoremap <leader>sw<left>  :topleft  vnew<CR>
nnoremap <leader>sw<right> :botright vnew<CR>
nnoremap <leader>sw<up>    :topleft  new<CR>
nnoremap <leader>sw<down>  :botright new<CR>
"Buffer
nnoremap <leader>s<left>   :leftabove  vnew<CR>
nnoremap <leader>s<right>  :rightbelow vnew<CR>
nnoremap <leader>s<up>     :leftabove  new<CR>
nnoremap <leader>s<down>   :rightbelow new<CR>

"Mappings for manipulating window focus
nnoremap <leader><left> <c-w>h<CR>
nnoremap <leader><down> <c-w>j<CR>
nnoremap <leader><up> <c-w>k<CR>
nnoremap <leader><right> <c-w>l<CR>

"Mappings for switching tabs
nnoremap <c-h> :tabprevious<CR>
nnoremap <c-l> :tabnext<CR>

"Mappings for interacting with the system clipboard
"Found at <http://sheerun.net/2014/03/21/how-to-boost-your-vim-productivity/>
xnoremap <leader>y "+y
xnoremap <leader>d "+d
nnoremap <leader>p "+p
nnoremap <leader>P "+P
xnoremap <leader>p "+p
xnoremap <leader>P "+P

"Mapping to show buffer search
nnoremap <leader>b :Buffers<CR>

"Mapping to convert mixed line endings to LF-only (Unix)
nnoremap <leader>d :call ForceLF()<CR>

"Mapping to toggle 'set list' (toggles invisible characters)
nnoremap <leader>l :set list!<CR>

"Mapping to toggle line numbers
nnoremap <leader>n :set number! number?<CR>

"Mapping to close a window
nnoremap <leader>q :close<CR>

"Mapping to toggle undotree
nnoremap <leader>u :UndotreeToggle<CR>

"Mapping to toggle auto-indenting for code paste
"Don't bother with pastetoggle, since it doesn't cooperate with vim-airline: <https://github.com/bling/vim-airline/issues/219>
nnoremap <leader>v :set invpaste<CR>

"Mapping for saving
nnoremap <leader>w :w<CR>

"Mapping that deletes a buffer without closing its window
"Found at <https://stackoverflow.com/questions/1444322/how-can-i-close-a-buffer-without-closing-the-window#comment16482171_5179609>
nnoremap <silent> <leader>x :ene<CR>:bd #<CR>

"Mapping to strip trailing whitespace
nnoremap <silent> <leader>$ :call Preserve("%s/\\s\\+$//e")<CR>

"Mapping to auto-indent entire file
nnoremap <silent> <leader>= :call Preserve("normal gg=G")<CR>

"Mapping to sort words inside a single line
"Found at <http://stackoverflow.com/a/1329899/278810>
xnoremap <leader>, d:execute 'normal a' . join(sort(split(getreg('"'))), ' ')<CR>

"Mapping for adding JavaScript console logs
nnoremap <leader>l a console.log('');<ESC>hhi
