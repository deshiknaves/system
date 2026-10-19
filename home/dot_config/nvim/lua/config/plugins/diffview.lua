return {
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewFileHistory", "DiffviewClose" },
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<CR>", desc = "[G]it [D]iff" },
      { "<leader>gh", "<cmd>DiffviewFileHistory<CR>", desc = "[G]it [H]istory" },
      { "<leader>gH", "<cmd>DiffviewFileHistory %<CR>", desc = "[G]it [H]istory (file)" },
      { "<leader>gx", "<cmd>DiffviewClose<CR>", desc = "[G]it Close diff" },
    },
    opts = {},
  },
  {
    "akinsho/git-conflict.nvim",
    version = "*",
    event = { "BufReadPre" },
    opts = { default_mappings = true },
  },
}
