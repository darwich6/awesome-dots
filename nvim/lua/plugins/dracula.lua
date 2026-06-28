return {
  "Mofiqul/dracula.nvim",
  priority = 1000,
  config = function()
    require("dracula").setup({ transparent_bg = false, italic_comment = true })
    vim.opt.background = "dark"
    vim.cmd.colorscheme("dracula")
  end,
}
