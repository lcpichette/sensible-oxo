return {
  -- Conform for file formatting
  {
    "stevearc/conform.nvim",
    event = "BufReadPre",
    opts = {
      -- Enable format on save
      format_on_save = {
        enabled = true,
        timeout_ms = 2000, -- Time in milliseconds before format times out
        lsp_fallback = true, -- Fallback to LSP formatting if no formatter is found
      },
      -- Specify formatters by filetype
      formatters_by_ft = {
        lua = { "stylua" }, -- Use Stylua for Lua files

        -- JavaScript, TypeScript, etc.
        javascript = { "dprint", "prettierd", "prettier" },
        javascriptreact = { "dprint", "prettierd", "prettier" },
        typescript = { "dprint", "prettierd", "prettier" },
        typescriptreact = { "dprint", "prettierd", "prettier" },
        angular = { "dprint", "prettierd", "prettier" },
        nextjs = { "dprint", "prettierd", "prettier" },
      },
      -- Override default formatter configurations if necessary
      formatters = {
        stylua = {
          command = "stylua",
          stdin = true, -- Enable reading from stdin
        },
      },
    },
    config = function(_, opts)
      require("conform").setup(opts)
    end,
  },

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
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "ts_ls" }, -- Automatically install Lua and TypeScript LSPs
      })

      -- Automatically configure servers via mason-lspconfig and nvim-lspconfig
      local lspconfig = require("lspconfig")
      require("mason-lspconfig").setup_handlers({
        function(server_name) -- Default handler for all servers
          lspconfig[server_name].setup({})
        end,
        -- Custom handler for lua-language-server
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
        -- Custom handler for ts_ls (used to be tsserver) (TypeScript and JavaScript support)
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
        green = "#7dcfff", -- Green for LSP
        red = "#f7768e", -- Red for diagnostics
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
        local clients = vim.lsp.get_active_clients({ bufnr = 0 })
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
              symbols = { modified = " ●", readonly = " 🔒", unnamed = "[No Name]" },
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
                color_hint = { fg = oxo.green },
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
}
