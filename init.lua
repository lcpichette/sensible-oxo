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

vim.opt.signcolumn = "yes:1"
vim.g.editorconfig = false
vim.opt.clipboard = "unnamedplus"
