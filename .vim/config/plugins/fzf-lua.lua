vim.cmd [[packadd fzf-lua]]

require("fzf-lua").setup {
  "fzf-native"
  -- hls = { border = "FloatBorder" }
}

--nnoremap <leader>g <cmd>Telescope live_grep<CR>
vim.keymap.set("n", "<leader>g",
  "<cmd>lua require('fzf-lua').live_grep()<CR>", { silent = true })

--nnoremap <leader>cg :lua require('telescope.builtin').grep_string({ search = vim.fn.expand('<cword>')})<CR>

--noremap <C-p> <cmd>Telescope find_files<CR>
-- https://github.com/ibhagwan/fzf-lua/issues/881
vim.keymap.set("n", "<C-p>",
  "<cmd>lua require('fzf-lua').files({ fzf_opts = { ['--keep-right'] = '' } })<CR>", { silent = true })

--noremap <C-b> <cmd>Telescope buffers<CR>
vim.keymap.set("n", "<C-b>",
  "<cmd>lua require('fzf-lua').buffers({ fzf_opts = { ['--keep-right'] = '' } })<CR>", { silent = true })

