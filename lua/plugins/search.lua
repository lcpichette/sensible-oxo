local CONFIG = require("oxo_config")

return {
  {
    "bassamsdata/namu.nvim",
    enabled = CONFIG.namu,
    config = function()
      require("namu").setup({
        -- Enable the modules you want
        namu_symbols = {
          enable = true,
          options = {}, -- here you can configure namu
        },
        -- Optional: Enable other modules if needed
        ui_select = { enable = false }, -- vim.ui.select() wrapper
        colorscheme = {
          enable = true,
          options = {
            -- NOTE: if you activate persist, then please remove any vim.cmd("colorscheme ...") in your config, no needed anymore
            persist = true, -- very efficient mechanism to Remember selected colorscheme
            write_shada = false, -- If you open multiple nvim instances, then probably you need to enable this
          },
        },
      })
      -- === Suggested Keymaps: ===
      vim.keymap.set("n", "<leader>ss", ":Namu symbols<cr>", {
        desc = "Jump to LSP symbol",
        silent = true,
      })
      vim.keymap.set("n", "<leader>th", ":Namu colorscheme<cr>", {
        desc = "Colorscheme Picker",
        silent = true,
      })
    end,
  },

  -- Telescope: Fuzzy Finder
  {
    "ibhagwan/fzf-lua",
    cmd = { "Files", "Rg", "FzfLua" },
    enabled = CONFIG.fileSearch.fzf_lua,
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
    config = function(_, _)
      require("fzf-lua").setup({ "fzf-native" })
    end,
  },

  -- Snap (fzf-lua alternative)
  {
    "camspiers/snap",
    enabled = CONFIG.fileSearch.snap,
  },

  -- Telescope (fzf-lua alternative)
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope-fzy-native.nvim" },
    enabled = CONFIG.fileSearch.telescope,
  },

  -- Better quickfix (context lines, editable buffer, improved styling)
  {
    "stevearc/quicker.nvim",
    event = "VeryLazy", -- Load quicker.nvim when Neovim is idle
    enabled = CONFIG.quickfix.quicker,
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
    "LintaoAmons/bookmarks.nvim",
    enabled = CONFIG.bookmarks,
    dependencies = {
      { "kkharji/sqlite.lua" },
      { "nvim-telescope/telescope.nvim" },
      { "stevearc/dressing.nvim" }, -- Optional: for enhanced UI
    },
    config = function()
      local opts = {} -- go to the following link to see all the options in the deafult config file
      require("bookmarks").setup(opts) -- you must call setup to init sqlite db
    end,
  },

  -- Spelunk (bookmarks alternative)
  {
    "EvWilson/spelunk.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim", -- For window drawing utilities
      "nvim-telescope/telescope.nvim", -- Optional: for fuzzy search capabilities
      "nvim-treesitter/nvim-treesitter", -- Optional: for showing grammar context
    },
    enabled = CONFIG.spelunk,
    config = function()
      require("spelunk").setup({
        enable_persist = true,

        base_mappings = {
          -- Toggle the UI open/closed
          toggle = "<leader>bt",
          -- Add a bookmark to the current stack
          add = "<leader>ba",
          -- Move to the next bookmark in the stack
          next_bookmark = "<leader>bn",
          -- Move to the previous bookmark in the stack
          prev_bookmark = "<leader>bp",
          -- Fuzzy-find all bookmarks
          search_bookmarks = "<leader>bf",
          -- Fuzzy-find bookmarks in current stack
          search_current_bookmarks = "<leader>bc",
          -- Fuzzy find all stacks
          search_stacks = "<leader>bs",
        },

        window_mappings = {
          -- Move the UI cursor down
          cursor_down = "j",
          -- Move the UI cursor up
          cursor_up = "k",
          -- Move the current bookmark down in the stack
          bookmark_down = "<C-j>",
          -- Move the current bookmark up in the stack
          bookmark_up = "<C-k>",
          -- Jump to the selected bookmark
          goto_bookmark = "<CR>",
          -- Jump to the selected bookmark in a new vertical split
          goto_bookmark_hsplit = "x",
          -- Jump to the selected bookmark in a new horizontal split
          goto_bookmark_vsplit = "v",
          -- Delete the selected bookmark
          delete_bookmark = "d",
          -- Navigate to the next stack
          next_stack = "<Tab>",
          -- Navigate to the previous stack
          previous_stack = "<S-Tab>",
          -- Create a new stack
          new_stack = "n",
          -- Delete the current stack
          delete_stack = "D",
          -- Rename the current stack
          edit_stack = "E",
          -- Close the UI
          close = "q",
          -- Open the help menu
          help = "h",
        },

        -- Set UI orientation
        -- Type: 'vertical' | 'horizontal' | LayoutProvider
        -- Advanced customization: you may set your own layout provider for fine-grained control over layout
        -- See `types.lua` and `layout.lua` for guidance on setting this up
        orientation = "vertical",
        -- Enable to show mark index in status column
        enable_status_col_display = false,
        -- The character rendered before the currently selected bookmark in the UI
        cursor_character = ">",
      })
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
    enabled = CONFIG.arrow,
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
