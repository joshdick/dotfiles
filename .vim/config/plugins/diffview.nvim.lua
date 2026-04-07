vim.cmd [[packadd diffview.nvim]]

require("diffview").setup({
  use_icons = false
})

vim.keymap.set('n', '<leader>D', '<cmd>DiffviewOpen<CR>', { noremap=true, silent=true })
vim.keymap.set('n', '<leader>H', '<cmd>DiffviewFileHistory<CR>', { noremap=true, silent=true })
