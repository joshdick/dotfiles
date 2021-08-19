if has("nvim")

  packadd! nvim-treesitter

lua << EOF
require'nvim-treesitter.configs'.setup {
   -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  ensure_installed = {
    "bash",
    "graphql",
    "html",
    "javascript",
    "json",
    "python",
    "typescript",
    "yaml"
  },
  highlight = {
    -- false will disable the whole extension
    enable = true
  },
}
EOF

endif
