require("config.lazy")
require("config.highlights")
require("config.mappings")
require("config.ui")
require("filetypes")
require("custom_notes").setup()

vim.opt.signcolumn = "yes:1"
vim.g.editorconfig = false
vim.opt.clipboard = "unnamedplus"
