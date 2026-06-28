return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons", "MunifTanjim/nui.nvim" },
  keys = { { "\\", "<cmd>Neotree reveal<cr>", desc = "NeoTree" } },
  opts = {
    close_if_last_window = true,
    popup_border_style = "rounded",
    filesystem = {
      filtered_items = { hide_dotfiles = true, hide_gitignored = true },
      follow_current_file = { enabled = true },
      hijack_netrw_behavior = "open_default",
    },
  },
}
