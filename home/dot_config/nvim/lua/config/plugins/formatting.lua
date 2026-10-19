return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local conform = require("conform")

    conform.formatters.oxfmt = {
      command = function(_, ctx)
        local local_bin = vim.fn.findfile("node_modules/.bin/oxfmt", ctx.dirname .. ";")
        if local_bin ~= "" then return local_bin end
        local cwd_bin = vim.fn.findfile("node_modules/.bin/oxfmt", vim.fn.getcwd() .. ";")
        return cwd_bin ~= "" and cwd_bin or "oxfmt"
      end,
      args = { "--stdin-filepath", "$FILENAME" },
      stdin = true,
    }

    conform.setup({
      formatters_by_ft = {
        javascript = { "oxfmt" },
        typescript = { "oxfmt" },
        javascriptreact = { "oxfmt" },
        typescriptreact = { "oxfmt" },
        svelte = { "prettier" },
        css = { "prettier" },
        html = { "prettier" },
        json = { "prettier" },
        yaml = { "prettier" },
        markdown = { "oxfmt" },
        graphql = { "prettier" },
        liquid = { "prettier" },
        lua = { "stylua" },
        python = { "ruff_organize_imports", "black" },
      },
      format_on_save = {
        lsp_fallback = true,
        async = false,
        timeout_ms = 1000,
      },
    })

    vim.keymap.set({ "n", "v" }, "<leader>mp", function()
      conform.format({
        lsp_fallback = true,
        async = false,
        timeout_ms = 1000,
      })
    end, { desc = "Format file or range (in visual mode)" })
  end,
}
