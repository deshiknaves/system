return {
  {
    "mrcjkb/rustaceanvim",
    version = "^6",
    lazy = false,
    ft = { "rust" },
    config = function()
      vim.g.rustaceanvim = {
        tools = {
          hover_actions = { auto_focus = true },
        },
        server = {
          on_attach = function(_, bufnr)
            local map = function(keys, func, desc)
              vim.keymap.set("n", keys, func, { buffer = bufnr, desc = "Rust: " .. desc })
            end
            -- Run the test (or other runnable) nearest the cursor
            map("<leader>rt", function() vim.cmd.RustLsp("run") end, "Run nearest test/runnable")
            -- Pick any testable in the file
            map("<leader>rT", function() vim.cmd.RustLsp("testables") end, "Pick testable")
            map("<leader>rd", function() vim.cmd.RustLsp("debuggables") end, "Debug nearest test/runnable")
          end,
        },
      }
    end,
  },
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-neotest/nvim-nio",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      "rouge8/neotest-rust",
    },
    ft = { "rust" },
    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-rust"),
        },
      })

      local neotest = require("neotest")
      local map = function(keys, func, desc)
        vim.keymap.set("n", keys, func, { desc = "Neotest: " .. desc })
      end
      map("<leader>tt", function() neotest.run.run() end, "Run nearest test")
      map("<leader>tf", function() neotest.run.run(vim.fn.expand("%")) end, "Run file")
      map("<leader>ts", function() neotest.summary.toggle() end, "Toggle summary")
      map("<leader>to", function() neotest.output.open({ enter = true }) end, "Show output")
    end,
  },
}
