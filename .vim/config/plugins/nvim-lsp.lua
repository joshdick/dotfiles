vim.cmd [[packadd nvim-lspconfig]]
vim.cmd [[packadd plenary.nvim]] -- required by none-ls.nvim
vim.cmd [[packadd none-ls.nvim]]
vim.cmd [[packadd none-ls-extras.nvim]]
vim.cmd [[packadd venv-lsp.nvim]]

-- vim.lsp.set_log_level('DEBUG')
require('lspconfig')
require('venv-lsp').setup()

-- https://www.reddit.com/r/neovim/comments/ru871v/comment/hqxquvl/?utm_source=share&utm_medium=web2x&context=3
vim.diagnostic.config({
  -- https://gpanders.com/blog/whats-new-in-neovim-0-11/#diagnostics
  virtual_text = { current_line = true },
  -- virtual_lines = { current_line = true },
  severity_sort = true,
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

local lsp_restart = function()
  vim.diagnostic.reset()
  vim.cmd("LspRestart")
  vim.notify("LSP restarted")
end

-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap=true, silent=true }

vim.keymap.set('n', '<leader>lr', lsp_restart, opts)
-- vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts) -- C-W>d (and <C-W><C-D>) are now default as of neovim 0.10
-- vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts) -- is now default as of neovim 0.10
-- vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts) -- is now default as of neovim 0.10
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, opts)

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', { clear = true }),
  callback = function(ev)
    local buffer = ev.buf
    local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))

    -- https://gpanders.com/blog/whats-new-in-neovim-0-11/#builtin-auto-completion
    if client:supports_method('textDocument/completion') then
      vim.opt.completeopt = { "menuone", "noselect", "popup" }
      vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
    end

    if not client:supports_method('textDocument/willSaveWaitUntil')
        and client:supports_method('textDocument/formatting') then
      vim.api.nvim_create_autocmd('BufWritePre', {
        group = vim.api.nvim_create_augroup('auto_format_lsp', { clear = false }),
        buffer = buffer,
        callback = function()
          vim.lsp.buf.format({ bufnr = buffer, id = client.id, timeout_ms = format_timeout_ms, async = false })
        end,
      })
    end

    -- https://github.com/jglasovic/dotfiles/blob/6132876/.vim/rcplugins/lsp-setup.lua

    -- local opts = { buffer = buffer }
    -- vim.keymap.set('i', '<C-k>', function() vim.lsp.buf.signature_help({ border = border }) end, opts)
    -- vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    -- vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    -- vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    -- vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition, opts)
    -- vim.keymap.set('n', 'gr', function() vim.lsp.buf.references({ includeDeclaration = false }) end, opts)
    -- vim.keymap.set('n', 'M', man_documentation, opts)
    -- vim.keymap.set('n', 'K', function() vim.lsp.buf.hover({ border = border }) end, opts)
    -- vim.keymap.set('n', '<leader>cr', vim.lsp.buf.rename, opts)
    -- vim.keymap.set({ 'n', 'v' }, '<leader>.', vim.lsp.buf.code_action, opts)
    -- vim.keymap.set('n', '<leader>cf', function()
    --   vim.lsp.buf.format({ timeout_ms = format_timeout_ms, async = true })
    -- end
    -- , opts)
    -- -- manually handle [my]sql autocomplete with https://github.com/echasnovski/mini.completion
    -- if not vim.tbl_contains({ 'sql', 'mysql' }, vim.bo.filetype) then
    --   vim.bo[buffer].omnifunc = 'v:lua.MiniCompletion.completefunc_lsp'
    -- end

    -- Enable completion triggered by <c-x><c-o>
    vim.api.nvim_buf_set_option(buffer, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local bufopts = { noremap=true, silent=true, buffer=buffer }
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
  end,
})

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
    -- null_ls.builtins.diagnostics.mypy,
    -- null_ls.builtins.diagnostics.pylint,
    require('none-ls.diagnostics.ruff'),
    require('none-ls.diagnostics.eslint_d') -- requires `npm i -g eslint_d`
  },
  on_attach = on_attach
})
