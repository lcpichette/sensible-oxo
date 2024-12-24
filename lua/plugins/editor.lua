return {
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-nvim-lsp",
    },
    opts = function(_, opts)
      local cmp = require("cmp")
      local kind_icons = {
        Text = "",
        Method = "ƒ",
        Function = "ƒ",
        Constructor = "",
        Field = "☐",
        Variable = "",
        Class = "",
        Interface = "",
        Module = "",
        Property = "",
        Unit = "",
        Value = "",
        Enum = "",
        Keyword = "…",
        Snippet = "",
        Color = "",
        File = "",
        Reference = "",
        Folder = "",
        EnumMember = "",
        Constant = "",
        Struct = "פּ",
        Event = "",
        Operator = "",
        TypeParameter = "",
      }

      opts.formatting = {
        fields = { "kind", "abbr", "menu" },
        format = function(entry, vim_item)
          local kind_icons = {
            Text = "",
            Method = "ƒ",
            Function = "",
            Constructor = "",
            Field = "識",
            Variable = "",
            Class = "",
            Interface = "",
            Module = "",
            Property = "",
            Unit = "",
            Value = "",
            Enum = "",
            Keyword = "",
            Snippet = "",
            Color = "",
            File = "",
            Reference = "",
            Folder = "",
            EnumMember = "",
            Constant = "",
            Struct = "פּ",
            Event = "",
            Operator = "",
            TypeParameter = "",
          }

          -- Add the icon with its kind
          vim_item.kind = string.format("%s %s", kind_icons[vim_item.kind] or "", vim_item.kind)

          -- Ensure no background color for the menu
          vim_item.menu = ({
            buffer = "[Buffer]",
            path = "[Path]",
            nvim_lsp = "[LSP]",
          })[entry.source.name]

          return vim_item
        end,
      }

      opts.mapping = cmp.mapping.preset.insert({
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
      })

      opts.sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "buffer" },
        { name = "path" },
      })

      return opts
    end,
  },

  {
    "neovim/nvim-lspconfig",
    config = function()
      local lspconfig = require("lspconfig")

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
        lspconfig[server].setup(config)
      end
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
    enabled = false,
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
