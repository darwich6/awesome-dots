return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = { "BufReadPost", "BufNewFile" },
  main = "nvim-treesitter.configs",
  opts = {
    ensure_installed = { "lua", "vim", "vimdoc", "go", "typescript", "javascript", "python", "bash", "yaml", "json", "markdown" },
    highlight = { enable = true },
    indent = { enable = true },
  },
}
