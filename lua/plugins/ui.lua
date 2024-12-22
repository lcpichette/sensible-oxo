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

  -- lualine dependency
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" }, -- Load on file open
    config = function()
      require("gitsigns").setup({
        signs = {
          add = { text = "+" },
          change = { text = "~" },
          delete = { text = "-" },
        },
      })

      vim.api.nvim_set_hl(0, "GitSignsAdd", { fg = "#7aa2f7" }) -- Blue
      vim.api.nvim_set_hl(0, "GitSignsChange", { fg = "#bb9af7" }) -- Purple
      vim.api.nvim_set_hl(0, "GitSignsDelete", { fg = "#f7768e" }) -- Red
    end,
  },

  -- lualine, bottom status line
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons", "lewis6991/gitsigns.nvim" },
    config = function()
      local lualine = require("lualine")

      -- Define Oxocarbon color palette
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

      -- Helper function to abbreviate the folder path
      local function abbreviate_path(filepath)
        local parts = vim.split(filepath, "/")
        for i = 1, #parts - 1 do
          parts[i] = parts[i]:sub(1, 2) -- Keep only the first 2 characters of each folder
        end
        return table.concat(parts, "/")
      end

      -- Custom filename component with abbreviated folders
      local function custom_filename()
        local filepath = vim.fn.expand("%:p") -- Full file path
        local relative_path = vim.fn.fnamemodify(filepath, ":~:.:") -- Relative to cwd
        return abbreviate_path(relative_path)
      end

      -- Helper function to display git diff stats
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

      -- Helper function to get active LSP servers
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
            { custom_filename, color = { fg = oxo.fg } },
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
              symbols = { error = " ", warn = " ", info = " ", hint = " " },
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
    config = function()
      -- Initialize the dashboard theme
      local alpha = require("alpha")
      local dashboard = require("alpha.themes.dashboard")

      vim.api.nvim_set_hl(0, "AlphaHeader", { fg = "#7dcfff" }) -- Example: Blue text color
      vim.api.nvim_set_hl(0, "AlphaButtons", { fg = "#bb9af7" }) -- Example: Purple text for buttons

      -- Apply the highlight group to the header
      dashboard.section.header.opts.hl = "AlphaHeader"

      -- Customize the dashboard header
      dashboard.section.header.val = [[
        _                ___       _.--.
        \`.|\..----...-'`   `-._.-'_.-'`
        /  ' `         ,       __.--'
        )/' _/     \   `-_,   /
        `-'" `"\_  ,_.-;_.-\_ ',     
            _.-'_./   {_.'   ; /
bug.       {_.-``-'         {_/
      ]]

      -- Optionally customize the buttons (emptying them as per your original config)
      dashboard.section.buttons.val = {}

      -- Set up the alpha with the customized dashboard
      alpha.setup(dashboard.opts)
    end,
  },

  -- Changes alerts, command line aesthetic and location, and some other ui things

  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      cmdline = {
        enabled = true,
        view = "cmdline", -- Use the classic cmdline view
        opts = {
          position = {
            row = 0, -- Position at the very top
            col = 2, -- Align to the left
          },
          size = {
            width = "80%", -- Extend across the width of the buffer
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
}
