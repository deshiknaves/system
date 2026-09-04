return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 500

    local which_key = require("which-key")

    which_key.add({
      { "<leader>a", group = "[A]I" },
      { "<leader>c", group = "[C]ode" },
      { "<leader>d", group = "[D]ebug" },
      { "<leader>e", group = "[E]xplore" },
      { "<leader>f", group = "[F]ind" },
      { "<leader>g", group = "[G]it" },
      { "<leader>gr", group = "[G]et [R]eference" },
      { "<leader>h", group = "[H]unks" },
      { "<leader>l", group = "[L]ist" },
      { "<leader>m", group = "For[M]at" },
      { "<leader>n", group = "[N]o" },
      { "<leader>r", group = "[R]ename" },
      { "<leader>s", group = "[S]plit" },
      { "<leader>t", group = "[T]abs" },
      { "<leader>T", group = "[T]ests" },
      { "<leader>w", group = "[W]indow" },
      { "<leader>x", group = "[X] Trouble" },
      { "<leader>y", group = "[Y]ank" },
    })
  end,
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
  },
}
