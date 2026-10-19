return {
  "folke/flash.nvim",
  event = "VeryLazy",
  opts = {},
  keys = {
    {
      "<CR>",
      mode = { "n", "x", "o" },
      function()
        if vim.bo.buftype == "" then
          require("flash").jump()
        else
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<CR>", true, false, true), "n", false)
        end
      end,
      desc = "Flash",
    },
    {
      "<S-CR>",
      mode = { "n", "x", "o" },
      function()
        require("flash").treesitter()
      end,
      desc = "Flash Treesitter",
    },
    {
      "r",
      mode = "o",
      function()
        require("flash").remote()
      end,
      desc = "Remote Flash",
    },
    {
      "R",
      mode = { "o", "x" },
      function()
        require("flash").treesitter_search()
      end,
      desc = "Treesitter Search",
    },
    {
      "<c-s>",
      mode = "c",
      function()
        require("flash").toggle()
      end,
      desc = "Toggle Flash Search",
    },
  },
}
