return {
  -- Telescope: Fuzzy Finder
  {
    "ibhagwan/fzf-lua",
    cmd = { "Files", "Rg" },
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

  -- Better quickfix (context lines, editable buffer, improved styling)
  {
    "stevearc/quicker.nvim",
    event = "VeryLazy", -- Load quicker.nvim when Neovim is idle
    opts = {
      edit = {
        -- Enable editing the quickfix like a normal buffer
        enabled = true,
        -- Set to true to write buffers after applying edits.
        -- Set to "unmodified" to only write unmodified buffers.
        autosave = "unmodified",
      },
      highlight = {
        -- Use treesitter highlighting
        treesitter = true,
        -- Use LSP semantic token highlighting
        lsp = true,
        -- Load the referenced buffers to apply more accurate highlights (may be slow)
        load_buffers = true,
      },
      keys = {},
      borders = {
        vert = "┃",
        -- Strong headers separate results from different files
        strong_header = "━",
        strong_cross = "╋",
        strong_end = "┫",
        -- Soft headers separate results within the same file
        soft_header = "╌",
        soft_cross = "╂",
        soft_end = "┨",
      },
    },
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

  -- Bookmarks
  {
    "crusj/bookmarks.nvim",
    keys = {
      { "<tab><tab>", mode = { "n" } },
    },
    branch = "main",
    dependencies = { "nvim-web-devicons" },
    config = function()
      require("bookmarks").setup()
      require("fzf-lua").setup({
        bookmarks = {
          -- Customize fzf-lua's behavior for bookmarks if necessary
        },
      })

      -- Add a custom command to trigger bookmarks with fzf-lua
      vim.api.nvim_set_keymap(
        "n",
        "<tab><tab>",
        ":lua require('fzf-lua').bookmarks()<CR>",
        { noremap = true, silent = true }
      )
    end,
  },

  -- Arrow: Harpoon-alternative for adding freq-acc files
  {
    "otavioschwanck/arrow.nvim",
    event = "VeryLazy",
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
