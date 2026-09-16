-- Nix supplies plugins and parsers. Never bootstrap Lazy or download parsers here.
vim.g.awesome_dots_nix = true
require("shared.dracula")()
local editing = require("shared.editing")
require("nvim-autopairs").setup(editing.autopairs)
require("nvim-surround").setup(editing.surround)
require("ibl").setup(editing.indent)
require("gitsigns").setup(editing.gitsigns)
require("which-key").setup(editing.which_key)
require("blink.cmp").setup(require("shared.cmp"))
require("conform").setup(require("shared.formatting"))
require("neo-tree").setup(require("shared.neo-tree"))
require("telescope").setup({})
for _, mapping in ipairs(require("shared.navigation")) do
  vim.keymap.set("n", mapping[1], mapping[2], { desc = mapping.desc })
end
vim.keymap.set("n", "\\", "<cmd>Neotree reveal<cr>", { desc = "NeoTree" })
require("shared.lualine")()
require("shared.alpha")()
require("shared.treesitter").setup()
require("shared.lsp")()
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "go", "gomod" },
  once = true,
  callback = function()
    require("go").setup(editing.go)
  end,
})
