local CONFIG = require("oxo_config")

-- Plugins specific to altering the UI of neovim
return {
  -- dressing.nvim: Improve Neovim's UI for input and selection
  {
    "stevearc/dressing.nvim",
    event = "VeryLazy", -- Load the plugin when Neovim is idle
    opts = {
      -- Customize the UI components
      input = {
        -- Default options for input UI
        enabled = true,
        default_prompt = "➤ ",
        prompt_align = "left",
        insert_only = true,
        start_in_insert = true,
        relative = "editor",
        prefer_width = 60,
        width = nil,
        max_width = nil,
        min_width = 20,
        border = "rounded",
        anchor = "NW",
        pos = "100%",
        row = 1,
        col = 1,
      },
      select = {
        -- Default options for select UI
        enabled = true,
        backend = { "telescope", "builtin" },
        builtin = {
          -- Customize the selection UI
          border = "rounded",
          -- Position the selection window at the top
          anchor = "NW",
          -- Optional: Adjust the position offset
          post = "100%",
        },
      },
    },
    config = function(_, opts)
      require("dressing").setup(opts)
    end,
  },

  -- LSP Progress indicator
  {
    "j-hui/fidget.nvim",
    tag = "legacy",
    enabled = CONFIG.lspStatusIndicators,
    config = function()
      require("fidget").setup({
        text = {
          spinner = "dots",
        },
        window = {
          relative = "win",
          blend = 0,
        },
        fmt = {
          stack_upwards = true,
          lsp_client_name = true,
          task = false,
        },
      })
    end,
  },

  -- statusline, bottom status line (~0.5ms startup time)
  {
    --"beauwilliams/statusline.lua",
    "lcpichette/statusline-darkplus.nvim",
    enabled = CONFIG.statusline.statusline,
    event = "BufWinEnter",
  },

  -- lualine, bottom status line (~4ms+ startup time)
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons", "lewis6991/gitsigns.nvim" },
    event = "BufWinEnter",
    enabled = CONFIG.statusline.lualine,
    config = function()
      local lualine = require("lualine")

      local oxo = {
        fg = "#edf0fc", -- Default foreground
        purple = "#bb9af7", -- Purple for edits
        blue = "#7aa2f7", -- Blue for creates
        red = "#f7768e", -- Red for deletes
      }

      -- Highlight groups for Git diff colors
      vim.api.nvim_set_hl(0, "LualineDiffAdd", { fg = oxo.blue })
      vim.api.nvim_set_hl(0, "LualineDiffChange", { fg = oxo.purple })
      vim.api.nvim_set_hl(0, "LualineDiffDelete", { fg = oxo.red })
      local function git_diff()
        local gitsigns_data = vim.b.gitsigns_status_dict
        if not gitsigns_data then
          return ""
        end

        local added = gitsigns_data.added or 0
        local changed = gitsigns_data.changed or 0
        local removed = gitsigns_data.removed or 0

        return string.format(
          "%s%s%s",
          added > 0 and ("%#LualineDiffAdd#+%d "):format(added) or "",
          changed > 0 and ("%#LualineDiffChange#~%d "):format(changed) or "",
          removed > 0 and ("%#LualineDiffDelete#-%d "):format(removed) or ""
        )
      end

      local function lsp_info()
        local clients = vim.lsp.get_active_clients({ bufnr = 0 })
        if #clients == 0 then
          return ""
        end
        local names = {}
        for _, client in ipairs(clients) do
          table.insert(names, client.name)
        end
        return " " .. table.concat(names, ", ")
      end

      -- Configure lualine
      lualine.setup({
        options = {
          theme = {
            normal = { c = { fg = oxo.fg } },
            inactive = { c = { fg = oxo.fg } },
          },
          section_separators = "",
          component_separators = "",
          disabled_filetypes = { statusline = {}, winbar = {} },
          always_divide_middle = false,
          globalstatus = true,
        },
        sections = {
          -- Left sections
          lualine_a = {
            {
              "mode",
              fmt = function(mode)
                return mode:sub(1, 1)
              end,
              color = { fg = oxo.purple, gui = "bold" },
            },
          },
          lualine_b = {
            { "filename", color = { fg = oxo.fg } },
          },
          lualine_c = {
            {
              "branch",
              icons_enabled = false,
              fmt = function(branch)
                return "(" .. branch .. ")"
              end,
              color = { fg = oxo.fg },
            },
          },
          -- Right sections
          lualine_x = { { "diff", git_diff } },
          lualine_y = {
            {
              "diagnostics",
              sources = { "nvim_lsp" },
              symbols = { error = "" .. " ", warn = "" .. " ", info = "󰙎 ", hint = "󰌶 " },
              diagnostics_color = {
                error = { fg = oxo.red },
                warn = { fg = oxo.purple },
                info = { fg = oxo.blue },
                hint = { fg = oxo.fg },
              },
            },
            {
              lsp_info,
              color = { fg = oxo.blue },
            },
          },
          lualine_z = {},
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { "filename" },
          lualine_x = { "location" },
          lualine_y = {},
          lualine_z = {},
        },
        extensions = {},
      })
    end,
  },

  -- "Splash art" for opening neovim without specifying a file
  {
    "goolord/alpha-nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" }, -- Add dependencies if needed
    enabled = CONFIG.ui.splash_art.alpha,
    config = function()
      local alpha = require("alpha")
      local dashboard = require("alpha.themes.dashboard")

      -- the dashboard header
      dashboard.section.header.val = [[
      ⠀
        _                ___       _.--.
        \`.|\..----...-'`   `-._.-'_.-'`
        /  ' `         ,       __.^
        )/' _/     \   `-_,   /
        `-'" `"\_  ,_.-;_.-\_ ',     
            _.-'_./   {_.'   ; /
bug.       {_.-``-'         {_/
      ]]

      local searchCommands = {
        {
          name = "fzf_lua",
          commands = {
            ":FzfLua files<CR>",
            ":FzfLua live_grep<CR>",
            ":FzfLua resume<CR>",
            ":FzfLua help_tags<CR>",
          },
        },
        {
          name = "telescope",
          commands = {
            ":Telescope find_files<CR>",
            ":Telescope live_grep<CR>",
            ":Telescope resume<CR>",
            ":Telescope help_tags<CR>",
          },
        },
      }

      if not CONFIG.fileSearch.snap then
        local commands
        if CONFIG.fileSearch.telescope then
          commands = searchCommands[2].commands
        elseif CONFIG.fileSearch.fzf_lua then
          commands = searchCommands[1].commands
        end
        dashboard.section.buttons.val = {
          dashboard.button("f", "  Find Files", commands[1]),
          dashboard.button("w", "  Live Grep", commands[2]),
          dashboard.button("r", "  Resume Search", commands[3]),
          dashboard.button("h", "?  Help Tags", commands[4]),
          dashboard.button("q", "  Quit", ":qa<CR>"),
        }
      end

      -- center content
      dashboard.config.layout = {
        { type = "padding", val = 8 }, -- Add top padding
        dashboard.section.header,
        { type = "padding", val = 2 }, -- Space between header and buttons
        dashboard.section.buttons,
        { type = "padding", val = 2 }, -- Add some padding after buttons
      }

      alpha.setup(dashboard.opts)
    end,
  },

  {
    "rcarriga/nvim-notify",
    enabled = CONFIG.ui.popups.notify,
    config = function()
      local notify = require("notify")

      -- Set up nvim-notify with Oxocarbon-style highlights
      ---@diagnostic disable-next-line: missing-fields
      notify.setup({
        stages = "static", -- Or any preferred animation
        timeout = 3000, -- Time for notifications to disappear
        background_colour = "#000000", -- Use Oxocarbon's preferred background color
        fps = 10,
        on_open = function(win)
          vim.api.nvim_win_set_config(win, { focusable = false })
        end,
      })

      -- Custom highlights for Oxocarbon theme
      vim.cmd([[
        highlight NotifyINFOBorder guifg=#78dce8
        highlight NotifyINFOTitle  guifg=#78dce8
        highlight NotifyINFOIcon   guifg=#78dce8

        highlight NotifyWARNBorder guifg=#fc9867
        highlight NotifyWARNTitle  guifg=#fc9867
        highlight NotifyWARNIcon   guifg=#fc9867

        highlight NotifyERRORBorder guifg=#ff6188
        highlight NotifyERRORTitle  guifg=#ff6188
        highlight NotifyERRORIcon   guifg=#ff6188

        highlight NotifyDEBUGBorder guifg=#a9dc76
        highlight NotifyDEBUGTitle  guifg=#a9dc76
        highlight NotifyDEBUGIcon   guifg=#a9dc76

        highlight NotifyTRACEBorder guifg=#ab9df2
        highlight NotifyTRACETitle  guifg=#ab9df2
        highlight NotifyTRACEIcon   guifg=#ab9df2
      ]])

      -- Set notify as default for vim notifications
      vim.notify = notify
    end,
  },

  -- Changes alerts, command line aesthetic and location, and some other ui things
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    enabled = CONFIG.ui.popups.noice,
    opts = {
      cmdline = {
        enabled = true,
        view = "cmdline",
        opts = {
          position = {
            row = 0, -- Position at the very top
            col = 2, -- Align to the left
          },
          size = {
            width = "80%",
            height = 1, -- Keep it one line tall
          },
        },
        format = {
          cmdline = { pattern = "^:", icon = "", lang = "vim" },
          search_down = { kind = "search", pattern = "^/", icon = " ", lang = "regex" },
          search_up = { kind = "search", pattern = "^%?", icon = " ", lang = "regex" },
          filter = { pattern = "^:%s*!", icon = "$", lang = "bash" },
          lua = { pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" }, icon = "", lang = "lua" },
          help = { pattern = "^:%s*he?l?p?%s+", icon = "" },
          input = { view = "cmdline", icon = "󰥻 " }, -- Classic feel
        },
      },
      popupmenu = {
        enabled = true,
        backend = "nui",
      },
      messages = {
        enabled = true,
        view = "notify",
      },
      lsp = {
        progress = {
          enabled = true,
          view = "mini",
        },
        hover = {
          enabled = true,
        },
        signature = {
          enabled = true,
          auto_open = {
            enabled = true,
            trigger = true,
            luasnip = true,
            throttle = 50,
          },
        },
      },
      notify = {
        enabled = true,
        view = "notify",
      },
      presets = {
        bottom_search = false, -- Disable classic bottom search
        command_palette = false,
        inc_rename = false,
        lsp_doc_border = false,
      },
    },
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
  },

  -- Show keys while typing
  {
    "nvzone/showkeys",
    cmd = "ShowkeysToggle",
    opts = {
      timeout = 1,
      maxkeys = 5,
      show_count = true,
    },
  },
}
