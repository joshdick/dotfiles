"Adapted from <http://inlehmansterms.net/2014/09/04/sane-vim-working-directories/>

" If in a Git repo, sets the working directory to its root,
" or if not, to the directory of the current file.
function! SetWorkingDirectory()
  " Skip URI-scheme buffers (e.g., fugitive://, zipfile://, scp://)
  if expand('%') =~# '^\w\+://'
    return
  endif

  " Default to the current file's directory (resolving symlinks.)
  let current_file = expand('%:p')
  if getftype(current_file) == 'link'
    let current_file = resolve(current_file)
  endif
  exe 'lcd' . fnamemodify(current_file, ':h')

  " Get the path to `.git` if we're inside a Git repo.
  " Works both when inside a worktree, or inside an internal `.git` folder.
  :silent let git_dir = system('git rev-parse --git-dir')[:-2]
  " Check whether the command output starts with 'fatal'; if it does, we're not inside a Git repo.
  let is_not_git_dir = matchstr(git_dir, '^fatal:.*')
  " If we're inside a Git repo, change the working directory to its root.
  if empty(is_not_git_dir)
    " Expand path -> Remove trailing slash -> Remove trailing `.git`.
    exe 'lcd' . fnamemodify(git_dir, ':p:h:h')
  endif
endfunction

if has('autocmd')
  augroup working_directory
    autocmd!
    autocmd BufRead * call SetWorkingDirectory()
  augroup END
endif
