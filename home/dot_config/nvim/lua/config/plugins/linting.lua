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
      python = { "ruff" },
    }

    -- mypy needs the project's venv (plugins, installed stubs, editable src
    -- packages); a global mypy reports phantom import errors. Resolve per
    -- buffer, and only run it on write — it is too slow for BufEnter.
    local function project_bin(bufnr, name)
      local root = vim.fs.root(bufnr, { ".venv", "pyproject.toml", ".git" })
      local bin = root and vim.fs.joinpath(root, ".venv", "bin", name)
      return bin and vim.fn.executable(bin) == 1 and bin or name
    end

    local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "FileChangedShellPost" }, {
      group = lint_augroup,
      callback = function()
        local local_bin = vim.fn.findfile("node_modules/.bin/oxlint", ".;")
        lint.linters.oxlint.cmd = local_bin ~= "" and local_bin or "oxlint"
        lint.linters.ruff.cmd = project_bin(0, "ruff")
        lint.try_lint()
      end,
    })

    vim.api.nvim_create_autocmd("BufWritePost", {
      group = lint_augroup,
      pattern = "*.py",
      callback = function(args)
        lint.linters.mypy.cmd = project_bin(args.buf, "mypy")
        lint.try_lint("mypy")
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

    vim.keymap.set("n", "<leader>ll", function()
      lint.try_lint()
    end, { desc = "[L]int trigger" })
  end,
}
