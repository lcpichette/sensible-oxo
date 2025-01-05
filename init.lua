require("config.lazy")
require("config.highlights")
require("config.mappings")
require("config.ui")
require("filetypes")
require("custom_plugins.silver_search.lua.init").setup()

-- local bookmarks = require("custom_bookmark.bookmarks")
-- bookmarks.setup()
-- setup calls key_bind and autocmd

vim.opt.signcolumn = "yes:1"
vim.g.editorconfig = false
vim.opt.clipboard = "unnamedplus"
