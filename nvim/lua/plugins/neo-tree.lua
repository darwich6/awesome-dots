return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons", "MunifTanjim/nui.nvim" },
  keys = { { "\\", "<cmd>Neotree reveal<cr>", desc = "NeoTree" } },
  opts = require("shared.neo-tree"),
}
