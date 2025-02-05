require("config.lazy")

local opt = vim.opt

opt.relativenumber = true
opt.number = true
opt.autoindent = true

vim.opt.undofile = true

opt.ignorecase = true
opt.smartcase = true

opt.cursorline = true

opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes"

opt.backspace = { "indent", "eol", "start" }

opt.splitright = true
opt.splitbelow = true

vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Decrease update time
opt.updatetime = 250

-- Decrease mapped sequence wait time
opt.timeoutlen = 300

-- Spaces instead of tabs
vim.o.shiftwidth = 4
vim.opt.clipboard = "unnamedplus"

vim.opt.inccommand = "split"

-- Import configuration from standalone
require("config.standalone.floaterminal")
require("config.standalone.keymaps")
require("config.standalone.menu")
require("config.standalone.options")

vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("kickstart-hightlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.api.nvim_create_autocmd("TermOpen", {
  group = vim.api.nvim_create_augroup("custom-term-open", { clear = true }),
  callback = function()
    vim.opt.number = false
    vim.opt.relativenumber = false
  end,
})

local job_id = 0
vim.keymap.set("n", "<space>st", function()
  vim.cmd.vnew()
  vim.cmd.term()
  vim.cmd.wincmd("J")
  vim.api.nvim_win_set_height(0, 15)

  job_id = vim.bo.channel
end)

vim.keymap.set("n", "<space>example", function()
  vim.fn.chansend(job_id, { "ls -al\r\n" })
end)

vim.keymap.set("n", "-", "<cmd>Oil<CR>")

-- Spell checking
vim.opt.spelllang = "en_us"
vim.opt.spell = true
