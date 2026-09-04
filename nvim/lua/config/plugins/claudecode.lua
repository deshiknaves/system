return {
  "coder/claudecode.nvim",
  dependencies = { "folke/snacks.nvim" },
  config = true,
  keys = {
    { "<leader>ac", "<cmd>ClaudeCode<CR>", desc = "[A]I [C]laude toggle" },
    { "<leader>af", "<cmd>ClaudeCodeFocus<CR>", desc = "[A]I Claude [F]ocus" },
    { "<leader>ar", "<cmd>ClaudeCode --resume<CR>", desc = "[A]I Claude [R]esume" },
    { "<leader>aC", "<cmd>ClaudeCode --continue<CR>", desc = "[A]I Claude [C]ontinue" },
    { "<leader>ab", "<cmd>ClaudeCodeAdd %<CR>", desc = "[A]I Claude add [B]uffer" },
    { "<leader>as", "<cmd>ClaudeCodeSend<CR>", mode = "v", desc = "[A]I Claude [S]end" },
    { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<CR>", desc = "[A]I Claude diff [A]ccept" },
    { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<CR>", desc = "[A]I Claude [D]eny diff" },
  },
}
