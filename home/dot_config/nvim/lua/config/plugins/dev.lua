return {
  {
    dir = vim.fn.stdpath("config") .. "/plugins/present.nvim",
    config = function()
      require("present")
    end,
  },
}
