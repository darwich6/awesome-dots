return function()
  vim.lsp.config("*", { capabilities = require("blink.cmp").get_lsp_capabilities() })
  -- Use new vim.lsp.enable API (Neovim 0.11+)
  local servers = { "lua_ls", "pyright", "gopls", "ts_ls", "bashls", "yamlls", "dockerls", "eslint" }
  if vim.g.awesome_dots_nix then
    table.insert(servers, "nixd")
  end
  for _, server in ipairs(servers) do
    vim.lsp.enable(server)
  end
  -- Show diagnostics on hover
  vim.api.nvim_create_autocmd("CursorHold", {
    callback = function()
      vim.diagnostic.open_float(nil, { focusable = false, scope = "cursor" })
    end,
  })
end
