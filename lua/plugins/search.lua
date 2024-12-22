return {
  -- Telescope: Fuzzy Finder
  {
    "ibhagwan/fzf-lua",
    cmd = "FzfLua",
    dependencies = {
      "nvim-tree/nvim-web-devicons", -- optional for file icons
    },
    opts = {
      winopts = {
        height = 0.85, -- percentage of editor height
        width = 0.85, -- percentage of editor width
        row = 0.3, -- position from top (0=top, 1=bottom)
        col = 0.5, -- position from left (0=left, 1=right)
        border = "rounded", -- border style: 'none', 'single', 'double', 'rounded', etc.
        preview = {
          layout = "vertical", -- 'horizontal' or 'vertical'
          vertical = "up:45%", -- preview at the top with 45% height
        },
      },
      keymap = {
        fzf = {
          ["ctrl-q"] = "toggle-all", -- similar to sending all results to the quickfix
        },
        builtin = {
          ["<Tab>"] = "toggle+down", -- multi-select and move to next
          ["<S-Tab>"] = "toggle+up", -- multi-select and move to previous
          ["ctrl-s"] = "multi+quickfix", -- send selected to quickfix
        },
      },
      fzf_opts = {
        ["--layout"] = "reverse", -- matches ascending sorting strategy
      },
      previewers = {
        bat = {
          theme = "ansi", -- matches Telescope theme with `bat` previewer
        },
      },
    },
    config = function(_, opts)
      require("fzf-lua").setup(opts)
    end,
  },

  -- nvim-bqf: Better Quickfix window UI
  {
    "kevinhwang91/nvim-bqf",
    ft = "qf",
    config = function()
      require("bqf").setup({
        auto_enable = true,
        preview = {
          auto_preview = false,
          border_chars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
        },
        func_map = {
          open = "<CR>",
          pscrollup = "<C-b>",
          pscrolldown = "<C-f>",
        },
      })
    end,
  },

  -- which-key: Real-time key mapping assistance
  {
    "folke/which-key.nvim",
    event = "VeryLazy", -- load which-key once Neovim is mostly idle
    config = function()
      local which_key = require("which-key")
      which_key.setup({})
    end,
  },

  -- Arrow: Harpoon-alternative for adding freq-acc files
  {
    "otavioschwanck/arrow.nvim",
    dependencies = {
      { "nvim-tree/nvim-web-devicons" },
      -- or if using `mini.icons`
      -- { "echasnovski/mini.icons" },
    },
    opts = {
      show_icons = true,
    },
  },

  -- Adds searchable diagnostic reporting
  {
    "folke/trouble.nvim",
    keys = {
      {
        "<leader>xx",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Diagnostics (Trouble)",
      },
      {
        "<leader>xX",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "Buffer Diagnostics (Trouble)",
      },
      {
        "<leader>cs",
        "<cmd>Trouble symbols toggle focus=false<cr>",
        desc = "Symbols (Trouble)",
      },
      {
        "<leader>cl",
        "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
        desc = "LSP Definitions / references / ... (Trouble)",
      },
      {
        "<leader>xL",
        "<cmd>Trouble loclist toggle<cr>",
        desc = "Location List (Trouble)",
      },
      {
        "<leader>xQ",
        "<cmd>Trouble qflist toggle<cr>",
        desc = "Quickfix List (Trouble)",
      },
    },
    opts = {},
  },

  -- OIL: Better file searching and manipulation
  {
    "stevearc/oil.nvim",
    config = function()
      require("oil").setup({
        -- Customize your configuration here
        view_options = {
          show_hidden = true, -- Show hidden files
        },
      })

      -- Automatically open `oil.nvim` for directories
      vim.api.nvim_create_autocmd("VimEnter", {
        callback = function()
          local path = vim.fn.expand("%:p")
          if vim.fn.isdirectory(path) == 1 then
            require("oil").open()
          end
        end,
      })
    end,
  },
}
