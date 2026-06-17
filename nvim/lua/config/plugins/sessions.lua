return {
  "rmagatti/auto-session",
  config = function()
    require("auto-session").setup({
      suppressed_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
      session_lens = {
        load_on_setup = true,
        theme_conf = { border = true },
        previewer = false,
      },
    })
    vim.keymap.set("n", "<Leader>ls", "<cmd>AutoSession search<cr>", { noremap = true })
  end,
}
