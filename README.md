# Variable-Logger.nvim

Javascript/Lua logger for quick debugging

## Configuration

Setup

```lua
require("variable-logger").setup({
	prefix = "🪵 - ",   -- Make the log more visible
)
```

Make custom functions with defined prefixes

```lua
local logger = require("variable-logger")
local function logWithAsterisk()
	logger.log_variable("******** - ")
end
```

Log entire object

```lua
local logger = require("variable-logger")
local function logEntireObject()
  logger.log_entire_variable("******** - ")
end
```

Store log in register

```lua
vim.keymap.set("n", "<leader>yl", logWithAsterisk)
vim.keymap.set("n", "<leader>y", logger.log_variable)
```

Paste to log the variable

```
log_variable        output: console.log("🪵 - someVariable", someVariable)
log_entire_variable output: console.log("🪵 - someVariable", require("util").inspect(someVariable, {showHidden: false, depth: null, colors: true}))
```
