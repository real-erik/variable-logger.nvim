local default_config = {
  prefix = "",
}

local M = {
  config = default_config,
}

function M.setup(opt)
  if opt ~= nil then
    M.config = opt
  end
end

function M.log_variable(prefix, log_entire_object)
  local variableNode = vim.treesitter.get_node()
  local variableParent = variableNode:parent()
  local label = vim.treesitter.get_node_text(variableNode, 0)
  local parent = vim.treesitter.get_node_text(variableParent, 0)
  local prefixed_label = (prefix ~= nil and prefix or M.config.prefix) .. label
  parent = parent:match("^([^,;:]*)")

  local extracted = parent:match("^%((.*)%)")
  if extracted == nil then
    extracted = parent
  end

  local log_string
  if log_entire_object == true then
    log_string = "console.log('%s', require('util').inspect(%s, {showHidden: false, depth: null, colors: true}))\n"
  else
    log_string = "console.log('%s', %s)\n"
  end

  local log_string_formatted = string.format(log_string, prefixed_label, extracted)

  vim.fn.setreg('"', log_string_formatted)
end

return M
