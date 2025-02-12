return {
  {
    "esmuellert/nvim-eslint",
    config = function()
      local capabilities = require("blink.cmp").get_lsp_capabilities()

      require("nvim-eslint").setup({
        capabilities = capabilities,
        on_attach = function(client, bufnr)
          client.server_capabilities.documentFormattingProvider = true

          local format = function()
            vim.lsp.buf.format({ timeout_ms = 2000 })
          end

          vim.keymap.set("n", "<leader>lf", format, { silent = true, buffer = bufnr, desc = "eslint fix" })
        end,
        settings = {
          codeActionOnSave = {
            mode = "all",
          },
          format = true,
        },
      })
    end,
  },
}
