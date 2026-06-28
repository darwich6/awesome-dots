return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local lspconfig = require("lspconfig")
    local servers = { "lua_ls", "pyright", "gopls", "ts_ls", "bashls", "yamlls", "dockerls" }
    for _, server in ipairs(servers) do
      lspconfig[server].setup({})
    end
    -- Show diagnostics on hover
    vim.api.nvim_create_autocmd("CursorHold", {
      callback = function()
        vim.diagnostic.open_float(nil, { focusable = false, scope = "cursor" })
      end,
    })
  end,
}
