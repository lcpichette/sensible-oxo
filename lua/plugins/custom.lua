local ALL_DISABLED = true
local DEVELOPING = true

return {
  -- Prod setup
  {
    "lcpichette/silver-search.nvim",
    enabled = not (ALL_DISABLED or DEVELOPING),
    dependencies = {
      "CWood-sdf/banana.nvim",
      opts = {
        setupTs = true,
      },
    },
  },

  -- Dev setup
  {
    dir = "~/.config/nvim/lua/custom_plugins/silver_search",
    enabled = not ALL_DISABLED and DEVELOPING,
  },
  {
    "CWood-sdf/banana.nvim",
    enabled = not ALL_DISABLED and DEVELOPING,
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      opts = {
        setupTs = true,
      },
    },
  },
}
