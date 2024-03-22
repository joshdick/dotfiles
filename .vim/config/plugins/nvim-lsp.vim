if !has('nvim')
  finish
endif

packadd! nvim-lspconfig
packadd! none-ls.nvim
packadd! none-ls-extras.nvim
packadd! venv-lsp.nvim

" Based on example at
" < https://github.com/neovim/nvim-lspconfig#keybindings-and-completion >
lua << EOF
  local lspconfig = require('lspconfig')

  local signs = { Error = "🅴", Warn = "🆆", Hint = "🅷", Info = "🅸" }
  for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
  end

  -- https://www.reddit.com/r/neovim/comments/ru871v/comment/hqxquvl/?utm_source=share&utm_medium=web2x&context=3
  vim.diagnostic.config({
    virtual_text = false,
    signs = true,
    float = { border = "single" },
  })

  -- Mappings.
  -- See `:help vim.diagnostic.*` for documentation on any of the below functions
  local opts = { noremap=true, silent=true }
  vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts)
  vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
  vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
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
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
    vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, bufopts)
    vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
    vim.keymap.set('n', '<leader>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, bufopts)
    vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, bufopts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, bufopts)
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
    vim.keymap.set('n', '<leader>f', vim.lsp.buf.format, bufopts)
  end

  -- Requires: `npm i -g typescript typescript-language-server`
  lspconfig.tsserver.setup {
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
  lspconfig.pyright.setup {
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
  }

  -- Requires `pipx install ruff-lsp`
  -- lspconfig.ruff_lsp.setup {
  --   -- Assume the language server will be provided by the active global pyenv
  --   -- cmd = { vim.env.HOME .. "/.local/bin/ruff-lsp" },
  --   -- args = { "--config=./pyproject.toml" },
  --   init_options = {
  --     settings = {
  --       format = {
  --         -- Only use ruff for import formatting; prefer black for all other formatting
  --         -- args = { "--select", "'I'" },
  --         args = { "--config", "format.quote-style='preserve'" }
  --       }
  --     },
  --   },
  --   on_attach = function(client, bufnr)
  --       -- Ensure that ruff is not used for hover (prefer pyright)
  --       -- https://github.com/astral-sh/ruff-lsp?tab=readme-ov-file#example-neovim
  --       client.server_capabilities.hoverProvider = false

  --       on_attach(client, bufnr)

  --       -- Manually add a `RuffOrganizeImports` command
  --       -- https://github.com/astral-sh/ruff-lsp/issues/295#issuecomment-1783257787
  --       local ruff_lsp_client = require("lspconfig.util").get_active_client_by_name(bufnr, "ruff_lsp")

  --       local request = function(method, params)
  --         ruff_lsp_client.request(method, params, nil, bufnr)
  --       end

  --       local organize_imports = function()
  --         request("workspace/executeCommand", {
  --           command = "ruff.applyOrganizeImports",
  --           arguments = {
  --             { uri = vim.uri_from_bufnr(bufnr) },
  --           },
  --         })
  --       end

  --       vim.api.nvim_create_user_command(
  --         "RuffOrganizeImports",
  --         organize_imports,
  --         { desc = "Ruff: Organize Imports" }
  --       )
  --     end
  --  }

  local null_ls = require('null-ls')
  -- local nls_utils = require('null-ls.utils')
  -- local nls_helpers = require('null-ls.helpers')

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

" function! PythonFormat()
  " if exists(':RuffOrganizeImports')
  "   silent! execute ':RuffOrganizeImports'
  " endif
  " lua vim.lsp.buf.format()
" endfunction

augroup format_on_save
  autocmd BufWritePre *.js lua vim.lsp.buf.format()
  autocmd BufWritePre *.jsx lua vim.lsp.buf.format()
  autocmd BufWritePre *.tsx lua vim.lsp.buf.format()
  autocmd BufWritePre *.ts lua vim.lsp.buf.format()
  " autocmd BufWritePre *.py call PythonFormat()
  autocmd BufWritePre *.py lua vim.lsp.buf.format()
augroup END
