"Drop-down Persistent Terminal for NeoVim {{{

"Found at <https://pastebin.com/FjdkegRH>

if has('nvim')

  function! ChooseTerm(termname, slider)
    let pane = bufwinnr(a:termname)
    let buf = bufexists(a:termname)
    if pane > 0
      " pane is visible
      if a:slider > 0
        :exe pane . "wincmd c"
      else
        :exe "e #"
      endif
    elseif buf > 0
      " buffer is not in pane
      if a:slider
        :exe "topleft split"
      endif
      :exe "buffer " . a:termname
    else
      " buffer is not loaded, create
      if a:slider
        :exe "topleft split"
      endif
      :terminal
      :exe "f " a:termname
    endif
  endfunction

  " Toggle 'default' terminal
  nnoremap <leader>t :call ChooseTerm("term-slider", 1)<CR>

  " Start terminal in current pane
  nnoremap <leader>T :call ChooseTerm("term-pane", 0)<CR>

endif
