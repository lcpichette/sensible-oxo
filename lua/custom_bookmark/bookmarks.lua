local api = vim.api

local M = {}


function M.key_bind()
    vim.keymap.set("n", "mo", function() require("custom_bookmark.list").jump() end,
        { desc = "bookmarks jump", silent = true })

    -- add local bookmarks
    vim.keymap.set("n", "mm", function() require("custom_bookmark.list").add_bookmark() end,
        { desc = "bookmarks add", silent = true })

    -- delete bookmarks
    vim.keymap.set("n", "mD", function() require("custom_bookmark.list").delete() end,
        { desc = "bookmarks delete", silent = true })
end

--
function M.autocmd()
    api.nvim_create_autocmd({ "VimLeave" }, {
        callback = require("custom_bookmark.list").persistent
    })

    api.nvim_create_autocmd({ "BufWritePost" }, {
        callback = function()
            local buf = api.nvim_get_current_buf()
            require("custom_bookmark.list").set_marks(buf, require("custom_bookmark.list").get_buf_bookmark_lines(buf))
        end
    })

    api.nvim_create_autocmd({ "BufWinEnter" }, {
        callback = function()
            local buf = api.nvim_get_current_buf()
            require("custom_bookmark.list").set_marks(buf, require("custom_bookmark.list").get_buf_bookmark_lines(buf))
        end
    })
end

function M.setup()
    vim.cmd("hi link bookmarks_virt_text_hl Comment")
    vim.fn.sign_define("BookmarkSign", { text = "󰃃" })

    M.key_bind()
    M.autocmd()
    require("custom_bookmark.list").setup()
end

return M
