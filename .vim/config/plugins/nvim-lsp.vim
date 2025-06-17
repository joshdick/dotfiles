if !has('nvim')
  finish
endif

packadd! nvim-lspconfig
packadd! plenary.nvim " required by none-ls.nvim
packadd! none-ls.nvim
packadd! none-ls-extras.nvim
packadd! venv-lsp.nvim

" Based on example at
" < https://github.com/neovim/nvim-lspconfig#keybindings-and-completion >
lua << EOF
  -- vim.lsp.set_log_level('DEBUG')
  require('lspconfig')
  require('venv-lsp').setup()

  -- https://www.reddit.com/r/neovim/comments/ru871v/comment/hqxquvl/?utm_source=share&utm_medium=web2x&context=3
  vim.diagnostic.config({
    virtual_text = false,
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = "🅴",
        [vim.diagnostic.severity.WARN] = "🆆",
        [vim.diagnostic.severity.HINT] = "🅷",
        [vim.diagnostic.severity.INFO] = "🅸",
      },
    },
    float = { border = "single" },
  })

  -- As of neovim 0.10
  vim.lsp.inlay_hint.enable()

  -- Mappings.
  -- See `:help vim.diagnostic.*` for documentation on any of the below functions
  local opts = { noremap=true, silent=true }
  -- vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts) -- C-W>d (and <C-W><C-D>) are now default as of neovim 0.10
  -- vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts) -- is now default as of neovim 0.10
  -- vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts) -- is now default as of neovim 0.10
  vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, opts)

  -- Use an on_attach function to only map the following keys
  -- after the language server attaches to the current buffer
  local on_attach = function(client, bufnr)
    -- Enable completion triggered by <c-x><c-o>
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local bufopts = { noremap=true, silent=true, buffer=bufnr }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
    -- vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts) -- is now default as of neovim 0.10
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
    vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, bufopts)
    vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
    vim.keymap.set('n', '<leader>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, bufopts)
    vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, bufopts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, bufopts)
    vim.keymap.set('n', '<F2>', vim.lsp.buf.rename, bufopts)
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
    vim.keymap.set('n', '<leader>f', vim.lsp.buf.format, bufopts)
  end

  -- Requires: `npm i -g typescript typescript-language-server`
  vim.lsp.enable('ts_ls')
  vim.lsp.config('ts_ls', {
    -- root_dir = nvim_lsp.util.root_pattern("yarn.lock", "lerna.json", ".git"),
    on_attach = function(client, bufnr)
      -- Ensure that ts_ls is not used for formatting (prefer prettier)
      -- https://github.com/neovim/nvim-lspconfig/issues/1891
      client.server_capabilities.documentFormattingProvider = false

      -- TODO: Research https://github.com/tomaskallup/dotfiles/blob/master/nvim/lua/plugins/lsp-ts-utils.lua
      --ts_utils_attach(client)
      on_attach(client, bufnr)
    end,
    settings = { documentFormatting = false }
  })

  -- Requires `npm i -g pyright`
  vim.lsp.enable('pyright')
  vim.lsp.config('pyright', {
    -- root_dir = function(startpath)
    --  return M.search_ancestors(startpath, matcher)
    -- end,
    -- capabilities = (function()
      -- -- Disable pyright hints (diagnostics.) Found at:
      -- -- https://www.reddit.com/r/neovim/comments/11k5but/comment/jbjwwtf/?context=3
      -- local capabilities = vim.lsp.protocol.make_client_capabilities()
      -- capabilities.textDocument.publishDiagnostics.tagSupport.valueSet = { 2 }
      -- return capabilities
    -- end)(),
    settings = {
      python = {
        analysis = {
          autoSearchPaths = true,
          diagnosticMode = "workspace",
          useLibraryCodeForTypes = true
        },
      },
      pyright = {
        -- Use ruff for organizing imports
        disableOrganizeImports = true
      }
    },
    single_file_support = true,
    on_attach = on_attach
  })

  vim.lsp.enable('regal')
  vim.lsp.config('regal', {
    root_dir = function(fname)
      -- return nvim_lsp.util.find_git_ancestor(fname)
      return vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
    end,
    on_attach = on_attach
  })

  local null_ls = require('null-ls')

  null_ls.setup({
    sources = {
      null_ls.builtins.formatting.prettier,
      null_ls.builtins.formatting.black.with({
        -- cwd = nls_helpers.cache.by_bufnr(
          -- function(params)
            -- return nls_utils.root_pattern("pyproject.toml")(params.bufname)
          -- end
          -- )
        -- extra_args = { "--skip-string-normalization" },
      }),
      -- null_ls.builtins.formatting.isort,
      require('none-ls.formatting.eslint_d'), -- requires `npm i -g eslint_d`
      require('none-ls.formatting.ruff'),
      null_ls.builtins.diagnostics.mypy,
      -- null_ls.builtins.diagnostics.pylint,
      require('none-ls.diagnostics.ruff'),
      require('none-ls.diagnostics.eslint_d') -- requires `npm i -g eslint_d`
    },
    on_attach = on_attach
  })
EOF

augroup format_on_save
  autocmd BufWritePre *.js lua vim.lsp.buf.format()
  autocmd BufWritePre *.jsx lua vim.lsp.buf.format()
  autocmd BufWritePre *.tsx lua vim.lsp.buf.format()
  autocmd BufWritePre *.ts lua vim.lsp.buf.format()
  autocmd BufWritePre *.py lua vim.lsp.buf.format()
augroup END
