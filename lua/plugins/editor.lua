local CONFIG = require("oxo_config")

return {
  {
    "saghen/blink.cmp",
    -- optional: provides snippets for the snippet source
    dependencies = "rafamadriz/friendly-snippets",

    version = "*",
    event = { "InsertEnter", "CmdlineEnter" },
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
          and CONFIG.autocomplete.blink ~= false
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
    enabled = CONFIG.lsp,
    event = { "BufReadPre", "BufNewFile" },
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

  -- Better UI for `K`, `gD`, etc.
  {
    "dnlhc/glance.nvim",
    cmd = "Glance",
    enabled = CONFIG.fancyLSPPreviews,
  },

  {
    "mfussenegger/nvim-lint",
    enabled = CONFIG.lint,
    config = function()
      local lint = require("lint")

      lint.linters_by_ft = {
        lua = { "stylua" },
        javascript = { "prettierd" },
        javascriptreact = { "prettierd" },
        typescript = { "prettierd" },
        typescriptreact = { "prettierd" },
        angular = { "prettierd" },
        nextjs = { "prettierd" },
        zig = { "zigfmt" },
      }

      lint.linters.stylua = {
        name = "stylua",
        cmd = "stylua",
        args = {
          "--search-parent-directories",
        },
        stdin = false,
        parser = function()
          return {}
        end,
      }

      lint.linters.prettierd = {
        name = "prettierd",
        cmd = "prettierd",
        args = { "%:p" },
        stdin = true,
        parser = function(output)
          return {}
        end,
      }

      vim.api.nvim_create_autocmd("BufWritePost", {
        pattern = "*.lua",
        callback = function()
          local filepath = vim.fn.expand("<afile>")
          vim.fn.system({ "stylua", "--search-parent-directories", filepath })
        end,
      })

      vim.api.nvim_create_autocmd("BufWritePost", {
        pattern = { "*.js", "*.jsx", "*.ts", "*.tsx", "*.css", "*.json" },
        callback = function()
          local filepath = vim.fn.expand("<afile>")
          vim.fn.system({ "prettierd", filepath })
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
        "nml",
        "zls",
      },
      highlight = { enable = true },
    },
  },

  -- Comment code selections easier
  {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup()
    end,
  },

  -- Graphically-pleasing Search and Replace
  {
    "MagicDuck/grug-far.nvim",
    event = "VeryLazy",
    enabled = CONFIG.grugfar,
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
  -- mini.pairs approach (~1.7ms startup)
  {
    "echasnovski/mini.pairs",
    version = "*",
    enabled = CONFIG.autopairs.mini,
    config = function()
      require("mini.pairs").setup()
    end,
  },
  -- nvim-autopairs approach (~2.6ms startup)
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    enabled = CONFIG.autopairs.autopairs,
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

  -- Note taking using neorg (NORG)
  {
    "nvim-neorg/neorg",
    enabled = CONFIG.neorg,
    lazy = false, -- Disable lazy loading as some `lazy.nvim` distributions set `lazy = true` by default
    version = "*", -- Pin Neorg to the latest stable release
    config = true,
  },
}
