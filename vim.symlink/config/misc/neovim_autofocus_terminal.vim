" Found at <https://vi.stackexchange.com/questions/22307/neovim-go-into-insert-mode-when-clicking-in-a-terminal-in-a-pane/22327#22327>
if has('nvim')
    augroup terminal_setup | au!
        autocmd TermOpen * nnoremap <buffer><LeftRelease> <LeftRelease>i
    augroup end
endif

