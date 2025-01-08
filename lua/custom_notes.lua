local M = {}

-- Search notes via fzf
-- local fzf = require("fzf-lua")
-- local utils = fzf.utils
-- local actions = fzf.actions

local CONFIG = {
  dir = "~/Notes",
  scratch = "~/Notes/scratch.md",
}

function M.setup(opts)
  CONFIG = opts or CONFIG
end

vim.api.nvim_create_user_command("OxoNotes", function()
  M.openNotes()
end, {})

vim.api.nvim_create_user_command("OxoScratch", function()
  M.openScratch()
end, {})

-- Function to expand '~' to the user's home directory
local function expand_tilde(path)
  if path:sub(1, 1) == "~" then
    local home = os.getenv("HOME") or os.getenv("USERPROFILE") -- For Windows compatibility
    return home .. path:sub(2)
  end
  return path
end

function M.openNotes()
  M.open(CONFIG.dir)
end

function M.openScratch()
  M.open(CONFIG.scratch)
end

function M.open(path)
  vim.cmd("vsplit")
  vim.cmd("edit " .. expand_tilde(path))

  vim.bo.modifiable = true
end

return M
