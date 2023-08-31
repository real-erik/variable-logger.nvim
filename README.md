# Variable-Logger.nvim

Javascript logger for quick debugging

## Configuration

Setup

```lua
require("variable-logger").setup({
	prefix = "🪵 - ",   -- Make the log more visible
)
```

Pass prefix with `log_variable`

```lua
local logger = require("variable-logger")
local function logWithAsterisk()
	logger.log_variable("******** - ") -- Make the log more visible
end
```

Log entire object
```lua
local logger = require("variable-logger")
local function logEntireObject()
  logger.log_variable(nil, true)
end
```

Store log in register

```lua
vim.keymap.set("n", "<leader>yl", logWithAsterisk)
vim.keymap.set("n", "<leader>y", logger.log_variable)
```


Paste to log the variable

```
console.log( "🪵 - someVariable", someVariable)
```
