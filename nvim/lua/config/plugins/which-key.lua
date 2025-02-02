return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 500

    local which_key = require("which-key")

    which_key.add({
      { "<leader>c", group = "Code" },
      { "<leader>e", group = "Explore" },
      { "<leader>f", group = "Find" },
      { "<leader>gr", group = "Reference" },
      { "<leader>h", group = "Hunks" },
      { "<leader>l", group = "List" },
      { "<leader>n", group = "No" },
      { "<leader>r", group = "Rename" },
      { "<leader>s", group = "Split" },
      { "<leader>t", group = "Tabs" },
      { "<leader>x", group = "Trouble" },
    })
  end,
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
  },
}
