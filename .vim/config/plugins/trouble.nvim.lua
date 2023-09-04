vim.cmd [[packadd trouble.nvim]]

require("trouble").setup {
  auto_open = false,
  auto_close = true,
  mode = "document_diagnostics",
  icons = false,
  use_diagnostic_signs = true,
  fold_open = "v",
  fold_closed = "❯"
}

