-- Import keybinds I don't want remapped
local keymap = vim.api.nvim_set_keymap
keymap("n", "<C-k>", "<Cmd>wincmd k<CR>", { noremap = true, silent = true })
keymap("n", "<C-j>", "<Cmd>wincmd j<CR>", { noremap = true, silent = true })
keymap("n", "<C-h>", "<Cmd>wincmd h<CR>", { noremap = true, silent = true })
keymap("n", "<C-l>", "<Cmd>wincmd l<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "q", ":nohlsearch<CR>", { noremap = true, silent = true })

-- Opinionated settings
vim.opt.mouse = ""
vim.g.mapleader = " "

-- Plugin-related keybinds
local map = vim.keymap.set

-- ============================================
-- = fzf-lua file/search-related mappings    =
-- ============================================
map("n", "<leader>ff", "<cmd>FzfLua files<CR>", { desc = "Find Files" })
map("n", "<leader>fw", "<cmd>FzfLua live_grep<CR>", { desc = "Find Word/Grep" })
map("n", "<leader>fb", "<cmd>FzfLua buffers<CR>", { desc = "Find Buffers" })
map("n", "<leader>fh", "<cmd>FzfLua help_tags<CR>", { desc = "Find Help" })

-- ============================================
-- = Quickfix list-related mappings           =
-- ============================================
-- Open the Quickfix list
map("n", "<leader>qo", ":copen<CR>", { desc = "Open Quickfix List" })
-- Close the Quickfix list
map("n", "<leader>qc", ":cclose<CR>", { desc = "Close Quickfix List" })

-- Optionally map a key to jump to the next Quickfix item
map("n", "<leader>qn", ":cnext<CR>", { desc = "Next Quickfix" })
map("n", "<leader>qp", ":cprev<CR>", { desc = "Prev Quickfix" })

-- ============================================
-- = Commenting-related mappings              =
-- ============================================
local comment_api = require("Comment.api")

map("n", "<leader>/", function()
  comment_api.toggle.linewise.current()
end, { desc = "Toggle Commment" })

-- ============================================
-- = FZF-Lua custom mappings                  =
-- ============================================
-- Todo-Comment specific integration w/ fzf-lua
map("n", "<leader>tf", function()
  require("fzf-lua").grep({ search = "TODO|FIX|HACK|WARN|NOTE" })
end, { desc = "Search TODOs with fzf-lua" })

map("n", "<leader>tc", function()
  require("fzf-lua").live_grep({ rg_opts = "--type lua -e TODO|FIX|HACK" })
end, { desc = "Live grep TODOs in Lua files" })

-- ============================================
-- = Grug-Far Mappings                        =
-- ============================================
map("n", "<leader>fr", function()
  require("grug-far").open({ windowCreationCommand = "vsplit" })
end, { desc = "Find and Replace" })

-- ============================================
-- = ShowKeys Mappings                        =
-- ============================================
map("n", "<leader>uk", "<cmd>ShowkeysToggle<CR>", { desc = "Show Keys while typing" })

-- ============================================
-- = Custom Modules Mappings                  =
-- ============================================
-- Custom search
local custom_search = require("custom_search")
vim.keymap.set("n", "/", custom_search.searchFile, { desc = "Custom FZF lgrep logic" })

-- Custom notes
local custom_notes = require("custom_notes")
vim.keymap.set("n", "<leader>n", custom_notes.openNote, { desc = "Open Notes" })
