if !has('nvim')
  finish
endif

packadd! nvim-lspconfig
packadd! none-ls.nvim

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

  local null_ls = require('null-ls')
  local nls_utils = require('null-ls.utils')
  local nls_helpers = require('null-ls.helpers')

  local cache_key = 'cache_poetry_virtualenv_path'
  if not vim.g[cache_key] then
    vim.api.nvim_set_var(cache_key, vim.empty_dict())
  end

  local get_poetry_virtual_env_bin_path = function(dir)
    if not vim.g[cache_key][dir] then
      local virtual_env_path = vim.fn.trim(vim.fn.system('poetry -C ' .. dir .. ' env info -p'))
      local cache = vim.g[cache_key]
      cache[dir] = virtual_env_path
      vim.api.nvim_set_var(cache_key, cache)
    end
    local bin_path = vim.g[cache_key][dir] .. '/bin'
    return bin_path
  end

  local get_poetry_bin_cmd_path = function(cmd)
    return function(opts)
      local buf_workspace_dir = nls_helpers.cache.by_bufnr(function(params)
        return nls_utils.root_pattern(
          "pyproject.toml"
        )(params.bufname)
      end)(opts)

      local virtual_env_path = get_poetry_virtual_env_bin_path(buf_workspace_dir)
      return virtual_env_path .. '/' .. cmd
    end
  end

  local on_new_config = function(new_config, new_root_dir)
    local poetry_virutalenv_bin = get_poetry_virtual_env_bin_path(new_root_dir)
    local pythonPath = poetry_virutalenv_bin .. '/python'
    new_config.settings.python.pythonPath = pythonPath
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
    cmd = { "pyright-langserver", "--stdio" },
    filetypes = { "python" },
    on_new_config = on_new_config,
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
        organizeImports = {
          provider = "isort"
        }
      }
    },
    single_file_support = true,
    on_attach = on_attach
  }

  null_ls.setup({
    sources = {
      null_ls.builtins.formatting.prettier,
      null_ls.builtins.formatting.eslint_d, -- requires `npm i -g eslint_d`
      null_ls.builtins.formatting.black.with({
        dynamic_command = get_poetry_bin_cmd_path('black')
        -- cwd = nls_helpers.cache.by_bufnr(
          -- function(params)
            -- return nls_utils.root_pattern("pyproject.toml")(params.bufname)
          -- end
          -- )
        -- extra_args = { "--skip-string-normalization" },
      }),
      null_ls.builtins.formatting.ruff.with({ dynamic_command = get_poetry_bin_cmd_path('ruff') }),
      null_ls.builtins.diagnostics.ruff.with({ dynamic_command = get_poetry_bin_cmd_path('ruff') }),
      null_ls.builtins.diagnostics.mypy.with({ dynamic_command = get_poetry_bin_cmd_path('mypy') })
      -- null_ls.builtins.formatting.isort,
      -- null_ls.builtins.diagnostics.pylint
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
