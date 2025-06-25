vim.cmd [[packadd trouble.nvim]]

require("trouble").setup {
  auto_open = false,
  auto_close = true,
  mode = "document_diagnostics", -- "workspace_diagnostics", "document_diagnostics", "quickfix", "lsp_references", "loclist"
  icons = {
    indent = {
      top           = "│ ",
      middle        = "├╴",
      -- last          = "└╴",
      -- last          = "-╴",
      last       = "╰╴", -- rounded
      fold_open     = "▽ ",
      fold_closed   = "▷ ",
      ws            = " ",
    },
    folder_closed   = "⊖ ",
    folder_open     = "⊕ ",
    },
}

vim.keymap.set("n", "<leader>L",
  "<cmd>Trouble diagnostics toggle focus=false filter.buf=0<CR>", { silent = true })
