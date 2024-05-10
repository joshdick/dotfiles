if !has('nvim')
  finish
endif

packadd! plenary.nvim
packadd! telescope.nvim

lua << EOF
  require("telescope").setup {
    defaults = {
      path_display = { "truncate" },
    },
    pickers = {
      buffers = {
        show_all_buffers = true,
        sort_lastused = true,
        theme = "dropdown",
        previewer = false,
        mappings = {
          i = {
            ["<c-d>"] = "delete_buffer",
          }
        }
      }
    }
  }
EOF

nnoremap <leader>g <cmd>Telescope live_grep<CR>
nnoremap <leader>cg :lua require('telescope.builtin').grep_string({ search = vim.fn.expand('<cword>')})<CR>
noremap <C-p> <cmd>Telescope find_files<CR>
noremap <C-b> <cmd>Telescope buffers<CR>

