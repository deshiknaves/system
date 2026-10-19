return {
  {
    "nvim-telescope/telescope.nvim",
    tag = "v0.2.2",
    -- or                              , branch = '0.1.x',
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    config = function()
      require("telescope").setup({
        pickers = {
          find_files = {
            theme = "ivy",
          },
        },
        mappings = {
          i = {
            ["<C-j>"] = require("telescope.actions").move_selection_next,
            ["<C-k>"] = require("telescope.actions").move_selection_previous,
            ["<C-q>"] = require("telescope.actions").send_to_qflist,
          },
        },
        extensions = {
          fzf = {},
        },
      })

      require("telescope").load_extension("fzf")

      local keymap = vim.keymap

      local builtin = require("telescope.builtin")
      keymap.set("n", "<leader>hh", builtin.git_bcommits, { desc = "Git [H]istory for file" })

      keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "[F]ind [H]elp" })
      keymap.set("n", "<leader>fk", builtin.keymaps, { desc = "[F]ind [K]eymaps" })
      keymap.set("n", "<leader>ff", builtin.find_files, { desc = "[F]ind [F]iles" })
      -- Exclusions live in the fd invocation, not `file_ignore_patterns`: the
      -- latter filters after the walk, so the cost of descending into
      -- node_modules/.venv is still paid. `-E` prunes the traversal instead.
      keymap.set("n", "<leader>fa", function()
        builtin.find_files({
          find_command = {
            "fd",
            "--type",
            "f",
            "--color",
            "never",
            "--hidden",
            "--no-ignore",
            "-E",
            "node_modules",
            "-E",
            ".venv",
            "-E",
            "__pycache__",
            "-E",
            ".mypy_cache",
            "-E",
            ".ruff_cache",
            "-E",
            ".pytest_cache",
            "-E",
            ".turbo",
            "-E",
            ".git",
          },
        })
      end, { desc = "[F]ind [A]ll files (incl. hidden/ignored)" })
      keymap.set("n", "<leader>fs", builtin.builtin, { desc = "[F]ind [S]elect Telescope" })
      keymap.set("n", "<leader>fw", builtin.grep_string, { desc = "[F]ind current [W]ord" })
      keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "[F]ind by [G]rep" })
      keymap.set("n", "<leader>fd", builtin.diagnostics, { desc = "[F]ind [D]iagnostics" })
      keymap.set("n", "<leader>fr", builtin.resume, { desc = "[F]ind [R]esume" })
      keymap.set("n", "<leader>cl", builtin.filetypes, { desc = "[C]ode [L]anguage" })
      keymap.set("n", "<leader>f.", builtin.oldfiles, { desc = '[F]ind Recent Files ("." for repeat)' })
      keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })
      keymap.set(
        "n",
        "<space>fc",
        require("telescope.builtin").grep_string,
        { desc = "Find string under cursor in cwd" }
      )
      keymap.set("n", "<space>ft", "<cmd>TodoTelescope<cr>", { desc = "Find todos" })

      keymap.set("n", "<space>fn", function()
        require("telescope.builtin").find_files({
          cwd = vim.fn.stdpath("config"),
        })
      end, { desc = "[F]ind [N]eovim config" })

      keymap.set("n", "<space>fp", function()
        require("telescope.builtin").find_files({
          cwd = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy"),
        })
      end, { desc = "[F]ind [P]lugins" })

      -- Slightly advanced example of overriding default behavior and theme
      vim.keymap.set("n", "<leader>/", function()
        -- You can pass additional configuration to Telescope to change the theme, layout, etc.
        builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
          winblend = 10,
          previewer = false,
        }))
      end, { desc = "[/] Fuzzily search in current buffer" })

      -- It's also possible to pass additional configuration options.
      --  See `:help telescope.builtin.live_grep()` for information about particular keys
      vim.keymap.set("n", "<leader>f/", function()
        builtin.live_grep({
          grep_open_files = true,
          prompt_title = "Live Grep in Open Files",
        })
      end, { desc = "[F]ind [/] in Open Files" })

      require("config.telescope.multigrep").setup()
    end,
  },
}
