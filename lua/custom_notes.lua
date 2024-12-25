local M = {}

-- Search notes via fzf
-- local fzf = require("fzf-lua")
-- local utils = fzf.utils
-- local actions = fzf.actions

local CONFIG = {
  dir = "~/Notes/scratch.md",
}

-- Function to expand '~' to the user's home directory
local function expand_tilde(path)
  if path:sub(1, 1) == "~" then
    local home = os.getenv("HOME") or os.getenv("USERPROFILE") -- For Windows compatibility
    return home .. path:sub(2)
  end
  return path
end

function M.setup(opts)
  CONFIG = opts or CONFIG
end

function M.openNote()
  -- Move create user command to setup
  vim.api.nvim_create_user_command("OxoNotes", function()
    local buf = vim.api.nvim_create_buf(false, true)
    local file_path = expand_tilde(CONFIG.dir)
    local file = io.open(file_path, "r")

    print("test 3" .. CONFIG.dir)
    if file == nil then
      print("Invalid directory specified for notes")
      return
    end
    local content = file:read("*all")
    file:close()
    print("test 3" .. content)

    -- Set the buffer content
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(content, "\n"))

    -- Set buffer name and filetype
    vim.api.nvim_buf_set_name(buf, file_path)
    vim.bo[buf].filetype = vim.fn.fnamemodify(file_path, ":e")

    vim.api.nvim_open_win(buf, true, {
      split = "right",
      win = 0,
    })
  end, { desc = "Open notes vertically" })
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(":OxoNotes<CR>", true, false, true), "n", true)
end

return M
