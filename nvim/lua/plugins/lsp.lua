return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    -- Use new vim.lsp.enable API (Neovim 0.11+)
    local servers = { "lua_ls", "pyright", "gopls", "ts_ls", "bashls", "yamlls", "dockerls" }
    for _, server in ipairs(servers) do
      vim.lsp.enable(server)
    end
    -- Show diagnostics on hover
    vim.api.nvim_create_autocmd("CursorHold", {
      callback = function()
        vim.diagnostic.open_float(nil, { focusable = false, scope = "cursor" })
      end,
    })
  end,
}
