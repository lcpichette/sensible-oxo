local DEVELOPING = true

return {
  -- Prod setup
  {
    "lcpichette/silver-search.nvim",
    enabled = not DEVELOPING,
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
    enabled = DEVELOPING,
  },
  {
    "CWood-sdf/banana.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      opts = {
        setupTs = true,
      },
    },
  },
}
