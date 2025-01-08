local CONFIG = require("oxo_config")

return {
  -- Add hardtime.nvim plugin
  {
    "m4xshen/hardtime.nvim",
    dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
    enabled = CONFIG.hardtime,
    opts = {
      disabled_filetypes = { "qf", "netrw", "NvimTree", "lazy", "mason", "oil" },
    },
  },

  -- Spider.nvim: Smarter w/b/e motions (camelCase-aware, etc.)
  {
    "chrisgrieser/nvim-spider",
    lazy = true,
    enabled = CONFIG.improvedMotions,
    keys = {
      {
        "w",
        function()
          require("spider").motion("w")
        end,
        mode = { "n", "o", "x" },
        desc = "Spider-w",
      },
      {
        "e",
        function()
          require("spider").motion("e")
        end,
        mode = { "n", "o", "x" },
        desc = "Spider-e",
      },
      {
        "b",
        function()
          require("spider").motion("b")
        end,
        mode = { "n", "o", "x" },
        desc = "Spider-b",
      },
      {
        "ge",
        function()
          require("spider").motion("ge")
        end,
        mode = { "n", "o", "x" },
        desc = "Spider-ge",
      },
    },
    opts = {
      skipInsignificantPunctuation = true, -- Skip insignificant punctuation
      consistentOperatorPending = false, -- Consistent behavior in operator-pending mode
      subwordMovement = true, -- Enable subword movements
      customPatterns = {}, -- Define custom movement patterns if needed
      jump_threshold = 30, -- Improve performance
    },
  },

  -- Hop.nvim: Jump to any text in the visible window with minimal keystrokes
  {
    "phaazon/hop.nvim",
    branch = "v2", -- ensure we’re on v2
    config = function()
      require("hop").setup({
        -- see :h hop-config for all options
        -- e.g., case_insensitive = true,
      })

      -- “f” motion for 2-character search across the *entire visible buffer*
      -- After pressing `f`, type e.g. `c` then `h` to jump to the first “ch”.
      vim.keymap.set({ "n", "x", "o" }, "f", function()
        require("hop").hint_char2({
          current_line_only = false, -- entire visible buffer
        })
      end, { desc = "Hop 2-char search" })
      -- “t” motion for 2-character search as well (if desired).
      -- Note: This won’t precisely replicate Vim’s native “t” offset behavior
      -- (jumping *before* the character), but does a 2-char Hop instead.
      vim.keymap.set({ "n", "x", "o" }, "t", function()
        require("hop").hint_char2({
          current_line_only = false,
        })
      end, { desc = "Hop 2-char search (like 't')" })
    end,
  },

  -- targets.vim: Additional text objects (e.g., in repeated quotes, blocks, etc.)
  {
    "wellle/targets.vim",
    event = "VeryLazy",
  },

  -- Add lsp diagnostics to buffer in helix-like style
  {
    "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
    config = function()
      require("lsp_lines").setup()
      -- Disable virtual_text since it's redundant with lsp_lines
      vim.diagnostic.config({
        virtual_text = false,
      })
    end,
  },
}
