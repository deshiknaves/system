local set = vim.opt_local
set.foldmethod = "expr"
set.foldexpr = "v:lua.require'config.markdown_details'.foldexpr()"
set.foldtext = "v:lua.require'config.markdown_details'.foldtext()"
set.foldenable = true
-- Only <details> blocks fold, so level 0 starts them all collapsed.
set.foldlevel = 0
