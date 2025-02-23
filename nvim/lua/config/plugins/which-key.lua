return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 500

    local which_key = require("which-key")

    which_key.add({
      { "<leader>c", group = "[C]ode" },
      { "<leader>d", group = "[D]ebugger" },
      { "<leader>e", group = "[E]xplore" },
      { "<leader>f", group = "[F]ind" },
      { "<leader>gr", group = "[G]et [R]eference" },
      { "<leader>h", group = "[H]unks" },
      { "<leader>l", group = "[L]ist" },
      { "<leader>n", group = "[N]o" },
      { "<leader>r", group = "[R]eame" },
      { "<leader>s", group = "[S]plit" },
      { "<leader>t", group = "[T]abs" },
      { "<leader>x", group = "[X] Trouble" },
    })
  end,
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
  },
}
