return {
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.8',
    -- or                              , branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' }
    },
    config = function()
      require("telescope").setup {
        pickers = {
          find_files = {
            theme = 'ivy'
          }
        },
        mappings = {
          i = {
            ["<C-j>"] = require('telescope.actions').move_selection_next,
            ["<C-k>"] = require('telescope.actions').move_selection_previous,
            ["<C-q>"] = require('telescope.actions').send_to_qflist
          }
        },
        extensions = {
          fzf = {}
        }
      }

      require('telescope').load_extension('fzf')

      local keymap = vim.keymap

      keymap.set("n", "<space>fh", require('telescope.builtin').help_tags, { desc = "Find in help" })
      keymap.set("n", "<space>ff", require('telescope.builtin').find_files, { desc = "Find files" })
      keymap.set("n", "<space>fr", require('telescope.builtin').oldfiles, { desc = "Find recent" })
      keymap.set("n", "<space>fg", require('telescope.builtin').live_grep, { desc = "Find grep" })
      keymap.set("n", "<space>fc", require('telescope.builtin').grep_string, { desc = "Find string under cursor in cwd" })
      keymap.set("n", "<space>ft", "<cmd>TodoTelescope<cr>", { desc = "Find todos" })
      keymap.set("n", "<space>en", function()
        require("telescope.builtin").find_files {
          cwd = vim.fn.stdpath("config")
        }
      end, { desc = "Find config" })

      keymap.set("n", "<space>ep", function()
        require('telescope.builtin').find_files {
          cwd = vim.fs.joinpath(vim.fn.stdpath("data"), 'lazy')
        }
      end, { desc = "Find plugins" })

      require "config.telescope.multigrep".setup()
    end
  }
}
