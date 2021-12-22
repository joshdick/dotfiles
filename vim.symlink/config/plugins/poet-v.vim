" Enable poet-v if https://python-poetry.org `poetry` binary
" is available on $PATH
if executable('poetry')

  let g:poetv_executables = ['poetry']

  "Disable auto-activate and reimplement manually in order to restart LSP
  let g:poetv_auto_activate = 0

  packadd! poet-v

  function ActivatePoetv()
    let CURRENT_VIRTUAL_ENV = $VIRTUAL_ENV
    if &previewwindow != 1 && expand('%:p') !~# "/\\.git/"
      call poetv#activate()
      if CURRENT_VIRTUAL_ENV != $VIRTUAL_ENV
        silent exec "LspRestart"
      endif
    endif
  endfunction

  augroup poetv_autocmd
      autocmd!
      autocmd WinEnter,BufWinEnter *.py call ActivatePoetv()
  augroup END

endif
