if !has('nvim')
  finish
endif

packadd! nvim-lspconfig
packadd! null-ls.nvim

" Based on example at
" < https://github.com/neovim/nvim-lspconfig#keybindings-and-completion >
lua << EOF
  local nvim_lsp = require('lspconfig')

  -- https://www.reddit.com/r/neovim/comments/ru871v/comment/hqxquvl/?utm_source=share&utm_medium=web2x&context=3
  vim.diagnostic.config({
    virtual_text = false,
    signs = true,
    float = { border = "single" },
  })

  -- Use an on_attach function to set mappings explicitly after
  -- the language server attaches to the current buffer.
  local on_attach = function(client, bufnr)
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

    -- Enable completion triggered by <c-x><c-o>
    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions.
    local opts = { noremap=true, silent=true }
    buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
    buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
    buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    -- buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
    -- buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
    -- buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
    -- buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    buf_set_keymap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    -- buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    buf_set_keymap('n', '<leader>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
    buf_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
    buf_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
    -- buf_set_keymap('n', '<space>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)
    buf_set_keymap("n", '<leader>f', "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
  end

  -- Requires: `npm i -g typescript typescript-language-server`
  nvim_lsp.tsserver.setup {
    -- root_dir = nvim_lsp.util.root_pattern("yarn.lock", "lerna.json", ".git"),
    on_attach = function(client, bufnr)
      -- Ensure that tsserver is not used for formatting (prefer prettier)
      client.resolved_capabilities.document_formatting = false

      -- TODO: Research https://github.com/tomaskallup/dotfiles/blob/master/nvim/lua/plugins/lsp-ts-utils.lua
      --ts_utils_attach(client)
      on_attach(client, bufnr)
    end,
    settings = { documentFormatting = false }
  }

  -- Requires `npm i -g pyright`
  nvim_lsp.pyright.setup {
    cmd = { "pyright-langserver", "--stdio" },
    filetypes = { "python" },
    -- root_dir = function(startpath)
    --  return M.search_ancestors(startpath, matcher)
    -- end,
    settings = {
      python = {
        analysis = {
          autoSearchPaths = true,
          diagnosticMode = "workspace",
          useLibraryCodeForTypes = true
        },
        organizeImports = {
          provider = "isort"
        }
      }
    },
    single_file_support = true,
    on_attach = on_attach
  }

  local null_ls = require("null-ls")

  null_ls.setup({
    sources = {
      null_ls.builtins.formatting.prettier,
      null_ls.builtins.formatting.eslint_d, -- requires `npm i -g eslint_d`
      null_ls.builtins.formatting.black,
      null_ls.builtins.formatting.isort,
      null_ls.builtins.diagnostics.mypy,
      null_ls.builtins.diagnostics.pylint
    },
    on_attach = on_attach
  })
EOF

augroup format_on_save
  autocmd BufWritePre *.js lua vim.lsp.buf.formatting_sync(nil, 1000)
  autocmd BufWritePre *.jsx lua vim.lsp.buf.formatting_sync(nil, 1000)
  autocmd BufWritePre *.tsx lua vim.lsp.buf.formatting_sync(nil, 1000)
  autocmd BufWritePre *.ts lua vim.lsp.buf.formatting_sync(nil, 1000)
  autocmd BufWritePre *.py lua vim.lsp.buf.formatting_sync(nil, 1000)
augroup END
