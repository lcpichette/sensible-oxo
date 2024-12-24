-- Save this file as `custom_neogit.lua` in your lua/ directory
local M = {}

local neogit = require('neogit')

function M.open_floating_neogit()
    -- Create a floating window
    local buf = vim.api.nvim_create_buf(false, true)
    local width = math.floor(vim.o.columns * 0.8)
    local height = math.floor(vim.o.lines * 0.8)
    local col = math.floor((vim.o.columns - width) / 2)
    local row = math.floor((vim.o.lines - height) / 2)

    local win = vim.api.nvim_open_win(buf, true, {
        relative = 'editor',
        width = width,
        height = height,
        col = col,
        row = row,
        style = 'minimal',
        border = 'rounded',
    })

    -- Open Neogit in this buffer
    vim.api.nvim_buf_set_option(buf, 'filetype', 'NeogitStatus')
    neogit.open({ kind = 'vsplit' })

    -- Set key mappings for the custom functionality
    vim.api.nvim_buf_set_keymap(buf, 'n', 'q', ':close<CR>', { noremap = true, silent = true })
    vim.api.nvim_buf_set_keymap(buf, 'n', 'c', '<cmd>lua require("neogit").open({ "commit" })<CR>', { noremap = true, silent = true })
    vim.api.nvim_buf_set_keymap(buf, 'n', 'p', '<cmd>lua require("neogit").open({ "pull" })<CR>', { noremap = true, silent = true })
    vim.api.nvim_buf_set_keymap(buf, 'n', 'P', '<cmd>lua require("neogit").open({ "push" })<CR>', { noremap = true, silent = true })
    vim.api.nvim_buf_set_keymap(buf, 'n', 'h', '<cmd>lua require("neogit").open({ "log", graph_style = "kitty" })<CR>', { noremap = true, silent = true })

    -- Automatically close window if buffer is deleted
    vim.api.nvim_create_autocmd('BufWipeout', {
        buffer = buf,
        callback = function()
            if vim.api.nvim_win_is_valid(win) then
                vim.api.nvim_win_close(win, true)
            end
        end,
    })
end

-- Expose the function
return M

