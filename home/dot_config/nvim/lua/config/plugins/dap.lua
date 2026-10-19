return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "nvim-neotest/nvim-nio",
    "theHamsta/nvim-dap-virtual-text",
    "jay-babu/mason-nvim-dap.nvim",
  },
  keys = {
    {
      "<F5>",
      function()
        require("dap").continue()
      end,
      desc = "Debug: Continue",
    },
    {
      "<F10>",
      function()
        require("dap").step_over()
      end,
      desc = "Debug: Step Over",
    },
    {
      "<F11>",
      function()
        require("dap").step_into()
      end,
      desc = "Debug: Step Into",
    },
    {
      "<F12>",
      function()
        require("dap").step_out()
      end,
      desc = "Debug: Step Out",
    },
    {
      "<leader>db",
      function()
        require("dap").toggle_breakpoint()
      end,
      desc = "Debug: Toggle Breakpoint",
    },
    {
      "<leader>dB",
      function()
        vim.ui.input({ prompt = "Breakpoint condition: " }, function(condition)
          if condition then
            require("dap").set_breakpoint(condition)
          end
        end)
      end,
      desc = "Debug: Conditional Breakpoint",
    },
    {
      "<leader>dc",
      function()
        require("dap").continue()
      end,
      desc = "Debug: Continue",
    },
    {
      "<leader>dl",
      function()
        require("dap").run_last()
      end,
      desc = "Debug: Run Last",
    },
    {
      "<leader>dr",
      function()
        require("dap").repl.toggle()
      end,
      desc = "Debug: Toggle REPL",
    },
    {
      "<leader>du",
      function()
        require("dapui").toggle()
      end,
      desc = "Debug: Toggle UI",
    },
    {
      "<leader>dx",
      function()
        require("dap").terminate()
      end,
      desc = "Debug: Terminate",
    },
  },
  config = function()
    local dap = require("dap")
    local dapui = require("dapui")

    require("mason-nvim-dap").setup({
      ensure_installed = { "codelldb", "js", "python" },
      automatic_installation = true,
      handlers = {},
    })

    dapui.setup()
    require("nvim-dap-virtual-text").setup()

    dap.listeners.after.event_initialized["dapui_config"] = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
      dapui.close()
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
      dapui.close()
    end

    -- rust is handled by rustaceanvim, not configured here.
    local js_debug_adapter = {
      type = "server",
      host = "localhost",
      port = "${port}",
      executable = {
        command = "js-debug-adapter",
        args = { "${port}" },
      },
    }
    dap.adapters["pwa-node"] = js_debug_adapter

    local js_configurations = {
      {
        type = "pwa-node",
        request = "launch",
        name = "Launch file",
        program = "${file}",
        cwd = "${workspaceFolder}",
      },
      {
        type = "pwa-node",
        request = "attach",
        name = "Attach to process",
        port = 9229,
        cwd = "${workspaceFolder}",
      },
    }

    for _, filetype in ipairs({ "javascript", "typescript", "javascriptreact", "typescriptreact" }) do
      dap.configurations[filetype] = js_configurations
    end

    vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = "" })
    vim.fn.sign_define("DapStopped", { text = "→", texthl = "DapStopped", linehl = "", numhl = "" })
  end,
}
