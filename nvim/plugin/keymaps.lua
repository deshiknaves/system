local keymap = vim.keymap

-- Execute
keymap.set("n", "<space><space>x", "<cmd>source %<CR>", { desc = "Source current file" })
keymap.set("n", "<space>xc", ":.lua<CR>", { desc = "Execute current line" })
keymap.set("v", "<space>xc", ":.lua<CR>", { desc = "Execute selected lines" })

-- LSP keys
keymap.set('n', 'grn', vim.lsp.buf.rename, { desc = "Rename references" })
keymap.set('n', 'gra', vim.lsp.buf.code_action, { desc = "Code action" })
keymap.set('n', 'grr', vim.lsp.buf.references, { desc = "Show references" })

-- Quickview
keymap.set("n", "<M-j>", "<cmd>cnext<CR>", { desc = "Next quickfix" })
keymap.set("n", "<M-k>", "<cmd>cprev<CR>", { desc = "Previous quickfix" })

-- Highlights
keymap.set("n", "<leader>nh", "<cmd>noh<CR>", { desc = "Clear highlights" })

-- Increment and decrement numbers
keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" })
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" })

-- Window  management
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" })
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" })
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Equalize windows" })
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current window" })

-- Tabs management
keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "New tab" })
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close tab" })
keymap.set("n", "<leader>tn", "<cmd>tabnext<CR>", { desc = "Next tab" })
keymap.set("n", "<leader>tp", "<cmd>tabprevious<CR>", { desc = "Previous tab" })
keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" })
