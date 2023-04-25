local function log_variable()
  vim.fn.setreg('"', "")
  local current_position = vim.api.nvim_win_get_cursor(0)
  vim.cmd("normal! viwy")
  local yanked_text = vim.fn.getreg('"')
  vim.fn.setreg('"', string.format("console.log('%s', %s)\n", yanked_text, yanked_text))
  vim.api.nvim_win_set_cursor(0, current_position)
end

return log_variable
