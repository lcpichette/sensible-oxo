return {
  -- Functionality-level
  autocomplete = {
    blink = true,
  },
  dap = false, -- TODO: Expand to permit specifying DAPs
  lsp = true, -- TODO: Expand to permit specifying LSPs
  lint = true, --etc.
  format = true, --etc.
  fancyLSPPreviews = true,
  improvedMotions = true, -- Spider.nvim
  fileSearch = {
    fzf_lua = true,
  },
  quickfix = {
    quicker = true,
  },

  -- Package-level
  git = {
    neogit = true, -- UI Git interaction in neovim; "Magik" for nvim
    gitsigns = true, -- git diff indicators in buffer (left of line numbers)
  },
  neorg = false,
  grugfar = false,
  markview = true,
  blankline = true,
  hardtime = false,

  -- Experimental Custom Plugins
  custom = {
    notes = true, --TODO: Make this config opt matter
    silver_search = false, --TODO: Make this config opt matter
    search_utils = true, --TODO: Make this config opt matter
  },
}
