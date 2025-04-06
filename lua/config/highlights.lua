-- This file is for character highlighting
local CONFIG = require("oxo_config")

-- Rainbow Brackets
if CONFIG.blankline then
  -- If activeHighlight
  local hooks = require("ibl.hooks")
  hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
    vim.api.nvim_set_hl(0, "InactiveIndent", { fg = "#202020" }) -- Color for inactive indent lines
    vim.api.nvim_set_hl(0, "ActiveScopeIndent", { fg = "#333333" }) -- Color for active scope indent lines
  end)
  require("ibl").setup({
    indent = {
      highlight = "InactiveIndent",
    },
    scope = {
      enabled = true,
      highlight = "ActiveScopeIndent",
    },
  })

  -- If rainbow
  --[[ local hooks = require("ibl.hooks")
  hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
    vim.api.nvim_set_hl(0, "RainbowDelimiterRed", { fg = "#E06C75" })
    vim.api.nvim_set_hl(0, "RainbowDelimiterYellow", { fg = "#E5C07B" })
    vim.api.nvim_set_hl(0, "RainbowDelimiterBlue", { fg = "#61AFEF" })
    vim.api.nvim_set_hl(0, "RainbowDelimiterOrange", { fg = "#D19A66" })
    vim.api.nvim_set_hl(0, "RainbowDelimiterGreen", { fg = "#98C379" })
    vim.api.nvim_set_hl(0, "RainbowDelimiterViolet", { fg = "#C678DD" })
    vim.api.nvim_set_hl(0, "RainbowDelimiterCyan", { fg = "#56B6C2" })
  end) ]]
end

-- Colored Icons
vim.cmd([[
  highlight! CmpItemAbbr guibg=NONE
  highlight! CmpItemAbbrMatch guibg=NONE
  highlight! CmpItemAbbrMatchFuzzy guibg=NONE
  highlight! CmpItemKind guibg=NONE
  highlight! CmpItemKindFunction guifg=#C678DD guibg=NONE
  highlight! CmpItemKindKeyword guifg=#61AFEF guibg=NONE
  highlight! CmpItemKindSnippet guifg=#E5C07B guibg=NONE
  highlight! CmpItemKindVariable guifg=#98C379 guibg=NONE
  highlight! CmpItemKindText guifg=#ABB2BF guibg=NONE
  highlight! CmpItemKindClass guifg=#E06C75 guibg=NONE
]])

-- Search results (`/` register)
vim.api.nvim_set_hl(0, "Search", { fg = "#161616", bg = "#78A9FF", bold = true }) -- Oxocarbon blue for search matches
vim.api.nvim_set_hl(0, "IncSearch", { fg = "#161616", bg = "#3DDC97", bold = true })
vim.api.nvim_set_hl(0, "CurSearch", { fg = "#161616", bg = "#3DDC97", bold = true }) -- Oxocarbon green
