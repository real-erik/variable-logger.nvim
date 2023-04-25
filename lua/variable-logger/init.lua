local default_config = {
  prefix = "",
}

local M = {}

function M.setup(opt)
  if opt ~= nil then
    M.config = opt
  end
end

function M.log_variable(prefix)
  vim.fn.setreg('"', "")
  local current_position = vim.api.nvim_win_get_cursor(0)
  vim.cmd("normal! viwy")
  local yanked_text = vim.fn.getreg('"')
  local label = yanked_text

  if prefix ~= nil then
    label = prefix .. label
  elseif M.config.prefix ~= nil then
    label = M.config.prefix .. label
  end

  vim.fn.setreg('"', string.format("console.log('%s', %s)\n", label, yanked_text))
  vim.api.nvim_win_set_cursor(0, current_position)
end

return M
