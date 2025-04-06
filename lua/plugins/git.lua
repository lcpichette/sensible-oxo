local CONFIG = require("oxo_config")

return {
  -- Git signs left of line numbers
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" }, -- Load on file open
    enabled = CONFIG.git.gitsigns,
    config = function()
      -- ▉ ▊ ▋ ▌ ▍ ▎▏
      local char = "▎"
      require("gitsigns").setup({
        signs = {
          add = { text = char },
          change = { text = char },
          delete = { text = "▁" },
        },
      })

      vim.api.nvim_set_hl(0, "GitSignsAdd", { fg = "#3DDC97" }) -- Green
      vim.api.nvim_set_hl(0, "GitSignsChange", { fg = "#bb9af7" }) -- Purple
      vim.api.nvim_set_hl(0, "GitSignsDelete", { fg = "#f7768e" }) -- Red
    end,
  },

  -- `:Neogit`, see keymaps as well
  {
    "NeogitOrg/neogit",
    enabled = CONFIG.git.neogit,
    dependencies = {
      "nvim-lua/plenary.nvim", -- required
      "sindrets/diffview.nvim", -- optional
      "ibhagwan/fzf-lua", -- optional
    },
  },
}
