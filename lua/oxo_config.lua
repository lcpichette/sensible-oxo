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
  lspStatusIndicators = true, -- Messages visible bottom right indiciating load status of LSPs
  fileSearch = {
    fzf_lua = true,
    snap = false,
    telescope = false,
  },
  namu = true,
  quickfix = {
    quicker = false,
  },
  statusline = {
    lualine = false,
    statusline = true,
  },
  autopairs = {
    mini = false,
    autopairs = true,
  },
  commentToggling = true,
  ui = {
    splash_art = {
      alpha = true,
    },
    popups = {
      notify = true,
      noice = false,
    },
  },

  -- Package-level
  git = {
    neogit = false, -- UI Git interaction in neovim; "Magik" for nvim
    gitsigns = false, -- git diff indicators in buffer (left of line numbers)
  },
  neorg = false,
  grugfar = false,
  markview = true,
  blankline = false, -- Indent guideline fluff
  hardtime = false,
  glance = true,
  arrow = true,
  bookmarks = false,
  spelunk = false,

  -- Experimental Custom Plugins
  custom = {
    notes = true, --TODO: Make this config opt matter
    silver_search = false, --TODO: Make this config opt matter
    search_utils = true, --TODO: Make this config opt matter
  },
}
