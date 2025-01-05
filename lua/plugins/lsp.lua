local DAP_ENABLED = false

return {
  -- dressing.nvim: Improve Neovim's UI for input and selection
  {
    "stevearc/dressing.nvim",
    event = "VeryLazy", -- Load the plugin when Neovim is idle
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

      -- Ensure formatters are installed
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
        ensure_installed = { "lua_ls", "ts_ls", "tailwindcss", "cssls", "html", "zls" },
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

        -- CSSLS configuration
        ["cssls"] = function()
          lspconfig.cssls.setup({
            capabilities = capabilities,
            filetypes = { "css", "scss", "less" },
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


  -- lualine, bottom status line
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local lualine = require("lualine")

      -- Helper function to abbreviate the folder path
      local function abbreviate_path(filepath)
        local parts = vim.split(filepath, "/")
        for i = 1, #parts - 1 do
          parts[i] = parts[i]:sub(1, 2) -- Keep only the first 2 characters of each folder
        end
        return table.concat(parts, "/")
      end

      -- Custom filename component with abbreviated folders
      local function custom_filename()
        local filepath = vim.fn.expand("%:p") -- Full file path
        local relative_path = vim.fn.fnamemodify(filepath, ":~:.:") -- Relative to cwd
        return abbreviate_path(relative_path)
      end

      -- Define Oxocarbon color palette
      local oxo = {
        fg = "#c0caf5", -- Default foreground
        purple = "#bb9af7", -- Purple
        blue = "#7aa2f7", -- Blue
        green = "#7dcfff",
        red = "#f7768e", -- Red for diagnostics
        yellow = "#f49800",
      }

      -- Custom lualine theme with no background colors
      local custom_theme = {
        normal = {
          a = { fg = oxo.purple, gui = "bold" },
          b = { fg = oxo.fg },
          c = { fg = oxo.fg },
        },
        insert = { a = { fg = oxo.blue, gui = "bold" } },
        visual = { a = { fg = oxo.purple, gui = "bold" } },
        replace = { a = { fg = oxo.red, gui = "bold" } },
        inactive = {
          a = { fg = oxo.fg },
          b = { fg = oxo.fg },
          c = { fg = oxo.fg },
        },
      }

      -- Helper function to get active LSP servers
      local function lsp_info()
        local clients = vim.lsp.get_clients({ bufnr = 0 })
        if #clients == 0 then
          return ""
        end
        local names = {}
        for _, client in ipairs(clients) do
          table.insert(names, client.name)
        end
        return "⦿ " .. table.concat(names, ", ")
      end

      -- Helper function to get active linters using nvim_lint
      local function linters_info()
        local lint = require("lint")
        local filetype = vim.bo.filetype
        local linters = lint.linters_by_ft[filetype] or {}
        if #linters == 0 then
          return ""
        end
        return "▣ " .. table.concat(linters, ", ")
      end

      -- Configure lualine
      lualine.setup({
        options = {
          theme = custom_theme,
          section_separators = "",
          component_separators = "",
          disabled_filetypes = { statusline = {}, winbar = {} },
          always_divide_middle = false,
          globalstatus = true, -- Requires Neovim 0.7+
        },
        sections = {
          -- Left sections
          lualine_a = {
            {
              "mode",
              fmt = function(mode)
                return mode:sub(1, 1)
              end,
              color = { fg = oxo.purple, gui = "bold" },
            },
          },
          lualine_b = { "branch" },
          -- Center is empty for minimalism
          lualine_c = {},
          -- Right sections
          lualine_x = {
            {
              custom_filename,
              symbols = { modified = " ●", readonly = " 🔒", unnamed = "" },
            },
          },
          lualine_y = {
            {
              "diagnostics",
              sources = { "nvim_lsp" },
              symbols = {
                error = "✗ ",
                warn = "▲ ",
                info = "i ",
                hint = "☀ ",
              },
              diagnostics_color = {
                color_error = { fg = oxo.red },
                color_warn = { fg = oxo.purple },
                color_info = { fg = oxo.blue },
                color_hint = { fg = oxo.yellow },
              },
            },
            {
              function()
                return lsp_info()
              end,
              icon = "\xef\x84\x85 ",
              color = { fg = oxo.green },
            },
            {
              function()
                return linters_info()
              end,
              icon = "\xe2\x9a\x99\xef\xb8\x8f ",
              color = { fg = oxo.blue },
            },
          },
          lualine_z = {},
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { "filename" },
          lualine_x = { "location" },
          lualine_y = {},
          lualine_z = {},
        },
        extensions = {},
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
    enabled = DAP_ENABLED,
    lazy = true, -- Optional: Load only when needed
  },

  {
    "mfussenegger/nvim-dap",
    enabled = DAP_ENABLED,
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
    enabled = DAP_ENABLED,
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
    enabled = DAP_ENABLED,
    opts = {
      commented = true,
    },
  },
}
