if has('nvim')

  packadd! plenary.nvim
  packadd! telescope.nvim

  nnoremap <leader>g <cmd>Telescope live_grep<CR>
  nnoremap <leader>cg :lua require('telescope.builtin').grep_string({ search = vim.fn.expand('<cword>')})<CR>
  noremap <C-p> <cmd>Telescope find_files<CR>
  noremap <C-b> <cmd>Telescope buffers<CR>

endif
