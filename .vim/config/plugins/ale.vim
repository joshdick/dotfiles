" Using <https://github.com/nvimtools/none-ls.nvim> in Neovim.
if has('nvim')
  finish
endif

packadd! ale

" In neovim, nvim-lspconfig is unnecessary unless
" non-ALE lanaugage servers that rely on it are explicitly configured.

let g:ale_fixers = {
      \'javascript': ['prettier'],
      \'json': ['prettier'],
      \'jsonc': ['prettier'],
      \'python': ['black', 'ruff'],
      \'typescript': ['prettier'],
      \'typescriptreact': ['prettier'],
      \}

let g:ale_linters = {
      \'python': ['pyright', 'mypy', 'ruff'],
      \}

let g:ale_floating_preview = 1
let g:ale_floating_window_border = ['│', '─', '╭', '╮', '╯', '╰', '│', '─']
let g:ale_fix_on_save = 1
let g:ale_virtualtext_cursor = 0

let g:ale_python_auto_poetry = 1
" let g:ale_python_auto_virtualenv = 1

nmap K <Plug>(ale_hover)
nmap gd <Plug>(ale_go_to_definition)
nmap <leader>rn <Plug>(ale_rename)

" augroup PythonRuffFixer
  " autocmd!
  " autocmd User ALEFixPre  let b:ale_python_ruff_options = '--select=I'
  " autocmd User ALEFixPost let b:ale_python_ruff_options = ''
" augroup END
