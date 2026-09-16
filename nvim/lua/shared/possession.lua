return {
  autoload = false,
  autosave = {
    -- Background/headless checks should not overwrite interactive sessions.
    tmp = function()
      return #vim.api.nvim_list_uis() > 0
    end,
    tmp_name = function()
      return vim.fn.fnamemodify(vim.uv.cwd(), ":t")
    end,
    on_quit = true,
  },
  hooks = {
    before_save = function()
      -- Preserve the existing exclusion for sessions opened in Git metadata.
      if vim.fn.fnamemodify(vim.fn.expand("%"), ":p:h:t") == ".git" then
        return false
      end
      return {}
    end,
  },
}
