return {
  {
    "williamboman/mason.nvim",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
    },
    config = function()
      local mason = require("mason")
      local mason_tool_installer = require("mason-tool-installer")

      -- enable mason and configure icons
      mason.setup({
        ui = {
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
          },
        },
      })

      mason_tool_installer.setup({
        ensure_installed = {
          "prettier", -- prettier formatter
          "stylua", -- lua formatter
          -- "eslint_d",
        },
      })
    end,
  },
  {
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig", "saghen/blink.cmp" },
    -- Loaded on demand from the FileType autocmd below (not via `ft`), since
    -- it can only run against TypeScript < 7 (no lib/tsserver.js in TS 7+).
    lazy = true,
    opts = function()
      return {
        capabilities = require("blink.cmp").get_lsp_capabilities(),
      }
    end,
  },
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "saghen/blink.cmp",
      {
        "antosha417/nvim-lsp-file-operations",
        config = true,
      },
      {
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
          library = {
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
          },
        },
      },
    },
    config = function()
      local capabilities = require("blink.cmp").get_lsp_capabilities(nil, true)
      local mason_lspconfig = require("mason-lspconfig")
      local keymap = vim.keymap

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(event)
          local opts = { buffer = event.buf, silent = true }

          -- NOTE: Remember that Lua is a real programming language, and as such it is possible
          -- to define small helper and utility functions so you don't have to repeat yourself.
          --
          -- In this case, we create a function that lets us more easily define mappings specific
          -- for LSP related items. It sets the mode, buffer and description for us each time.
          local map = function(keys, func, desc, mode)
            mode = mode or "n"
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
          end

          -- Jump to the definition of the word under your cursor.
          --  This is where a variable was first declared, or where a function is defined, etc.
          --  To jump back, press <C-t>.
          map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")

          -- Find references for the word under your cursor.
          map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")

          -- Jump to the implementation of the word under your cursor.
          --  Useful when your language has ways of declaring types without an actual implementation.
          map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")

          -- Jump to the type of the word under your cursor.
          --  Useful when you're not sure what type a variable is and you want to see
          --  the definition of its *type*, not where it was *defined*.
          map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")

          -- Fuzzy find all the symbols in your current document.
          --  Symbols are things like variables, functions, types, etc.
          map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")

          -- Fuzzy find all the symbols in your current workspace.
          --  Similar to document symbols, except searches over your entire project.
          map("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

          -- Rename the variable under your cursor.
          --  Most Language Servers support renaming across files, etc.
          map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")

          -- Execute a code action, usually your cursor needs to be on top of an error
          -- or a suggestion from your LSP for this to activate.
          map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" })

          -- WARN: This is not Goto Definition, this is Goto Declaration.
          --  For example, in C this would take you to the header.
          map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
          map("<leader>cd", vim.diagnostic.open_float, "[C]ode [D]iagnostic")

          opts.desc = "Restart LSP"
          keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary:what

          -- The following two autocommands are used to highlight references of the
          -- word under your cursor when your cursor rests there for a little while.
          --    See `:help CursorHold` for information about when this is executed
          --
          -- When you move your cursor, the highlights will be cleared (the second autocommand).
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
            local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd("LspDetach", {
              group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
              end,
            })
          end

          -- The following code creates a keymap to toggle inlay hints in your
          -- code, if the language server you are using supports them
          --
          -- This may be unwanted, since they displace some of your code
          if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
            map("<leader>th", function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
            end, "[T]oggle Inlay [H]ints")
          end
        end,
      })

      vim.diagnostic.config({
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = " ",
            [vim.diagnostic.severity.WARN] = " ",
            [vim.diagnostic.severity.HINT] = "󰠠 ",
            [vim.diagnostic.severity.INFO] = " ",
          },
        },
      })

      mason_lspconfig.setup({
        ensure_installed = {
          "html",
          "cssls",
          "tailwindcss",
          "svelte",
          "lua_ls",
          "graphql",
          "emmet_ls",
          "prismals",
          "pyright",
        },
        automatic_enable = false,
      })

      vim.lsp.config("*", { capabilities = capabilities })

      -- TypeScript 7+ dropped lib/tsserver.js, which typescript-tools.nvim
      -- depends on, so it can only run against TS < 7. Use nvim-lspconfig's
      -- built-in tsgo (native-preview) config for TS 7+ projects instead.
      -- Decided once per session from the first ts/tsx/js/jsx buffer opened.
      local function ts_major_version(root_dir)
        local pkg_path = root_dir and vim.fs.joinpath(root_dir, "node_modules/typescript/package.json")
        if not pkg_path or vim.fn.filereadable(pkg_path) == 0 then
          return nil
        end
        local ok, pkg = pcall(vim.json.decode, table.concat(vim.fn.readfile(pkg_path), "\n"))
        if not ok or not pkg.version then
          return nil
        end
        return tonumber(pkg.version:match("^(%d+)"))
      end

      -- nvim-lspconfig's tsgo config only ever spawns a binary named `tsgo`,
      -- which exists solely in @typescript/native-preview. Stable typescript@7
      -- ships the same Go language server under the name `tsc` (see
      -- node_modules/typescript/lib/getExePath.js: the bin is `tsgo` only when
      -- the package name isn't `typescript`). Prefer the project's own binary
      -- so diagnostics match what `tsc --noEmit` reports in CI; fall back to a
      -- global `tsgo` for projects without a local install.
      vim.lsp.config("tsgo", {
        cmd = function(dispatchers, config)
          local root_dir = (config or {}).root_dir
          for _, name in ipairs({ "tsc", "tsgo" }) do
            local local_cmd = root_dir and vim.fs.joinpath(root_dir, "node_modules/.bin", name)
            if local_cmd and vim.fn.executable(local_cmd) == 1 then
              return vim.lsp.rpc.start({ local_cmd, "--lsp", "--stdio" }, dispatchers)
            end
          end
          return vim.lsp.rpc.start({ "tsgo", "--lsp", "--stdio" }, dispatchers)
        end,
      })

      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
        once = true,
        callback = function(event)
          local root_dir = vim.fs.root(event.buf, { "package-lock.json", "yarn.lock", "pnpm-lock.yaml", "bun.lockb", "bun.lock", ".git" })
          local major = ts_major_version(root_dir)

          if major and major >= 7 then
            vim.lsp.enable("tsgo")
          else
            require("lazy").load({ plugins = { "typescript-tools.nvim" } })
          end
        end,
      })

      -- Next.js TS plugin bug (code 71007): propType.getStart() returns an
      -- offset from the types file, but `file` is set to the tsx file.
      -- Remap by searching the buffer for the prop name in its destructuring.
      local orig_diag = vim.lsp.handlers["textDocument/publishDiagnostics"]
      vim.lsp.handlers["textDocument/publishDiagnostics"] = function(err, result, ctx, config)
        if result and result.diagnostics then
          local bufnr = vim.uri_to_bufnr(result.uri or "")
          if bufnr and vim.api.nvim_buf_is_loaded(bufnr) then
            local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
            for _, d in ipairs(result.diagnostics) do
              if d.code == 71007 then
                local prop = d.message:match('"(%w+)" is a function')
                if prop then
                  for lnum0, line in ipairs(lines) do
                    -- match prop in a destructuring line: leading spaces + propName alone or with default/comma
                    local col0 = line:find('%f[%w_]' .. prop .. '%f[%W_]')
                    if col0 and line:match('^%s+' .. prop .. '%f[%W_]') then
                      d.range.start.line = lnum0 - 1
                      d.range.start.character = col0 - 1
                      d.range['end'].line = lnum0 - 1
                      d.range['end'].character = col0 - 1 + #prop
                      break
                    end
                  end
                end
              end
            end
          end
        end
        orig_diag(err, result, ctx, config)
      end

      -- pyright does no interpreter discovery of its own: with no explicit
      -- pythonPath it sees only the stdlib plus pyright's ./src heuristic, so
      -- every third-party import (pydantic, fastapi, ...) reports unresolved.
      -- Point it at the project's virtualenv when one exists.
      local function venv_python(root_dir)
        for _, dir in ipairs({ ".venv", "venv" }) do
          local py = vim.fs.joinpath(root_dir or "", dir, "bin", "python")
          if vim.fn.executable(py) == 1 then
            return py
          end
        end
      end

      vim.lsp.config("pyright", {
        -- Mutate settings in place: the client captures `config.settings` by
        -- reference before before_init runs, so reassigning the table is a
        -- no-op as far as the client is concerned.
        before_init = function(_, config)
          local py = venv_python(config.root_dir)
          if py then
            config.settings = config.settings or {}
            config.settings.python = config.settings.python or {}
            config.settings.python.pythonPath = py
          end
        end,
      })

      vim.lsp.enable({ "html", "cssls", "tailwindcss", "prismals", "pyright" })

      vim.lsp.config("svelte", {
        on_attach = function(client)
          vim.api.nvim_create_autocmd("BufWritePost", {
            pattern = { "*.js", "*.ts" },
            callback = function(ctx)
              client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.match })
            end,
          })
        end,
      })
      vim.lsp.enable("svelte")

      vim.lsp.config("graphql", {
        filetypes = { "graphql", "gql", "svelte", "typescriptreact", "javascriptreact" },
      })
      vim.lsp.enable("graphql")

      vim.lsp.config("emmet_ls", {
        filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "svelte" },
      })
      vim.lsp.enable("emmet_ls")

      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
            completion = { callSnippet = "Replace" },
          },
        },
      })
      vim.lsp.enable("lua_ls")
    end,
  },
}
