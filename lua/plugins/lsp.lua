local config = require("oxo_config")

return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = "BufReadPost",
    opts = {
      ensure_installed = {
        "javascript",
        "typescript",
        "tsx",
        "rust",
      },
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      indent = {
        enable = true,
      },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },

  -- dressing.nvim: improve neovim's ui for input and selection
  {
    "stevearc/dressing.nvim",
    event = "VeryLazy", -- load the plugin when neovim is idle
    enabled = config.dressing,
    opts = {
      -- customize the ui components
      input = {
        -- default options for input ui
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
        anchor = "nw",
        pos = "100%",
        row = 1,
        col = 1,
      },
      select = {
        -- default options for select ui
        enabled = true,
        backend = { "telescope", "builtin" },
        builtin = {
          -- customize the selection ui
          border = "rounded",
          -- position the selection window at the top
          anchor = "nw",
          -- optional: adjust the position offset
          post = "100%",
        },
      },
    },
    config = function(_, opts)
      require("dressing").setup(opts)
    end,
  },

  -- mason setup for lsp installation and configuration
  {
    "williamboman/mason.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
      "williamboman/mason-lspconfig.nvim",
    },
    cmd = { "Mason", "MasonInstall", "MasonUpdate" },
    config = function()
      require("mason").setup()

      -- ensure formatters are installed
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

      -- ensure lsps are installed
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

      -- reusable capabilities for lsps
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities.textdocument.completion.completionitem.snippetsupport = true

      local lspconfig = require("lspconfig")

      -- lsp-specific setup handlers
      require("mason-lspconfig").setup_handlers({
        -- tailwindcss configuration
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

        -- html configuration
        ["html"] = function()
          lspconfig.html.setup({
            capabilities = capabilities,
            filetypes = { "html", "nml", "templ" },
            root_dir = lspconfig.util.root_pattern(".git", "package.json"),
          })
        end,

        -- somesass configuration
        ["somesass_ls"] = function()
          lspconfig.somesass_ls.setup({
            capabilities = capabilities,
            filetypes = { "scss", "less" },
            root_dir = lspconfig.util.root_pattern(".git", "package.json"),
          })
        end,

        -- cssls configuration
        ["cssls"] = function()
          lspconfig.cssls.setup({
            capabilities = capabilities,
            filetypes = { "css" },
            root_dir = lspconfig.util.root_pattern(".git", "package.json"),
          })
        end,

        -- lua-language-server configuration
        ["lua_ls"] = function()
          lspconfig.lua_ls.setup({
            settings = {
              lua = {
                runtime = { version = "luajit" },
                diagnostics = { globals = { "vim" } },
                workspace = { library = vim.api.nvim_get_runtime_file("", true) },
                telemetry = { enable = false },
              },
            },
          })
        end,

        -- typescript server configuration
        ["ts_ls"] = function()
          lspconfig.ts_ls.setup({
            capabilities = capabilities,
            filetypes = {
              "javascript",
              "javascriptreact",
              "javascript.jsx",
              "typescript",
              "typescriptreact",
              "typescript.tsx",
            },
            on_attach = function(client, bufnr)
              -- enable inlay hints (neovim 0.10+)
              if vim.lsp.inlay_hint then
                vim.lsp.inlay_hint(bufnr, true)
              end

              -- disable formatting if using prettier/dprint externally
              client.server_capabilities.documentformattingprovider = false
            end,
            settings = {
              typescript = {
                suggest = {
                  completefunctioncalls = true,
                },
                updateimportsonfilemove = {
                  enabled = "always",
                },
                inlayhints = {
                  includeinlayparameternamehints = "all",
                  includeinlayparameternamehintswhenargumentmatchesname = true,
                  includeinlayfunctionlikereturntypehints = true,
                  includeinlayvariabletypehints = true,
                  includeinlaypropertydeclarationtypehints = true,
                  includeinlayfunctionparametertypehints = true,
                  includeinlayenummembervaluehints = true,
                },
                tsserver = {
                  usesyntaxserver = "false",
                },
              },
              javascript = {
                suggest = {
                  completefunctioncalls = true,
                },
                inlayhints = {
                  includeinlayparameternamehints = "all",
                  includeinlayparameternamehintswhenargumentmatchesname = true,
                  includeinlayfunctionlikereturntypehints = true,
                  includeinlayvariabletypehints = true,
                  includeinlaypropertydeclarationtypehints = true,
                  includeinlayfunctionparametertypehints = true,
                  includeinlayenummembervaluehints = true,
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
                  autoimports = true,
                },
              },
              typescript = {
                suggest = {
                  autoimports = true,
                },
              },
            },
          })
        end,

        -- zig language server configuration
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

  -- conform, for file formatting
  {
    "stevearc/conform.nvim",
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          javascript = { "eslint_d", "prettierd" },
          typescript = { "eslint_d", "prettierd" },
          vue = { "eslint_d", "prettierd" },
          svelte = { "eslint_d", "prettierd" },
        },
      })

      -- format on save
      vim.api.nvim_create_autocmd("bufwritepre", {
        callback = function(args)
          require("conform").format({ bufnr = args.buf })
        end,
      })
    end,
  },

  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        -- see the configuration section for more details
        -- load luvit types when the `vim.uv` word is found
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },

  -- dap
  {
    "nvim-neotest/nvim-nio",
    enabled = config.dap,
    lazy = true, -- optional: load only when needed
  },

  {
    "mfussenegger/nvim-dap",
    enabled = config.dap,
    dependencies = { "nvim-neotest/nvim-nio" },
    config = function()
      local dap = require("dap")

      vim.fn.sign_define("dapbreakpoint", { text = "●", texthl = "dapbreakpoint", linehl = "", numhl = "" }) -- small red circle
      vim.fn.sign_define(
        "dapbreakpointcondition",
        { text = "", texthl = "dapbreakpointcondition", linehl = "", numhl = "" }
      ) -- branch icon
      vim.fn.sign_define(
        "dapbreakpointrejected",
        { text = "", texthl = "dapbreakpointrejected", linehl = "", numhl = "" }
      ) -- small x
      vim.fn.sign_define("daplogpoint", { text = "", texthl = "daplogpoint", linehl = "", numhl = "" }) -- log icon

      vim.api.nvim_set_hl(0, "dapbreakpoint", { fg = "#ee5396" }) -- breakpoint: subtle red
      vim.api.nvim_set_hl(0, "dapbreakpointcondition", { fg = "#ff832b" }) -- conditional: soft orange
      vim.api.nvim_set_hl(0, "dapbreakpointrejected", { fg = "#fa4d56" }) -- rejected: muted red
      vim.api.nvim_set_hl(0, "daplogpoint", { fg = "#42be65" }) -- log point: calm green

      -- lua adapter configuration
      dap.adapters.nlua = function(callback, config)
        callback({
          type = "server",
          host = config.host or "127.0.0.1",
          port = config.port or 8086,
        })
      end

      -- lua configuration for debugging
      dap.configurations.lua = {
        {
          type = "nlua",
          request = "attach",
          name = "attach to neovim",
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
        desc = "start/continue debugging",
      },
      {
        "<leader>bv",
        function()
          require("dap").step_over()
        end,
        desc = "step over",
      },
      {
        "<leader>bi",
        function()
          require("dap").step_into()
        end,
        desc = "step into",
      },
      {
        "<leader>bo",
        function()
          require("dap").step_out()
        end,
        desc = "step out",
      },
      {
        "<leader>bb",
        function()
          require("dap").toggle_breakpoint()
        end,
        desc = "toggle breakpoint",
      },
      {
        "<leader>bc",
        function()
          require("dap").set_breakpoint(vim.fn.input("breakpoint condition: "))
        end,
        desc = "set conditional breakpoint",
      },
      {
        "<leader>br",
        function()
          require("dap").repl.open()
        end,
        desc = "open debug repl",
      },
      {
        "<leader>bl",
        function()
          require("dap").run_last()
        end,
        desc = "run last debugging session",
      },
    },
  },

  -- ui for dap
  {
    "rcarriga/nvim-dap-ui",
    enabled = config.dap,
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
      vim.keymap.set("n", "<leader>bu", dapui.toggle, { desc = "toggle dap ui" })
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

  -- virtual text for dap
  {
    "thehamsta/nvim-dap-virtual-text",
    enabled = config.dap,
    opts = {
      commented = true,
    },
  },
}
