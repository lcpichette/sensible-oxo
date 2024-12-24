local M = {}

local fzf = require("fzf-lua")
local utils = fzf.utils
local actions = fzf.actions

function M.searchFile()
  fzf.lgrep_curbuf({
    actions = {
      ["enter"] = function(sel, opts)
        actions.file_edit(sel, opts)
        local last_query = opts.last_query

        if not last_query or #last_query == 0 then
          return
        end

        local regex = utils.regex_to_magic(opts.last_query)
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("/" .. regex .. "<CR>N", true, false, true), "n", true)
      end,
    },
  })
end

return M
