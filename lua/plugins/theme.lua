return {
  {
    "vague2k/vague.nvim",
    enabled = true,
    config = function()
      -- NOTE: you do not need to call setup if you don't want to.
      require("vague").setup({
        -- optional configuration here
        boolean = "none",
        number = "none",
        float = "none",
        error = "none",
        comments = "italic",
        conditionals = "none",
        functions = "none",
        headings = "bold",
        operators = "none",
        strings = "none",
        variables = "none",
      })
    end,
  },
  {
    "shaunsingh/oxocarbon.nvim",
    -- Load it on startup so it's applied immediately
    event = "BufReadPre",
    lazy = false,
    priority = 1000,
    enabled = false,
    config = function()
      -- Choose dark or light background
      vim.opt.background = "dark"
      vim.cmd.colorscheme("oxocarbon")
    end,
  },
  {
    "lunarvim/darkplus.nvim",
    event = "BufReadPre",
    lazy = false,
    priority = 1000,
    enabled = false,
    config = function()
      vim.opt.background = "dark"
      vim.cmd.colorscheme("darkplus")
    end,
  },
}
