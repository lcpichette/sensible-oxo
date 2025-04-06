local CONFIG = require("oxo_config")

require("config.lazy")
require("config.highlights")
require("config.mappings")
require("config.ui")
require("filetypes")
require("custom_notes").setup()
if CONFIG.fileSearch.telescope then
  require("config.telescope")
end

-- Stores pwd upon exit
if vim.env.NVIM_LASTDIR_FILE then
  vim.api.nvim_create_autocmd("VimLeavePre", {
    callback = function()
      local cwd = vim.fn.getcwd()
      vim.fn.writefile({ cwd }, vim.env.NVIM_LASTDIR_FILE)
    end,
  })
end

vim.opt.signcolumn = "yes:1"
vim.g.editorconfig = false
vim.opt.clipboard = "unnamedplus"
