vim.cmd [[packadd trouble.nvim]]

require'nvim-treesitter.configs'.setup {
  require("trouble").setup {
    auto_open = true,
    auto_close = true,
    mode = "document_diagnostics",
    icons = false,
    use_diagnostic_signs = true,
    fold_open = "v",
    fold_closed = "❯"
  }
}

