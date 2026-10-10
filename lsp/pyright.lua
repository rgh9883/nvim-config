---@brief
---
--- https://github.com/microsoft/pyright
---
--- `pyright`, a static type checker and language server for python
---
--- Pyright marks unreachable, unreferenced and deprecated code with hint
--- diagnostics. Nvim correctly reports them as regular diagnostics, but they
--- are usually too noisy (https://github.com/neovim/neovim/issues/30444), so
--- they are disabled by default. To re-enable:
---
--- ```lua
--- vim.lsp.config('pyright', {
---   settings = { pyright = { disableTaggedHints = false } },
--- })
--- ```

local function set_python_path(command)
  local path = command.args
  local clients = vim.lsp.get_clients {
    bufnr = vim.api.nvim_get_current_buf(),
    name = 'pyright',
  }
  for _, client in ipairs(clients) do
    if client.settings then
      client.settings.python =
        vim.tbl_deep_extend('force', client.settings.python --[[@as table]], { pythonPath = path })
    else
      client.config.settings = vim.tbl_deep_extend('force', client.config.settings, { python = { pythonPath = path } })
    end
    client:notify('workspace/didChangeConfiguration', { settings = nil })
  end
end

---@type vim.lsp.Config
return {
  cmd = { 'pyright-langserver', '--stdio' },
  filetypes = { 'python' },
  root_markers = {
    'pyrightconfig.json',
    'pyproject.toml',
    'setup.py',
    'setup.cfg',
    'requirements.txt',
    'Pipfile',
    '.git',
  },
  ---@type lspconfig.settings.pyright
  settings = {
    pyright = {
      disableTaggedHints = true,
    },
    python = {
      analysis = {
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = 'openFilesOnly',
      },
    },
  },
  -- Use the project's uv-managed .venv (or an activated $VIRTUAL_ENV) so
  -- pyright resolves packages installed there instead of global ones.
  before_init = function(_, config)
    local venv = config.root_dir and vim.fs.joinpath(config.root_dir, '.venv')
    if not (venv and vim.uv.fs_stat(venv)) then
      venv = vim.env.VIRTUAL_ENV
    end
    local python = venv and vim.fs.joinpath(venv, 'bin', 'python')
    if python and vim.uv.fs_stat(python) then
      -- Mutate in place: the client holds a reference to this settings table.
      config.settings.python = config.settings.python or {}
      config.settings.python.pythonPath = python
    end
  end,
  on_attach = function(client, bufnr)
    vim.api.nvim_buf_create_user_command(bufnr, 'LspPyrightOrganizeImports', function()
      local params = {
        command = 'pyright.organizeimports',
        arguments = { vim.uri_from_bufnr(bufnr) },
      }

      -- Using client.request() directly because "pyright.organizeimports" is private
      -- (not advertised via capabilities), which client:exec_cmd() refuses to call.
      -- https://github.com/neovim/neovim/blob/c333d64663d3b6e0dd9aa440e433d346af4a3d81/runtime/lua/vim/lsp/client.lua#L1024-L1030
      ---@diagnostic disable-next-line: param-type-mismatch
      client.request('workspace/executeCommand', params, nil, bufnr)
    end, {
      desc = 'Organize Imports',
    })
    vim.api.nvim_buf_create_user_command(bufnr, 'LspPyrightSetPythonPath', set_python_path, {
      desc = 'Reconfigure pyright with the provided python path',
      nargs = 1,
      complete = 'file',
    })
  end,
}
