" Enable poet-v if https://python-poetry.org `poetry` binary
" is available on $PATH
if executable('poetry')

  let g:poetv_executables = ['poetry']

  packadd! poet-v

endif
