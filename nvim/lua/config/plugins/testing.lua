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

      -- Convention: a `.neotest-scope` marker file at (or above) a Cargo
      -- workspace root means "scope test runs to the nearest crate" instead
      -- of neotest-rust's hardcoded `cargo nextest run --workspace`, which
      -- otherwise forces a full-workspace build (and fails) whenever any
      -- unrelated crate in a large workspace doesn't compile.
      local function find_upward(filename, start_dir)
        local found = vim.fn.findfile(filename, start_dir .. ";")
        if found == "" then
          return nil
        end
        return vim.fn.fnamemodify(found, ":p")
      end

      local function is_package_scoped(start_dir)
        return find_upward(".neotest-scope", start_dir) ~= nil
      end

      local function run_scoped_cargo_test(start_dir)
        local cargo_toml = find_upward("Cargo.toml", start_dir)
        if cargo_toml == nil then
          vim.notify("neotest-scope: no Cargo.toml found above " .. start_dir, vim.log.levels.WARN)
          return
        end
        local package_root = vim.fn.fnamemodify(cargo_toml, ":h")
        -- Closing this split falls back to Vim's default "lowest window
        -- number" target, which is NvimTree whenever it's open (it's always
        -- the leftmost/first-created split). Remember where we came from and
        -- restore it explicitly instead.
        local origin_win = vim.api.nvim_get_current_win()
        vim.cmd("botright split | terminal cd " .. vim.fn.shellescape(package_root) .. " && cargo test")
        local term_win = vim.api.nvim_get_current_win()
        vim.cmd("startinsert")
        vim.api.nvim_create_autocmd("TermClose", {
          buffer = vim.api.nvim_get_current_buf(),
          once = true,
          callback = function()
            if vim.api.nvim_win_is_valid(origin_win) then
              vim.api.nvim_set_current_win(origin_win)
            end
          end,
        })
        -- If the terminal window itself gets closed manually (:q, <C-w>c)
        -- before the job exits, still restore focus rather than falling
        -- through to window #1.
        vim.api.nvim_create_autocmd("WinClosed", {
          pattern = tostring(term_win),
          once = true,
          callback = function()
            if vim.api.nvim_win_is_valid(origin_win) then
              vim.api.nvim_set_current_win(origin_win)
            end
          end,
        })
      end

      local neotest = require("neotest")
      local map = function(keys, func, desc)
        vim.keymap.set("n", keys, func, { desc = "Neotest: " .. desc })
      end
      map("<leader>Tt", function()
        local dir = vim.fn.expand("%:p:h")
        if is_package_scoped(dir) then
          run_scoped_cargo_test(dir)
        else
          neotest.run.run()
        end
      end, "Run nearest test")
      map("<leader>Tf", function()
        local file = vim.fn.expand("%")
        local dir = vim.fn.expand("%:p:h")
        if is_package_scoped(dir) then
          run_scoped_cargo_test(dir)
        else
          neotest.run.run(file)
        end
      end, "Run file")
      map("<leader>Ts", function() neotest.summary.toggle() end, "Toggle summary")
      map("<leader>To", function() neotest.output.open({ enter = true }) end, "Show output")
    end,
  },
}
