local variable_logger = require("variable-logger")

variable_logger.setup({
  prefix = "🪵🪵🪵 - ",
})

describe("variable logger", function()
  describe("regular variable", function()
    before_each(function()
      vim.cmd.e("./lua/variable-logger/test-files/test-file.js")
      vim.api.nvim_win_set_cursor(0, { 1, 0 })
      vim.api.nvim_command("/turtle")
    end)

    after_each(function()
      vim.cmd.bd("./lua/variable-logger/test-files/test-file.js")
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
      variable_logger.log_entire_variable()
      local register_value = vim.fn.getreg("")
      assert.equal(
        "console.log('🪵🪵🪵 - turtle', require('util').inspect(turtle, {showHidden: false, depth: null, colors: true}))\n",
        register_value
      )
    end)
  end)

  describe("non regular variable", function()
    before_each(function()
      vim.cmd.e("./lua/variable-logger/test-files/test-file.js")
    end)

    after_each(function()
      vim.cmd.bd("./lua/variable-logger/test-files/test-file.js")
    end)

    it("logs variable", function()
      vim.api.nvim_win_set_cursor(0, { 3, 0 })
      vim.api.nvim_command("/turtle")
      vim.api.nvim_command("normal! n")
      variable_logger.log_variable()

      local register_value = vim.fn.getreg("")
      assert.equal("console.log('🪵🪵🪵 - dog.cat.turtle', dog.cat.turtle)\n", register_value)
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
      assert.equal("console.log('🪵🪵🪵 - dog[0].cat().turtle', dog[0].cat().turtle)\n", register_value)
    end)

    it("word with colon at the end", function()
      vim.api.nvim_win_set_cursor(0, { 13, 0 })
      vim.api.nvim_command("/turtle")
      vim.api.nvim_command("normal! n")

      variable_logger.log_variable()

      local register_value = vim.fn.getreg("")
      assert.equal("console.log('🪵🪵🪵 - turtle', turtle)\n", register_value)
    end)

    it("word before equals sign", function()
      vim.api.nvim_win_set_cursor(0, { 15, 0 })
      vim.api.nvim_command("/turtle")
      vim.api.nvim_command("normal! n")

      variable_logger.log_variable()

      local register_value = vim.fn.getreg("")
      assert.equal("console.log('🪵🪵🪵 - turtle', turtle)\n", register_value)
    end)

    it("reassigned variable", function()
      vim.api.nvim_win_set_cursor(0, { 17, 0 })
      vim.api.nvim_command("/turtle")
      vim.api.nvim_command("normal! n")

      variable_logger.log_variable()

      local register_value = vim.fn.getreg("")
      assert.equal("console.log('🪵🪵🪵 - turtle', turtle)\n", register_value)
    end)

    it("reassigned variable2", function()
      vim.api.nvim_win_set_cursor(0, { 17, 0 })
      vim.api.nvim_command("/cat")
      vim.api.nvim_command("normal! n")

      variable_logger.log_variable()

      local register_value = vim.fn.getreg("")
      assert.equal("console.log('🪵🪵🪵 - cat', cat)\n", register_value)
    end)

    it("reassigned variable3", function()
      vim.api.nvim_win_set_cursor(0, { 17, 0 })
      vim.api.nvim_command("/dog")
      vim.api.nvim_command("normal! n")

      variable_logger.log_variable()

      local register_value = vim.fn.getreg("")
      assert.equal("console.log('🪵🪵🪵 - dog', dog)\n", register_value)
    end)

    it("word before equals sign with period in string", function()
      vim.api.nvim_win_set_cursor(0, { 19, 0 })
      vim.api.nvim_command("/turtle")
      vim.api.nvim_command("normal! n")

      variable_logger.log_variable()

      local register_value = vim.fn.getreg("")
      assert.equal("console.log('🪵🪵🪵 - turtle', turtle)\n", register_value)
    end)

    it("word after equals sign with period in string", function()
      vim.api.nvim_win_set_cursor(0, { 19, 0 })
      vim.api.nvim_command("/cat")
      vim.api.nvim_command("normal! n")

      variable_logger.log_variable()

      local register_value = vim.fn.getreg("")
      assert.equal("console.log('🪵🪵🪵 - cat', cat)\n", register_value)
    end)

    it("word after period", function()
      vim.api.nvim_win_set_cursor(0, { 19, 0 })
      vim.api.nvim_command("/meow")
      vim.api.nvim_command("normal! n")

      variable_logger.log_variable()

      local register_value = vim.fn.getreg("")
      assert.equal("console.log('🪵🪵🪵 - cat.meow()', cat.meow())\n", register_value)
    end)
  end)

  describe("file type specific log statements", function()
    it("js", function()
      vim.cmd.e("./lua/variable-logger/test-files/test-file.js")
      vim.api.nvim_win_set_cursor(0, { 1, 0 })
      vim.api.nvim_command("/turtle")

      variable_logger.log_variable()

      local register_value = vim.fn.getreg("")
      assert.equal("console.log('🪵🪵🪵 - turtle', turtle)\n", register_value)
    end)

    it("jsx", function()
      vim.cmd.e("./lua/variable-logger/test-files/test-file.jsx")
      vim.api.nvim_win_set_cursor(0, { 1, 0 })
      vim.api.nvim_command("/turtle")

      variable_logger.log_variable()

      local register_value = vim.fn.getreg("")
      assert.equal("console.log('🪵🪵🪵 - turtle', turtle)\n", register_value)
    end)

    it("ts", function()
      vim.cmd.e("./lua/variable-logger/test-files/test-file.ts")
      vim.api.nvim_win_set_cursor(0, { 1, 0 })
      vim.api.nvim_command("/turtle")

      variable_logger.log_variable()

      local register_value = vim.fn.getreg("")
      assert.equal("console.log('🪵🪵🪵 - turtle', turtle)\n", register_value)
    end)

    it("tsx", function()
      vim.cmd.e("./lua/variable-logger/test-files/test-file.tsx")
      vim.api.nvim_win_set_cursor(0, { 1, 0 })
      vim.api.nvim_command("/turtle")

      variable_logger.log_variable()

      local register_value = vim.fn.getreg("")
      assert.equal("console.log('🪵🪵🪵 - turtle', turtle)\n", register_value)
    end)

    it("lua", function()
      vim.cmd.e("./lua/variable-logger/test-files/test-file.lua")
      vim.api.nvim_win_set_cursor(0, { 1, 0 })
      vim.api.nvim_command("/turtle")

      variable_logger.log_variable()

      local register_value = vim.fn.getreg("")
      assert.equal("print('🪵🪵🪵 - turtle', turtle)\n", register_value)
    end)
  end)
end)
