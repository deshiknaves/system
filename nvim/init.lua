vim.g.mapleader = " "
vim.g.maplocalleader = " "

if vim.g.vscode then
  -- Require VSCode specific configuration
  require("config.vscode")
else
  -- Require Neovim config
  require("config.standalone")
end
