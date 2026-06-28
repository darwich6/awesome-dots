-- Editing enhancements
return {
  { "windwp/nvim-autopairs", event = "InsertEnter", opts = {} },
  { "kylechui/nvim-surround", event = "VeryLazy", opts = {} },
  { "lukas-reineke/indent-blankline.nvim", main = "ibl", event = { "BufReadPost", "BufNewFile" },
    opts = { debounce = 50, scope = { show_start = false, show_end = false } } },
  { "lewis6991/gitsigns.nvim", event = { "BufReadPre", "BufNewFile" },
    config = function() require("gitsigns").setup(); vim.cmd("Gitsigns toggle_current_line_blame") end },
}
