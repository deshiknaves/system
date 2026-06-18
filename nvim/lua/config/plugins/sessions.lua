return {
  "rmagatti/auto-session",
  config = function()
    -- Persist buffer-local filetype in the session so restored buffers fire
    -- FileType -> nvim-treesitter (main) starts highlighting. Without this,
    -- session restore loads buffers with empty filetype and no highlighting.
    vim.opt.sessionoptions:append("localoptions")

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
