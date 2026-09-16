local M = {}
function M.highlight(buf)
  if not vim.api.nvim_buf_is_valid(buf) then
    return
  end
  local lang = vim.treesitter.language.get_lang(vim.bo[buf].filetype)
  if lang and vim.treesitter.language.add(lang) then
    vim.treesitter.start(buf, lang)
  end
end
function M.setup()
  vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("UserTreesitter", { clear = true }),
    callback = function(ev)
      M.highlight(ev.buf)
    end,
  })
end
return M
