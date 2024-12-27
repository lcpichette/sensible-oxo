-- TIPS
-- <C-i> in fzf-lua selects all files, then `Enter` to send them to quickfix list
-- `tab` in fzf-lua selects an individual file, then `Etner` to send selected files to quickfix list

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
-- = nvim-lspconfig mappings                  =
-- ============================================
-- int add(int x, int y); // Declaration
-- int add(int x, int y) {
--     return x + y; // Definition
-- }
-- int result = add(5, 3); // Reference
map("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", { desc = "Code Definition" })

-- Native neovim lsp + quickfix list if you prefer
-- map("n", "<leader>cd", "<cmd>lua vim.lsp.buf.definition()<CR>", { desc = "Code Definition" })
-- map("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", { desc = "Code Action" })
-- map("n", "<leader>cD", "<cmd>lua vim.lsp.buf.definition()<CR>", { desc = "Code Declaration" })
-- map("n", "<leader>cr", "<cmd>lua vim.lsp.buf.references()<CR>", { desc = "Code References" })

-- Using fzf-lua with lsp instead, you can send items from there to quickfix list if you'd like
map("n", "<leader>cd", "<cmd>lua require('fzf-lua').lsp_definitions()<CR>", { desc = "Code Definitions" })
map("n", "<leader>cD", "<cmd>lua require('fzf-lua').lsp_declarations()<CR>", { desc = "Code Declarations" })
map("n", "<leader>cr", "<cmd>lua require('fzf-lua').lsp_references()<CR>", { desc = "Code References" })
map("n", "<leader>ca", "<cmd>lua require('fzf-lua').lsp_code_actions()<CR>", { desc = "Code Actions" })

-- ============================================
-- = fzf-lua file/search-related mappings    =
-- ============================================
map("n", "<leader>ff", "<cmd>FzfLua files<CR>", { desc = "Find Files" })
map("n", "<leader>fw", "<cmd>FzfLua live_grep<CR>", { desc = "Find Word/Grep" })
map("n", "<leader>fB", "<cmd>FzfLua buffers<CR>", { desc = "Find Buffers" })
map("n", "<leader>fh", "<cmd>FzfLua help_tags<CR>", { desc = "Find Help" })
map("n", "<leader>fl", "<cmd>FzfLua resume<CR>", { desc = "Find last search" })
map("n", "<leader>fq", function()
  require("fzf-lua").fzf_exec("fre --sorted", { fzf_opts = { ["--no-sort"] = "" } })
end, { desc = "Find by Frecency" })

-- ============================================
-- = fzf-lua git-related mappings    =
-- ============================================
map("n", "<leader>gs", "<cmd>FzfLua git_status<CR>", { desc = "Git Status" })
map("n", "<leader>gS", "<cmd>FzfLua git_stash<CR>", { desc = "Git Stash" })
map("n", "<leader>gb", "<cmd>FzfLua git_branches<CR>", { desc = "Git Branches" })

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

-- Quicker-related
local quicker = require("quicker")

-- Define a toggle function for expand/collapse
local is_expanded = false
vim.keymap.set("n", "<leader>qt", function()
  if is_expanded then
    quicker.collapse()
  else
    quicker.expand()
  end
  is_expanded = not is_expanded
end, { desc = "Toggle quickfix expand/collapse" })

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
-- TODO: Fix this
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
-- Enable if you prefer ripgrep to grep
-- vim.keymap.set("n", "<leader>fw", custom_search.liveRipGrep, { desc = "Find Word" })

-- Custom notes
local custom_notes = require("custom_notes")
vim.keymap.set("n", "<leader>n", custom_notes.openNote, { desc = "Toggle Notes" })
