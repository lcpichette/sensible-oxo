# Neovim Dotfiles


## ✨ Features

- **Minimalist Design:** Clean and focused user interface.
- **Modern Plugins:** Oldies can be goodies, but some of these new plugins just better(ies?)
- **Modular Configuration:** Easy to extend and maintain.
- **Intuitive Keybindings:** Streamlined navigation and editing experience.
- **Rich Developer Tools:** LSP, Treesitter, Git integration, and more.
- **Enhanced Aesthetics:** Eye-pleasing themes.

---

## 🎥 Random Showcases

- File creation, manipulation, searching, saving. (Oil, fzf-lua, arrow)
- Code snippets, autocomplete, git tracking, diagnostics, lsp indicators

https://github.com/user-attachments/assets/239f7596-3697-4c63-b94c-054479dfd87c

-- Motions with spider (`w` on `B` for `BufReadPre` goes to `R` instead of next word) and hop (`fts` search across buffer for `ts`).

https://github.com/user-attachments/assets/22b1b87e-eae7-478a-8111-7d57cdbae483


---

## 📦 Plugin Overview

### Plugins (36)
| Plugin | Purpose |
|--------|---------|
| [alpha-nvim](https://github.com/goolord/alpha-nvim) | Start screen customization |
| [arrow.nvim](https://github.com/arrow-plugin/arrow.nvim) | Smooth navigation and UI enhancements |
| [conform.nvim](https://github.com/stevearc/conform.nvim) | Automatic formatting |
| [dressing.nvim](https://github.com/stevearc/dressing.nvim) | UI improvements for input/select |
| [fidget.nvim](https://github.com/j-hui/fidget.nvim) | LSP progress indicators |
| [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) | Git integration |
| [hardtime.nvim](https://github.com/m4xshen/hardtime.nvim) | Discourage bad habits |
| [hop.nvim](https://github.com/phaazon/hop.nvim) | Quick navigation |
| [impatient.nvim](https://github.com/lewis6991/impatient.nvim) | Optimize startup time |
| [indent-blankline.nvim](https://github.com/lukas-reineke/indent-blankline.nvim) | Indentation guides |
| [lazy.nvim](https://github.com/folke/lazy.nvim) | Plugin manager |
| [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim) | Statusline |
| [noice.nvim](https://github.com/folke/noice.nvim) | Enhanced messaging |
| [nui.nvim](https://github.com/MunifTanjim/nui.nvim) | UI components library |
| [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) | Configurations for LSP |
| [nvim-notify](https://github.com/rcarriga/nvim-notify) | Notification system |
| [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) | Syntax highlighting |
| [nvim-web-devicons](https://github.com/kyazdani42/nvim-web-devicons) | File icons |
| [oil.nvim](https://github.com/stevearc/oil.nvim) | File explorer |
| [oxocarbon.nvim](https://github.com/nyoom-engineering/oxocarbon.nvim) | Theme |
| [plenary.nvim](https://github.com/nvim-lua/plenary.nvim) | Common utilities |
| [rainbow-delimiters.nvim](https://github.com/luukvbaal/rainbow-delimiters.nvim) | Bracket colorization |
| [targets.vim](https://github.com/wellle/targets.vim) | Extended text objects |
| [which-key.nvim](https://github.com/folke/which-key.nvim) | Keybinding hints |
| [cmp-buffer](https://github.com/hrsh7th/cmp-buffer) | Autocompletion source for buffer |
| [cmp-nvim-lsp](https://github.com/hrsh7th/cmp-nvim-lsp) | LSP source for nvim-cmp |
| [cmp-path](https://github.com/hrsh7th/cmp-path) | Path completion |
| [fzf-lua](https://github.com/ibhagwan/fzf-lua) | Fuzzy finder |
| [mason.nvim](https://github.com/williamboman/mason.nvim) | LSP/DAP installer |
| [nvim-bqf](https://github.com/kevinhwang91/nvim-bqf) | Better quickfix window |
| [nvim-cmp](https://github.com/hrsh7th/nvim-cmp) | Completion engine |
| [nvim-spider](https://github.com/chrisgrieser/nvim-spider) | Enhanced motions |
| [todo-comments.nvim](https://github.com/folke/todo-comments.nvim) | Highlight and search TODOs |
| [trouble.nvim](https://github.com/folke/trouble.nvim) | Diagnostics and quickfix UI |
| [vim-startuptime](https://github.com/dstein64/vim-startuptime) | Startup profiling |

---

## 🛠️ Installation

1. **Backup Your Existing Configuration**  
   Before proceeding, ensure you back up your current Neovim configuration to avoid losing any important settings:
   ```bash
   mv ~/.config/nvim ~/.config/nvim.backup
   mv ~/.local/share/nvim ~/.local/share/nvim.backup
   mv ~/.cache/nvim ~/.cache/nvim.backup
2. Clone the repository into your Neovim config directory:
   ```bash
   git clone https://github.com/lcpichette/sensible-oxo ~/.config/nvim
   ```

---

## ☑️ To-Do

Eventually I'd like to make a stupidly-simple interface for updating your neovim configuration while keeping it highly performant (`sensible`), with an opinionated styling, workflow, and toolset (`oxo`).

I'd like to think I'm 85% of the way their with the `oxo`, and about 20% of the way there with the `sensible`. Moving away from Astronvim removes bloat and LazyVim is innately pretty-easy to configure and the plugin location and file naming is I believe, mostly, pretty sensible. 

To get `oxo` to 100% we're going to need community feedback about alternatives (some plugins like fzf-lua vs telescope was a very intentional decision and I will NOT be adding it as a config option due to its a performance issues). Approved (specifiable in config) tools should be able to be turned on and off via the variable config (which does not exist yet). But, if there's a plugin you'd like to see supported via config option specify that in an issue on this repo -- I'm open to suggestions!

- [ ] Variable configs
   - Description: Changing variables in a config table `{ ascii_art = "cat" }` to `{ ascii_art = "saturn" }` will, in this example, change the ascii art shown by alpha-nvim to be a saturn instead of the current cat. 
   - [ ] Establish design Information Architecture that is easy to tweak and read `sensible-oxo`-specific configs that make performant changes to the overall project (We shouldn't load every config option; only load what we need and only when we need it)
   - [ ] Create config structure and default file.
   - [ ] Create loader to read these config options and load only what's relevant as per the specified config
   - [ ] Support the following config options:
      - [ ] Ascii Art changes to "dashboard" `{ ascii_art = "cat" }`
      - [ ] "Magic" LSP,Lint,Format selection based on desired supported filetypes `{ support_fts = { "lua", "ts", "js", "zig", "jsx", "tsx" } }`
      - [ ] Git (buffer) `{ git_buffer = true }`
      - [ ] Diagnostics (buffer) `{ diagnostics_buffer = true }`
      - [ ] Lualine selectable presets `{ lualine_preset = "default" }`
      - [ ] Commandline location `{ commandline_style = "floating" }`
- [~] Fix inconsistent coloring in ascii art
- [ ] Add project navigation
- [ ] Add quick terminal options (floating, horizontal, etc)
- [ ] Add sessions, if not too harmful to load time
- [~] Fix impatient not caching plugins to `~/.cache/nvim/luachache`

---

## 🤝 Credits

    Inspired by nyoom.nvim.
    Built with ❤️ using Neovim and the amazing plugin ecosystem.