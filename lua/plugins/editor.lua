return {
  {
    "saghen/blink.cmp",
    -- optional: provides snippets for the snippet source
    dependencies = "rafamadriz/friendly-snippets",

    version = "*",
    -- If you use nix, you can build from source using latest nightly rust with:
    -- build = 'nix run .#build-plugin',

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      -- 'default' for mappings similar to built-in completion
      -- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
      -- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
      -- See the full "keymap" documentation for information on defining your own keymap.
      keymap = { preset = "enter" },

      enabled = function()
        return not vim.tbl_contains({ "markdown" }, vim.bo.filetype)
          and vim.bo.buftype ~= "prompt"
          and vim.b.completion ~= false
      end,

      completion = {
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 500,
        },

        ghost_text = { enabled = true },

        menu = {
          auto_show = function(ctx)
            return ctx.mode ~= "cmdline"
          end,
          -- Customize the appearance of the completion menu
          winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,CursorLine:PmenuSel,Search:None",
          -- Additional appearance settings
          min_width = 15,
          max_height = 10,
          border = "none",
          winblend = 0,
          scrollbar = true,
          direction_priority = { "s", "n" },
        },
      },

      appearance = {
        -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        nerd_font_variant = "mono",
      },

      -- Default list of enabled providers defined so that you can extend it
      -- elsewhere in your config, without redefining it, due to `opts_extend`
      sources = {
        default = { "lazydev", "lsp", "path", "snippets", "buffer" },
        providers = {
          lazydev = {
            name = "LazyDev",
            module = "lazydev.integrations.blink",
            -- make lazydev completions top priority (see `:h blink.cmp`)
            score_offset = 100,
          },
        },
      },
    },

    opts_extend = { "sources.default" },

    signature = { enabled = true },
  },

  {
    "neovim/nvim-lspconfig",
    config = function()
      local lspconfig = require("lspconfig")

      -- Configure custom diagnostic signs
      local signs = {
        Error = "", -- Customize for Error
        Warn = "", -- Customize for Warning
        Hint = "󰌶", -- Customize for Hint
        Info = "󰙎", -- Customize for Information
      }

      -- Define diagnostic signs globally
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })

        local colors = {
          Error = "#d94e89", -- Red
          Warn = "#f49800", -- Yellow
          Hint = "#ffe700", -- Green
          Info = "#7aa2f7", -- Blue
        }
        vim.api.nvim_set_hl(0, hl, { fg = colors[type] })
      end

      -- Configure diagnostics globally
      vim.diagnostic.config({
        virtual_text = false, -- Disable virtual text
        signs = true, -- Enable diagnostic signs
        underline = true, -- Enable underlining
        update_in_insert = false, -- Don't show diagnostics in insert mode
      })

      -- Configure LSP servers
      local servers = {
        ts_ls = {}, -- JavaScript/TypeScript
        angularls = {}, -- Angular
        cssls = {}, -- CSS/SCSS
        lua_ls = { -- Lua
          settings = {
            Lua = {
              runtime = {
                version = "LuaJIT",
              },
              diagnostics = {
                globals = { "vim" },
              },
              workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false,
              },
              telemetry = {
                enable = false,
              },
            },
          },
        },
        eslint = {}, -- ESLint
      }

      for server, config in pairs(servers) do
        config.capabilities = require("blink.cmp").get_lsp_capabilities(config.capabilities)
        lspconfig[server].setup(config)
      end
    end,
  },

  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local lint = require("lint")

      -- Define linters by filetype
      lint.linters_by_ft = {
        -- Lua Linters
        lua = { "selene", "luacheck" },

        -- JavaScript and TypeScript Linters
        javascript = { "eslint" },
        typescript = { "eslint" },

        -- React Specific Linters
        javascriptreact = { "eslint" },
        typescriptreact = { "eslint" },

        -- Angular Specific Linters
        angular = { "eslint" },

        -- Next.js Specific Linters (if applicable)
        nextjs = { "eslint" },
      }

      -- Create an autocommand to lint on save
      vim.api.nvim_create_autocmd("BufWritePost", {
        pattern = "*",
        callback = function()
          lint.try_lint()
        end,
      })
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    event = "BufReadPre",
    opts = {
      ensure_installed = {
        "javascript",
        "typescript",
        "tsx",
        "css",
        "scss",
        "html",
        "lua",
      },
      highlight = { enable = true },
    },
  },

  -- Comment code selections easier
  {
    "numToStr/Comment.nvim",
    opts = {},
  },

  -- Graphically-pleasing Search and Replace
  {
    "MagicDuck/grug-far.nvim",
    event = "VeryLazy",
    enabled = true,
    config = function()
      require("grug-far").setup({
        -- options, see Configuration section below
        -- there are no required options atm
        -- engine = 'ripgrep' is default, but 'astgrep' can be specified
      })
    end,
  },

  -- Tabbing just working
  {
    "tpope/vim-sleuth",
    lazy = false, -- Load immediately since it needs to monitor buffer changes
    config = function()
      -- For example, disable conceal feature if you prefer
      vim.g.sleuth_conceal = false
    end,
  },

  -- Automatically create pairs (e.g. insert `]` when you press `[`)
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup({
        check_ts = true,
        map_complete = true,
        fast_wrap = {
          map = "<M-e>", -- Keybinding to trigger fast wrap
          chars = { "{", "[", "(", '"', "'" },
          pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], "%s+", ""),
          offset = 0, -- Offset from cursor position
          end_key = "$",
          keys = "qwertyuiopzxcvbnmasdfghjkl",
          check_comma = true,
          highlight = "PmenuSel",
          highlight_grey = "LineNr",
        },
      })
    end,
    dependencies = {
      "hrsh7th/nvim-cmp",
    },
  },
}
