local editing = require("shared.editing")
-- Editing enhancements
return {
  { "windwp/nvim-autopairs", event = "InsertEnter", opts = editing.autopairs },
  { "kylechui/nvim-surround", event = "VeryLazy", opts = editing.surround },
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = { "BufReadPost", "BufNewFile" },
    opts = editing.indent,
  },
  { "lewis6991/gitsigns.nvim", event = { "BufReadPre", "BufNewFile" }, opts = editing.gitsigns },
}
