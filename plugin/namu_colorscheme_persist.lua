-- Persisted colorscheme module (auto-generated by namu.nvim)
vim.g.NAMU_SCHEME = "darkplus" -- Initial colorscheme from setup

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    pcall(vim.cmd.colorscheme, vim.g.NAMU_SCHEME)
  end,
})

vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function(params)
    vim.g.NAMU_SCHEME = params.match
  end,
})
