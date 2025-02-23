return {
  "rmagatti/auto-session",
  config = function()
    require("auto-session").setup({
      pre_save_cmds = { "NvimTreeClose" },
      suppressed_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
      session_lens = {
        load_on_setup = true,
        theme_conf = { border = true },
        previewer = false,
      },
      vim.keymap.set("n", "<Leader>ls", require("auto-session.session-lens").search_session, { noremap = true }),
    })
  end,
}
