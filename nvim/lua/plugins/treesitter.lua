return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    local ts = require("nvim-treesitter")
    local parsers = {
      "bash",
      "css",
      "dockerfile",
      "go",
      "gomod",
      "html",
      "javascript",
      "json",
      "lua",
      "markdown",
      "markdown_inline",
      "python",
      "tsx",
      "typescript",
      "vim",
      "vimdoc",
      "yaml",
    }
    ts.setup({})
    local highlighting = require("shared.treesitter")
    highlighting.setup()
    ts.install(parsers):await(function()
      vim.schedule(function()
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
          if vim.api.nvim_buf_is_loaded(buf) then
            highlighting.highlight(buf)
          end
        end
      end)
    end)
  end,
}
