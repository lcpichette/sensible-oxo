local CONFIG = require("oxo_config")

return {
  {
    "lukas-reineke/indent-blankline.nvim",
    enabled = CONFIG.blankline,
    main = "ibl",
    opts = {
      indent = {
        char = "⎸",
        tab_char = "⎸",
      },
      scope = {
        enabled = true,
        show_start = true,
        show_end = true,
        highlight = "IblScope",
      },
      exclude = {
        filetypes = { "help", "dashboard", "NvimTree", "packer" },
        buftypes = { "terminal" },
      },
    },
  },

  {
    "HiPhish/rainbow-delimiters.nvim",
    enabled = false,
    config = function()
      local rainbow_delimiters = require("rainbow-delimiters")
      -- Optional: Customize the plugin's settings here
      vim.g.rainbow_delimiters = {
        strategy = {
          [""] = rainbow_delimiters.strategy["global"],
          vim = rainbow_delimiters.strategy["local"],
        },
        query = {
          [""] = "rainbow-delimiters",
          lua = "rainbow-blocks",
        },
        priority = {
          [""] = 110,
          lua = 210,
        },
        highlight = {
          "RainbowDelimiterRed",
          "RainbowDelimiterYellow",
          "RainbowDelimiterBlue",
          "RainbowDelimiterOrange",
          "RainbowDelimiterGreen",
          "RainbowDelimiterViolet",
          "RainbowDelimiterCyan",
        },
      }
    end,
  },

  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      keywords = {
        FIX = { icon = " ", color = "error", alt = { "BUG", "FIXME" } },
        TODO = { icon = " ", color = "info" },
        HACK = { icon = " ", color = "warning" },
        WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
        PERF = { icon = " ", color = "hint", alt = { "OPTIMIZE" } },
        NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
      },
    },
  },
}
