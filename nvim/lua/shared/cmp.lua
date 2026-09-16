return {
  keymap = {
    preset = "default",
    ["<TAB>"] = { "select_next", "fallback" },
    ["<S-TAB>"] = { "select_prev", "fallback" },
    ["<CR>"] = { "accept", "fallback" },
  },
  completion = {
    list = { selection = { preselect = false, auto_insert = false } },
    documentation = { auto_show = true, auto_show_delay_ms = 200 },
  },
  signature = { enabled = true },
  sources = { default = { "lsp", "path", "buffer" } },
}
