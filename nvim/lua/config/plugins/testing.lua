return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-neotest/nvim-nio",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      "rouge8/neotest-rust",
      "marilari88/neotest-vitest",
    },
    ft = { "rust", "javascript", "javascriptreact", "typescript", "typescriptreact" },
    config = function()
      local neotest_vitest_util = require("neotest-vitest.util")

      -- neotest-vitest only ever looks for node_modules/.bin/vitest, which
      -- Vite+ projects don't ship (vitest is wrapped by the `vp` CLI instead).
      -- Fall back to `vp test run` when a `vp` binary is present, otherwise
      -- keep neotest-vitest's normal resolution order.
      local function resolve_vitest_command(path)
        for _, root in ipairs({
          neotest_vitest_util.find_node_modules_ancestor(path),
          neotest_vitest_util.find_git_ancestor(path),
        }) do
          if root then
            local vitest_bin = root .. "/node_modules/.bin/vitest"
            if vim.fn.filereadable(vitest_bin) == 1 then
              return vitest_bin
            end
          end
        end

        local root = neotest_vitest_util.find_node_modules_ancestor(path)
        if root and vim.fn.filereadable(root .. "/node_modules/.bin/vp") == 1 then
          return "vp test run"
        end

        return "vitest"
      end

      require("neotest").setup({
        adapters = {
          require("neotest-rust"),
          require("neotest-vitest")({
            vitestCommand = resolve_vitest_command,
            -- `vp` queries the terminal for its background color to pick a
            -- theme; under neotest's job pty nothing answers the query, so
            -- it hangs forever. NO_COLOR makes it skip that query.
            env = { NO_COLOR = "1" },
          }),
        },
      })

      local neotest = require("neotest")
      local map = function(keys, func, desc)
        vim.keymap.set("n", keys, func, { desc = "Neotest: " .. desc })
      end
      map("<leader>Tt", function() neotest.run.run() end, "Run nearest test")
      map("<leader>Tf", function() neotest.run.run(vim.fn.expand("%")) end, "Run file")
      map("<leader>Ts", function() neotest.summary.toggle() end, "Toggle summary")
      map("<leader>To", function() neotest.output.open({ enter = true }) end, "Show output")
    end,
  },
}
