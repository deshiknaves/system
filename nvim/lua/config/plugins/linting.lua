return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local lint = require("lint")

    lint.linters_by_ft = {
      javascript = { "oxlint" },
      typescript = { "oxlint" },
      javascriptreact = { "oxlint" },
      typescriptreact = { "oxlint" },
      python = { "pylint" },
    }

    local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "FileChangedShellPost" }, {
      group = lint_augroup,
      callback = function()
        local local_bin = vim.fn.findfile("node_modules/.bin/oxlint", ".;")
        lint.linters.oxlint.cmd = local_bin ~= "" and local_bin or "oxlint"
        lint.try_lint()
      end,
    })

    local fix_augroup = vim.api.nvim_create_augroup("oxlint_fix", { clear = true })

    vim.api.nvim_create_autocmd("BufWritePost", {
      group = fix_augroup,
      pattern = { "*.js", "*.ts", "*.jsx", "*.tsx" },
      callback = function(args)
        local file = vim.api.nvim_buf_get_name(args.buf)
        local local_bin = vim.fn.findfile("node_modules/.bin/oxlint", vim.fn.fnamemodify(file, ":h") .. ";")
        local cmd = local_bin ~= "" and local_bin or "oxlint"
        vim.system({ cmd, "--fix", file }, { text = true }, function()
          vim.schedule(function()
            vim.cmd("checktime")
          end)
        end)
      end,
    })

    vim.keymap.set("n", "<leader>cl", function()
      lint.try_lint()
    end, { desc = "Trigger linting for current file" })
  end,
}
