local vscode = require("vscode")
local opt = vim.opt
local keymap = vim.keymap

opt.ignorecase = true
opt.smartcase = true

vim.opt.clipboard = "unnamedplus"

keymap.set("n", "<leader>nh", "<cmd>noh<CR>", { desc = "Clear highlights" })

-- Window  management
keymap.set("n", "<leader>wv", function()
  vscode.call("workbench.action.splitEditor")
end)
keymap.set("n", "<leader>wh", function()
  vscode.call("workbench.action.splitEditorOrthogonal")
end)
keymap.set("n", "<leader>wx", function()
  vscode.call("workbench.action.closeGroup")
end)

-- Tabs management
keymap.set("n", "<leader>to", function()
  vscode.call("workbench.action.newGroupRight")
end)
keymap.set("n", "<leader>tx", function()
  vscode.call("workbench.action.closeActiveEditor")
end)
keymap.set("n", "<leader>tn", function()
  vscode.call("workbench.action.nextEditor")
end)
keymap.set("n", "<leader>tp", function()
  vscode.call("workbench.action.previousEditor")
end)
keymap.set("n", "<leader>tf", function()
  vscode.call("workbench.action.moveEditorToNextGroup")
end)

-- File management

keymap.set("n", "<leader>ff", function()
  vscode.call("workbench.action.quickOpen")
end)

keymap.set("n", "<leader>fe", function()
  vscode.call("workbench.action.openRecent")
end)

-- Go to next problem
keymap.set("n", "<leader>xn", function()
  vscode.call("editor.action.marker.next")
end)

-- Go to previous problem
keymap.set("n", "<leader>xp", function()
  vscode.call("editor.action.marker.prev")
end)
