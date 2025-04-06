local CONFIG = require("oxo_config")

return {
  {
    "OXY2DEV/markview.nvim",
    enabled = CONFIG.markview,
    config = function()
      require("markview")

      vim.api.nvim_set_hl(0, "MarkviewHeading", { fg = "#3ddbd9", bold = true })
      vim.api.nvim_set_hl(0, "MarkviewCodeBlock", { fg = "#78a9ff", bg = "#262626" })
      vim.api.nvim_set_hl(0, "MarkviewLink", { fg = "#ee5396", underline = true })
      vim.api.nvim_set_hl(0, "MarkviewBold", { fg = "#f2f4f8", bold = true })
      vim.api.nvim_set_hl(0, "MarkviewItalic", { fg = "#f2f4f8", italic = true })

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "markdown",
        callback = function()
          vim.cmd("MarkviewToggle") -- Automatically toggle markview in markdown
        end,
      })
    end,
    cmd = { "MarkviewOpen", "MarkviewToggle" },
  },

  {
    "nvzone/typr",
    dependencies = "nvzone/volt",
    opts = {},
    cmd = { "Typr", "TyprStats" },
  },
}
