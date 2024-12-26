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

function M.liveRipGrep(opts)
  local fzf_lua = require("fzf-lua")
  opts = opts or {}
  opts.prompt = "rg> "
  opts.git_icons = true
  opts.file_icons = true
  opts.color_icons = true
  -- setup default actions for edit, quickfix, etc
  opts.actions = fzf_lua.defaults.actions.files
  -- see preview overview for more info on previewers
  opts.previewer = "builtin"
  opts.fn_transform = function(x)
    return fzf_lua.make_entry.file(x, opts)
  end
  -- we only need 'fn_preprocess' in order to display 'git_icons'
  -- it runs once before the actual command to get modified files
  -- 'make_entry.file' uses 'opts.diff_files' to detect modified files
  -- will probaly make this more straight forward in the future
  opts.fn_preprocess = function(o)
    opts.diff_files = fzf_lua.make_entry.preprocess(o).diff_files
    return opts
  end
  return fzf_lua.fzf_live(function(q)
    return "rg --column --color=always -- " .. vim.fn.shellescape(q or "")
  end, opts)
end

return M
