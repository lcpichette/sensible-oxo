local CONFIG = require("oxo_config")
local M = {}

if CONFIG.fileSearch.fzf_lua then
  local fzf = require("fzf-lua")
  local utils = fzf.utils
  local actions = fzf.actions

  function M.searchFile()
    local current_file = vim.api.nvim_buf_get_name(0)
    if current_file == "" or vim.fn.filereadable(current_file) == 0 then
      local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
      fzf.fzf_exec(lines, {
        prompt = "Search buffer > ",
        actions = {
          ["enter"] = function(selected)
            local line_num = vim.fn.search(vim.fn.escape(selected[1], "\\/.*$^~[]"), "nw")
            if line_num > 0 then
              vim.api.nvim_win_set_cursor(0, { line_num, 0 })
            end
          end,
        },
      })
    else
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
elseif CONFIG.fileSearch.telescope then
  -- Search within the current buffer
  function M.search_in_buffer()
    local current_file = vim.api.nvim_buf_get_name(0)
    if current_file == "" or vim.fn.filereadable(current_file) == 0 then
      -- Buffer is not associated with a file; search buffer lines
      require("telescope.builtin").current_buffer_fuzzy_find({
        prompt_title = "Search Buffer",
      })
    else
      -- Buffer is associated with a file; use live_grep
      require("telescope.builtin").live_grep({
        prompt_title = "Search in File",
        search_dirs = { current_file },
      })
    end
  end

  -- Live grep using Ripgrep
  function M.live_ripgrep()
    require("telescope.builtin").live_grep({
      prompt_title = "Live Ripgrep",
      additional_args = function()
        return { "--column", "--color=always" }
      end,
    })
  end
end

return M
