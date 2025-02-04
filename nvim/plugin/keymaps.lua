local keymap = vim.keymap

-- Execute
keymap.set("n", "<space><space>x", "<cmd>source %<CR>", { desc = "Source current file" })
keymap.set("n", "<space>xc", ":.lua<CR>", { desc = "Execute current line" })
keymap.set("v", "<space>xc", ":.lua<CR>", { desc = "Execute selected lines" })

-- LSP keys
keymap.set("n", "grn", vim.lsp.buf.rename, { desc = "Rename references" })
keymap.set("n", "gra", vim.lsp.buf.code_action, { desc = "Code action" })
keymap.set("n", "grr", vim.lsp.buf.references, { desc = "Show references" })

-- Quickview
keymap.set("n", "<M-j>", "<cmd>cnext<CR>", { desc = "Next quickfix" })
keymap.set("n", "<M-k>", "<cmd>cprev<CR>", { desc = "Previous quickfix" })

-- Highlights
keymap.set("n", "<leader>nh", "<cmd>noh<CR>", { desc = "Clear highlights" })

-- Increment and decrement numbers
keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" })
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" })

-- Window  management
keymap.set("n", "<leader>wv", "<C-w>v", { desc = "Split [W]indow vertically" })
keymap.set("n", "<leader>wh", "<C-w>s", { desc = "Split [W]indow horizontally" })
keymap.set("n", "<leader>we", "<C-w>=", { desc = "[E]qualize [W]indows" })
keymap.set("n", "<leader>wx", "<cmd>close<CR>", { desc = "Close current [W]indow" })

-- Tabs management
keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "New tab" })
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close tab" })
keymap.set("n", "<leader>tn", "<cmd>tabnext<CR>", { desc = "Next tab" })
keymap.set("n", "<leader>tp", "<cmd>tabprevious<CR>", { desc = "Previous tab" })
keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" })

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Diagnostic keymaps
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })
