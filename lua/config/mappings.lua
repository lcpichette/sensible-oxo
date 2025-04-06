local CONFIG = require("oxo_config")
-- TIPS
-- <C-i> in fzf-lua selects all files, then `Enter` to send them to quickfix list
-- `tab` in fzf-lua selects an individual file, then `Etner` to send selected files to quickfix list

-- Import keybinds I don't want remapped
local keymap = vim.api.nvim_set_keymap
keymap("n", "<C-k>", "<Cmd>wincmd k<CR>", { noremap = true, silent = true })
keymap("n", "<C-j>", "<Cmd>wincmd j<CR>", { noremap = true, silent = true })
keymap("n", "<C-h>", "<Cmd>wincmd h<CR>", { noremap = true, silent = true })
keymap("n", "<C-l>", "<Cmd>wincmd l<CR>", { noremap = true, silent = true })

-- Opinionated settings
vim.opt.mouse = ""
vim.g.mapleader = " "

-- Plugin-related keybinds
local map = vim.keymap.set

-- Custom search registry related mappings
vim.api.nvim_set_keymap("n", "q", "", {
  noremap = true,
  silent = true,
  callback = function()
    vim.cmd("nohlsearch")
    vim.fn.setreg("/", "")
    vim.cmd("let @/ = ''")
    vim.cmd("silent! call histdel('search', -1)")
    vim.fn.setreg("/", "\\%#") -- Set a no-op pattern that matches nothing
    vim.cmd("let @/ = '\\%#'") -- Update Vim's internal search state
  end,
})

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

if CONFIG.fileSearch.fzf_lua then
  -- Using fzf-lua with lsp instead, you can send items from there to quickfix list if you'd like
  map("n", "<leader>cd", "<cmd>lua require('fzf-lua').lsp_definitions()<CR>", { desc = "Code Definitions" })
  map("n", "<leader>cD", "<cmd>lua require('fzf-lua').lsp_declarations()<CR>", { desc = "Code Declarations" })
  map("n", "<leader>cr", "<cmd>lua require('fzf-lua').lsp_references()<CR>", { desc = "Code References" })
  map("n", "<leader>ca", "<cmd>lua require('fzf-lua').lsp_code_actions()<CR>", { desc = "Code Actions" })
end

-- ============================================
-- = fzf-lua file/search-related mappings    =
-- ============================================
if CONFIG.fileSearch.fzf_lua then
  map("n", "<leader>ff", "<cmd>FzfLua files<CR>", { desc = "Find Files" })
  map("n", "<leader>fw", "<cmd>FzfLua live_grep<CR>", { desc = "Find Word/Grep" })
  map("n", "<leader>fB", "<cmd>FzfLua buffers<CR>", { desc = "Find Buffers" })
  map("n", "<leader>fh", "<cmd>FzfLua help_tags<CR>", { desc = "Find Help" })
  map("n", "<leader>fo", "<cmd>FzfLua resume<CR>", { desc = "Find last search (old files)" })
  map("n", "<leader>fg", "<cmd>FzfLua git_status<CR>", { desc = "Find Changed Files" })
end

-- ============================================
-- = fzf-lua git-related mappings    =
-- ============================================
if CONFIG.fileSearch.fzf_lua then
  map("n", "<leader>gs", "<cmd>FzfLua git_status<CR>", { desc = "Git Status" })
  map("n", "<leader>gS", "<cmd>FzfLua git_stash<CR>", { desc = "Git Stash" })
  map("n", "<leader>gb", "<cmd>FzfLua git_branches<CR>", { desc = "Git Branches" })
end

-- ============================================
-- = Snap mappings    =
-- ============================================
if CONFIG.fileSearch.snap then
  local snap = require("snap")
  snap.maps({
    { "<Leader>ff", snap.config.file({ producer = "ripgrep.file" }), { desc = "Find by Filename" } },
    { "<Leader>fw", snap.config.vimgrep({}), { desc = "Find by Word" } },
    { "<Leader>fo", snap.config.file({ producer = "vim.oldfile" }), { desc = "Find Recent Files" } },
    { "<Leader>fb", snap.config.file({ producer = "vim.buffer" }), { desc = "Find Buffers" } },
  })
end

-- Telescope
if CONFIG.fileSearch.telescope then
  map("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { desc = "Find files" })
  map("n", "<leader>fw", "<cmd>Telescope live_grep<CR>", { desc = "Find by grep" })
  map("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", { desc = "Find help tags" })
  map("n", "<leader>fo", "<cmd>Telescope oldfiles<CR>", { desc = "Find old files" })
  map("n", "<leader>fc", "<cmd>Telescope commands<CR>", { desc = "Find commands" })
  map("n", "<leader>fq", "<cmd>Telescope quickfix<CR>", { desc = "Find quickfix items" })
  map("n", "<leader>fr", "<cmd>Telescope resume<CR>", { desc = "Find by last search" })
  map("n", "<leader>fm", "<cmd>Telescope man_pages<CR>", { desc = "Find Manual Pages" })

  -- Git-related pickers
  map("n", "<leader>gc", "<cmd>Telescope git_commits<CR>", { desc = "Git commits" })
  map("n", "<leader>gb", "<cmd>Telescope git_branches<CR>", { desc = "Git branches" })
  map("n", "<leader>gs", "<cmd>Telescope git_status<CR>", { desc = "Git status" })
  map("n", "<leader>gf", "<cmd>Telescope git_files<CR>", { desc = "Git files" })

  -- LSP-related pickers with <leader>b{key}
  map("n", "<leader>cd", "<cmd>Telescope lsp_definitions<CR>", { desc = "LSP definitions" })
  map("n", "<leader>ci", "<cmd>Telescope lsp_implementations<CR>", { desc = "LSP implementations" })
  map("n", "<leader>cr", "<cmd>Telescope lsp_references<CR>", { desc = "LSP references" })

  -- Search and session pickers
  map("n", "<leader>fz", "<cmd>Telescope current_buffer_fuzzy_find<CR>", { desc = "Fuzzy find in buffer" })
  map("n", "<leader>fd", "<cmd>Telescope diagnostics<CR>", { desc = "Find diagnostics" })
end

-- ============================================
-- = Neogit-related mappings    =
-- ============================================
if CONFIG.git.neogit then
  map("n", "<leader>go", "<cmd>Neogit<cr>", { desc = "Open NeoGit" })
  map("n", "<leader>gf", "<cmd>Neogit fetch<cr>", { desc = "Fetch" })
  map("n", "<leader>gB", "<cmd>Neogit branch<cr>", { desc = "Branch" })
  map("n", "<leader>gg", "<cmd>Neogit commit<cr>", { desc = "Commit" })
  map("n", "<leader>gp", "<cmd>Neogit push<cr>", { desc = "Push" })
end

-- ============================================
-- = Glance (LSP-peak) mappings    =
-- ============================================
if CONFIG.glance then
  map("n", "gd", "<CMD>Glance definitions<CR>", { desc = "Find Definitions" })
  map("n", "gr", "<CMD>Glance references<CR>", { desc = "Find References" })
  map("n", "gy", "<CMD>Glance type_definitions<CR>", { desc = "Find Type Definitions" })
  map("n", "gm", "<CMD>Glance implementations<CR>", { desc = "Find Implementations" })
end

-- ============================================
-- = Bookmarks mappings    =
-- ============================================
if CONFIG.bookmarks then
  map({ "n", "v" }, "mm", "<cmd>BookmarksMark<cr>", { desc = "Mark current line into active BookmarkList." })
  map({ "n", "v" }, "mo", "<cmd>BookmarksGoto<cr>", { desc = "Go to bookmark in current active BookmarkList" })
  map({ "n", "v" }, "md", "<cmd>BookmarksDesc<cr>", { desc = "Add description to the bookmark under cursor" })
  map({ "n", "v" }, "mt", "<cmd>BookmarksTree<cr>", { desc = "Show bookmarks tree" })
end

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

if CONFIG.quickfix.quicker then
  local quicker = require("quicker")
  -- Define a toggle function for expand/collapse
  local is_expanded = false
  map("n", "<leader>qt", function()
    if is_expanded then
      quicker.collapse()
    else
      quicker.expand()
    end
    is_expanded = not is_expanded
  end, { desc = "Toggle quickfix expand/collapse" })
end

-- ============================================
-- = Commenting-related mappings              =
-- ============================================
if CONFIG.commentToggling then
  local feedkeys = vim.api.nvim_feedkeys
  map("n", "<leader>/", function()
    feedkeys("gcc", "x", true)
  end, { desc = "Toggle Line Comment" })
  map("v", "<leader>/", function()
    feedkeys("gb", "v", true)
  end, { desc = "Toggle Line Comment" })

  map("n", "<leader>Ct", function() --  󰢷 Task
    feedkeys("gcA", "v", false)
    feedkeys(" 󰢷  ", "v", false)
  end, { desc = "'Mark' 󰢷  Task" })
  map("n", "mt", function()
    feedkeys("gcA", "v", false)
    feedkeys(" 󰢷  ", "v", false)
  end, { desc = "'Mark' 󰢷  Task" })

  map("n", "<leader>Ci", function() --    Investigate
    feedkeys("gcA", "v", false)
    feedkeys("   ", "v", false)
  end, { desc = "'Mark'   Investigate" })
  map("n", "mi", function()
    feedkeys("gcA", "v", false)
    feedkeys("   ", "v", false)
  end, { desc = "'Mark'   Investigate" })

  map("n", "<leader>Cp", function() --    Pin
    feedkeys("gcA", "v", false)
    feedkeys("   ", "v", false)
  end, { desc = "'Mark'   Pin" })
  map("n", "mp", function()
    feedkeys("gcA", "v", false)
    feedkeys("   ", "v", false)
  end, { desc = "'Mark'   Pin" })

  map("n", "<leader>Cq", function() --   Question
    feedkeys("gcA", "v", false)
    feedkeys("  ", "v", false)
  end, { desc = "'Mark'  Question" })
  map("n", "mq", function()
    feedkeys("gcA", "v", false)
    feedkeys("  ", "v", false)
  end, { desc = "'Mark'  Question" })
end

-- ============================================
-- = FZF-Lua custom mappings                  =
-- ============================================
-- Todo-Comment specific integration w/ fzf-lua
if CONFIG.fileSearch.fzf_lua then
  local search = require("fzf-lua")
  map("n", "<leader>tf", function()
    search.grep({ search = "TODO|FIX|HACK|WARN|NOTE" })
  end, { desc = "Find TODOs" })
  map("n", "<leader>tc", function()
    search.live_grep({ rg_opts = "--type lua -e TODO|FIX|HACK" })
  end, { desc = "Find TODOs in Config" })

  map("n", "<leader>tt", function()
    search.grep({ search = "󰢷" })
  end, { desc = "Find all Tasks" })
  map("n", "<leader>ti", function()
    search.grep({ search = "" })
  end, { desc = "Find all Investigations" })
  map("n", "<leader>tp", function()
    search.live_grep({ search = "" })
  end, { desc = "Find all Pins" })
elseif CONFIG.fileSearch.telescope then
  local search = require("telescope.builtin")

  map("n", "<leader>tt", function() --  
    search.live_grep({
      default_text = "󰢷",
    })
  end, { desc = "Find all Tasks" })
  map("n", "<leader>ti", function()
    search.live_grep({
      default_text = "",
    })
  end, { desc = "Find all Investigations" })
  map("n", "<leader>tp", function()
    search.live_grep({
      default_text = "",
    })
  end, { desc = "Find all Pins" })
  map("n", "<leader>tq", function()
    search.live_grep({
      default_text = "",
    })
  end, { desc = "Find all Questions" })
end

-- ============================================
-- = Grug-Far Mappings                        =
-- ============================================
if CONFIG.grugfar then
  map("n", "<leader>fr", function()
    require("grug-far").open({ windowCreationCommand = "vsplit" })
  end, { desc = "Find and Replace" })
end

-- ============================================
-- = ShowKeys Mappings                        =
-- ============================================
map("n", "<leader>uk", "<cmd>ShowkeysToggle<CR>", { desc = "Show Keys while typing" })

-- ============================================
-- = Custom Modules Mappings                  =
-- ============================================
if CONFIG.custom.search_utils and (CONFIG.fileSearch.fzf_lua or CONFIG.fileSearch.telescope) then
  -- Custom search
  local command
  local custom_search = require("custom_search")
  if CONFIG.fileSearch.fzf_lua then
    command = custom_search.searchFile
  elseif CONFIG.fileSearch.telescope then
    command = custom_search.search_in_buffer
  end

  map("n", "/", command, { desc = "Custom search logic" })
  -- Enable if you prefer ripgrep to grep
  -- vim.keymap("n", "<leader>fw", custom_search.liveRipGrep, { desc = "Find Word" })
end

if CONFIG.custom.notes then
  -- Custom notes
  local custom_notes = require("custom_notes")
  map("n", "<leader>fn", custom_notes.openNotes, { desc = "Find Notes" })
  map("n", "<leader>N", custom_notes.openNotes, { desc = "Find Notes" })
  map("n", "<leader>n", custom_notes.openScratch, { desc = "Toggle To-Do" })
end
