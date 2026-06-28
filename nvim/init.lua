-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Load core config
dofile(vim.fn.stdpath("config") .. "/options.lua")
dofile(vim.fn.stdpath("config") .. "/keymap.lua")

-- Setup plugins (auto-imports from lua/plugins/)
require("lazy").setup({ import = "plugins" })
