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

---@return string
local function get_label_and_variable()
  local current_position = vim.api.nvim_win_get_cursor(0)

  vim.cmd("normal! yiW")
  local yanked_text = vim.fn.getreg('"')
  vim.api.nvim_win_set_cursor(0, current_position)

  vim.cmd("normal! yiw")
  local yanked_variable = vim.fn.getreg('"')
  vim.api.nvim_win_set_cursor(0, current_position)

  if string.find(yanked_text, "%." .. yanked_variable) then
    -- finds everything up to and including yanked_variable
    yanked_variable = yanked_text:match("(.-" .. yanked_variable .. "[^.]*)")

    -- remove leading parenthesis
    if string.sub(yanked_variable, 1, 1) == "(" then
      yanked_variable = string.sub(yanked_variable, 2)
    end

    -- remove ending semicolon
    if string.sub(yanked_variable, -1) == ";" then
      yanked_variable = string.sub(yanked_variable, 1, -2)
    end
  end

  return yanked_variable
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
---@param entire_object boolean | nil
---@return nil
local function format_log_string(prefix, entire_object)
  local variable = get_label_and_variable()
  local prefixed_label = (prefix ~= nil and prefix or M.config.prefix) .. variable
  local log_string = generate_log_string(entire_object)
  local log_string_formatted = string.format(log_string, prefixed_label, variable)

  vim.fn.setreg('"', log_string_formatted)
end

---@param prefix string | nil
---@return nil
function M.log_variable(prefix)
  format_log_string(prefix, nil)
end

---@param prefix string | nil
---@return nil
function M.log_entire_variable(prefix)
  format_log_string(prefix, true)
end

return M
