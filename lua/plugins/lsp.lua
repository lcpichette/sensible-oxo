local CONFIG = require("oxo_config")

return {
  -- dressing.nvim: Improve Neovim's UI for input and selection
  {
    "stevearc/dressing.nvim",
    event = "VeryLazy", -- Load the plugin when Neovim is idle
    enabled = CONFIG.dressing,
    opts = {
      -- Customize the UI components
      input = {
        -- Default options for input UI
        enabled = true,
        default_prompt = "➤ ",
        prompt_align = "left",
        insert_only = true,
        start_in_insert = true,
        relative = "editor",
        prefer_width = 60,
        width = nil,
        max_width = nil,
        min_width = 20,
        border = "rounded",
        anchor = "NW",
        pos = "100%",
        row = 1,
        col = 1,
      },
      select = {
        -- Default options for select UI
        enabled = true,
        backend = { "telescope", "builtin" },
        builtin = {
          -- Customize the selection UI
          border = "rounded",
          -- Position the selection window at the top
          anchor = "NW",
          -- Optional: Adjust the position offset
          post = "100%",
        },
      },
    },
    config = function(_, opts)
      require("dressing").setup(opts)
    end,
  },

  -- Mason setup for LSP installation and configuration
  {
    "williamboman/mason.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
      "williamboman/mason-lspconfig.nvim",
    },
    cmd = { "Mason", "MasonInstall", "MasonUpdate" },
    config = function()
      require("mason").setup()

      -- Ensure FORMATTERS are installed
      local mason_registry = require("mason-registry")
      local ensure_installed = {
        "stylua",
        "prettierd",
        "dprint",
      }

      for _, tool in ipairs(ensure_installed) do
        local p = mason_registry.get_package(tool)
        if not p:is_installed() then
          p:install()
        end
      end

      -- Ensure LSPs are installed
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",
          "ts_ls",
          "tailwindcss",
          "cssls",
          "html",
          "zls",
          "somesass_ls",
          "angularls",
          "eslint",
        },
        automatic_installation = true,
      })

      -- Reusable capabilities for LSPs
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities.textDocument.completion.completionItem.snippetSupport = true

      local lspconfig = require("lspconfig")

      -- LSP-specific setup handlers
      require("mason-lspconfig").setup_handlers({
        -- TailwindCSS configuration
        ["tailwindcss"] = function()
          lspconfig.tailwindcss.setup({
            filetypes = { "css", "scss", "svelte", "html" },
            root_dir = lspconfig.util.root_pattern(
              "tailwind.config.js",
              "tailwind.config.ts",
              "postcss.config.js",
              "postcss.config.ts",
              ".git"
            ),
          })
        end,

        -- HTML configuration
        ["html"] = function()
          lspconfig.html.setup({
            capabilities = capabilities,
            filetypes = { "html", "nml", "templ" },
            root_dir = lspconfig.util.root_pattern(".git", "package.json"),
          })
        end,

        -- SOMESASS configuration
        ["somesass_ls"] = function()
          lspconfig.somesass_ls.setup({
            capabilities = capabilities,
            filetypes = { "scss", "less" },
            root_dir = lspconfig.util.root_pattern(".git", "package.json"),
          })
        end,

        -- CSSLS configuration
        ["cssls"] = function()
          lspconfig.cssls.setup({
            capabilities = capabilities,
            filetypes = { "css" },
            root_dir = lspconfig.util.root_pattern(".git", "package.json"),
          })
        end,

        -- Lua-language-server configuration
        ["lua_ls"] = function()
          lspconfig.lua_ls.setup({
            settings = {
              Lua = {
                runtime = { version = "LuaJIT" },
                diagnostics = { globals = { "vim" } },
                workspace = { library = vim.api.nvim_get_runtime_file("", true) },
                telemetry = { enable = false },
              },
            },
          })
        end,

        -- TypeScript server configuration
        ["ts_ls"] = function()
          lspconfig.ts_ls.setup({
            filetypes = {
              "javascript",
              "typescript",
            },
            settings = {
              javascript = {
                suggest = {
                  autoImports = true,
                },
              },
              typescript = {
                suggest = {
                  autoImports = true,
                },
              },
            },
          })
        end,

        ["eslint"] = function()
          lspconfig.eslint.setup({
            filetypes = {
              "javascript",
              "javascriptreact",
              "javascript.jsx",
              "typescript",
              "typescriptreact",
              "typescript.tsx",
              "vue",
              "svelte",
              "astro",
            },
            root_dir = lspconfig.util.root_pattern("."),
            settings = {
              javascript = {
                suggest = {
                  autoImports = true,
                },
              },
              typescript = {
                suggest = {
                  autoImports = true,
                },
              },
            },
          })
        end,

        ["angularls"] = function()
          lspconfig.angularls.setup({
            filetypes = { "css" },
            root_dir = lspconfig.util.root_pattern(".git", "package.json"),
            settings = {
              javascript = {
                suggest = {
                  autoImports = true,
                },
              },
              typescript = {
                suggest = {
                  autoImports = true,
                },
              },
            },
          })
        end,

        -- Zig language server configuration
        ["zls"] = function()
          lspconfig.zls.setup({
            capabilities = capabilities,
            filetypes = { "zig" },
            root_dir = lspconfig.util.root_pattern(".git", "build.zig"),
          })
        end,
      })
    end,
  },

  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },

  -- DAP
  {
    "nvim-neotest/nvim-nio",
    enabled = CONFIG.dap,
    lazy = true, -- Optional: Load only when needed
  },

  {
    "mfussenegger/nvim-dap",
    enabled = CONFIG.dap,
    dependencies = { "nvim-neotest/nvim-nio" },
    config = function()
      local dap = require("dap")

      vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = "" }) -- Small red circle
      vim.fn.sign_define(
        "DapBreakpointCondition",
        { text = "", texthl = "DapBreakpointCondition", linehl = "", numhl = "" }
      ) -- Branch icon
      vim.fn.sign_define(
        "DapBreakpointRejected",
        { text = "", texthl = "DapBreakpointRejected", linehl = "", numhl = "" }
      ) -- Small X
      vim.fn.sign_define("DapLogPoint", { text = "", texthl = "DapLogPoint", linehl = "", numhl = "" }) -- Log icon

      vim.api.nvim_set_hl(0, "DapBreakpoint", { fg = "#ee5396" }) -- Breakpoint: Subtle red
      vim.api.nvim_set_hl(0, "DapBreakpointCondition", { fg = "#ff832b" }) -- Conditional: Soft orange
      vim.api.nvim_set_hl(0, "DapBreakpointRejected", { fg = "#fa4d56" }) -- Rejected: Muted red
      vim.api.nvim_set_hl(0, "DapLogPoint", { fg = "#42be65" }) -- Log point: Calm green

      -- Lua adapter configuration
      dap.adapters.nlua = function(callback, config)
        callback({
          type = "server",
          host = config.host or "127.0.0.1",
          port = config.port or 8086,
        })
      end

      -- Lua configuration for debugging
      dap.configurations.lua = {
        {
          type = "nlua",
          request = "attach",
          name = "Attach to Neovim",
          host = function()
            return "127.0.0.1"
          end,
          port = function()
            return 8086
          end,
        },
      }
    end,
    keys = {
      {
        "<leader>bn",
        function()
          require("dap").continue()
        end,
        desc = "Start/Continue Debugging",
      },
      {
        "<leader>bv",
        function()
          require("dap").step_over()
        end,
        desc = "Step Over",
      },
      {
        "<leader>bi",
        function()
          require("dap").step_into()
        end,
        desc = "Step Into",
      },
      {
        "<leader>bo",
        function()
          require("dap").step_out()
        end,
        desc = "Step Out",
      },
      {
        "<leader>bb",
        function()
          require("dap").toggle_breakpoint()
        end,
        desc = "Toggle Breakpoint",
      },
      {
        "<leader>bc",
        function()
          require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
        end,
        desc = "Set Conditional Breakpoint",
      },
      {
        "<leader>br",
        function()
          require("dap").repl.open()
        end,
        desc = "Open Debug REPL",
      },
      {
        "<leader>bl",
        function()
          require("dap").run_last()
        end,
        desc = "Run Last Debugging Session",
      },
    },
  },

  -- UI for DAP
  {
    "rcarriga/nvim-dap-ui",
    enabled = CONFIG.dap,
    opts = {
      layouts = {
        {
          elements = {
            "scopes",
            "breakpoints",
            "stacks",
            "watches",
          },
          size = 40,
          position = "left",
        },
        {
          elements = {
            "repl",
            "console",
          },
          size = 10,
          position = "bottom",
        },
      },
    },
    config = function(_, opts)
      local dapui = require("dapui")
      dapui.setup(opts)

      local dap = require("dap")
      vim.keymap.set("n", "<leader>bu", dapui.toggle, { desc = "Toggle DAP UI" })
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
    end,
  },

  -- Virtual text for DAP
  {
    "theHamsta/nvim-dap-virtual-text",
    enabled = CONFIG.dap,
    opts = {
      commented = true,
    },
  },
}
