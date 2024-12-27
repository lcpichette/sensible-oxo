require("config.lazy")
require("config.highlights")
require("config.mappings")
require("config.ui")
local bookmarks = require("custom_bookmark.bookmarks")
bookmarks.setup()
-- setup calls key_bind and autocmd

vim.g.editorconfig = false
vim.opt.clipboard = "unnamedplus"
