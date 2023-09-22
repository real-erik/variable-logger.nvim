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

local log_types = {
  js = "console.log",
  lua = "print",
}

---@param label string
---@param regex string
local function optional_match(label, regex)
  local extracted = label:match(regex)
  if extracted == nil then
    extracted = label
  end

  return extracted
end

---@return string, string
local function get_label_and_variable()
  local extract_string_after_space = ".*%s+(.+)$"
  local extract_variable_in_parenthesis = "^%((.*)%)"

  local label = vim.treesitter.get_node()
  local variable = label:parent()
  label = vim.treesitter.get_node_text(label, 0)
  variable = vim.treesitter.get_node_text(variable, 0)
  variable = variable:match("^([^,;:=]*)") -- get string before , ; : =
  variable = variable:gsub("%s+$", "")    -- remove trailing spaces

  label = optional_match(label, extract_string_after_space)

  variable = optional_match(variable, extract_string_after_space)
  variable = optional_match(variable, extract_variable_in_parenthesis)

  return label, variable
end

---@return string
local function guess_type()
  local filename = vim.api.nvim_buf_get_name(0)
  local tokens = vim.split(filename, ".", { plain = true, trimempty = true })
  return tokens[#tokens]
end

---@param log_entire_object boolean | nil
---@return string
local function generate_log_string(log_entire_object)
  local log_string
  local filetype = guess_type()

  if filetype:match("js") or filetype:match("ts") then
    if log_entire_object == true then
      log_string = log_types.js
          .. "('%s', require('util').inspect(%s, {showHidden: false, depth: null, colors: true}))\n"
    else
      log_string = log_types.js .. "('%s', %s)\n"
    end
  end

  if filetype:match("lua") then
    log_string = log_types.lua .. "('%s', %s)\n"
  end

  return log_string
end

---@param prefix string | nil
---@param log_entire_object boolean | nil
---@return nil
function M.log_variable(prefix, log_entire_object)
  local label, variable = get_label_and_variable()
  local prefixed_label = (prefix ~= nil and prefix or M.config.prefix) .. label
  local log_string = generate_log_string(log_entire_object)
  local log_string_formatted = string.format(log_string, prefixed_label, variable)

  vim.fn.setreg('"', log_string_formatted)
end

return M
