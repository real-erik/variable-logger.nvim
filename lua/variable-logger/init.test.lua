local variable_logger = require("variable-logger")

variable_logger.setup({
  prefix = "🪵🪵🪵 - ",
})

describe("log_variable", function()
  describe("regular variable", function()
    before_each(function()
      vim.cmd.e("./lua/variable-logger/test-file.js")
      vim.api.nvim_win_set_cursor(0, { 1, 0 })
      vim.api.nvim_command("/turtle")
    end)

    after_each(function()
      vim.cmd.bd("./lua/variable-logger/test-file.js")
    end)

    it("logs variable with config prefix", function()
      variable_logger.log_variable()

      local register_value = vim.fn.getreg("")
      assert.equal("console.log('🪵🪵🪵 - turtle', turtle)\n", register_value)
    end)

    it("logs variable with override prefix", function()
      variable_logger.log_variable("🪵 - ")

      local register_value = vim.fn.getreg("")
      assert.equal("console.log('🪵 - turtle', turtle)\n", register_value)
    end)

    it("logs entire js object", function()
      variable_logger.log_variable(nil, true)
      local register_value = vim.fn.getreg("")
      assert.equal(
        "console.log('🪵🪵🪵 - turtle', require('util').inspect(turtle, {showHidden: false, depth: null, colors: true}))\n",
        register_value
      )
    end)
  end)

  describe("non regular variable", function()
    before_each(function()
      vim.cmd.e("./lua/variable-logger/test-file.js")
    end)

    after_each(function()
      vim.cmd.bd("./lua/variable-logger/test-file.js")
    end)

    it("logs variable", function()
      vim.api.nvim_win_set_cursor(0, { 3, 0 })
      vim.api.nvim_command("/turtle")
      vim.api.nvim_command("normal! n")
      variable_logger.log_variable()

      local register_value = vim.fn.getreg("")
      assert.equal("console.log('🪵🪵🪵 - turtle', dog.cat.turtle)\n", register_value)
    end)

    it("word with semicolon at the end", function()
      vim.api.nvim_win_set_cursor(0, { 5, 0 })
      vim.api.nvim_command("/turtle")
      variable_logger.log_variable()

      local register_value = vim.fn.getreg("")
      assert.equal("console.log('🪵🪵🪵 - turtle', turtle)\n", register_value)
    end)

    it("word with comma at the end", function()
      vim.api.nvim_win_set_cursor(0, { 7, 0 })
      vim.api.nvim_command("/turtle")

      variable_logger.log_variable()

      local register_value = vim.fn.getreg("")
      assert.equal("console.log('🪵🪵🪵 - turtle', turtle)\n", register_value)
    end)

    it("word inside parenthesis", function()
      vim.api.nvim_win_set_cursor(0, { 9, 0 })
      vim.api.nvim_command("/turtle")
      vim.api.nvim_command("normal! n")

      variable_logger.log_variable()

      local register_value = vim.fn.getreg("")
      assert.equal("console.log('🪵🪵🪵 - turtle', turtle)\n", register_value)
    end)

    it("word after stuff", function()
      vim.api.nvim_win_set_cursor(0, { 11, 0 })
      vim.api.nvim_command("/turtle")
      vim.api.nvim_command("normal! n")

      variable_logger.log_variable()

      local register_value = vim.fn.getreg("")
      assert.equal("console.log('🪵🪵🪵 - turtle', dog[0].cat().turtle)\n", register_value)
    end)

    it("word with colon at the end", function()
      vim.api.nvim_win_set_cursor(0, { 13, 0 })
      vim.api.nvim_command("/turtle")
      vim.api.nvim_command("normal! n")

      variable_logger.log_variable()

      local register_value = vim.fn.getreg("")
      assert.equal("console.log('🪵🪵🪵 - turtle', turtle)\n", register_value)
    end)
  end)
end)
