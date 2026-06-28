return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  event = "VeryLazy",
  config = function()
    local colors = {
      bg = "#202328", fg = "#bbc2cf", yellow = "#ECBE7B", cyan = "#008080",
      green = "#98be65", orange = "#FF8800", violet = "#a9a1e1",
      magenta = "#c678dd", blue = "#51afef", red = "#ec5f67",
    }
    local mode_color = {
      n = colors.red, i = colors.green, v = colors.blue, V = colors.blue,
      c = colors.magenta, R = colors.violet, t = colors.red,
    }
    require("lualine").setup({
      options = {
        component_separators = "", section_separators = "",
        theme = { normal = { c = { fg = colors.fg, bg = colors.bg } } },
      },
      sections = {
        lualine_a = {}, lualine_b = {}, lualine_y = {}, lualine_z = {},
        lualine_c = {
          { function() return "▊" end, color = { fg = colors.blue }, padding = { left = 0 } },
          { function() return "" end, color = function() return { fg = mode_color[vim.fn.mode()] or colors.red } end },
          { "filename", color = { fg = colors.magenta, gui = "bold" } },
          "location", "progress",
          { "diagnostics", sources = { "nvim_diagnostic" } },
        },
        lualine_x = { "encoding", "filetype", "branch", "diff" },
      },
    })
  end,
}
