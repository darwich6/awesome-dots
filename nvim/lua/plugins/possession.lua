return {
  "jedrzejboczar/possession.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  lazy = false, -- Register the quit/save hook even if no session command is used.
  opts = require("shared.possession"),
}
