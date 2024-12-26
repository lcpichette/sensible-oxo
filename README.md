# (Sensible) Neovim Dotfiles, Oxocarbon-Themed


![2024-12-24@04 33 36 December-24@2x](https://github.com/user-attachments/assets/054f75e9-1586-48a4-91df-204b0b2c4486)
![2024-12-26@13 11 55 December-26@2x](https://github.com/user-attachments/assets/55abd557-d6cf-491d-b64c-c95b6e1a0299)


## ✨ Features

- **Minimalist Design:** Clean and focused user interface.
- **Modern Plugins:** Oldies can be goodies, but some of these new plugins just better(ies?)
- **Modular Configuration:** Easy to extend and maintain.
- **Intuitive Keybindings:** Streamlined navigation and editing experience.
- **Rich Developer Tools:** LSP, Treesitter, Git integration, and more.
- **Enhanced Aesthetics:** Eye-pleasing themes.

## 🎥 Random Showcases

- File fuzzy searching (fzf-lua)
- Better quickfix lists and opening results into paneled splits on the same buffer (fzf-lua + bqf)



https://github.com/user-attachments/assets/c3ccd7ad-f2b6-4be4-abcb-f469ff339256



---

- File creation, manipulation, saving. (Oil)
- File fuzzy searching (fzf-lua)
- File favoriting (Arrow -- "Harpoon-like")
- Code snippets, formatting, autocomplete, git tracking, diagnostics, lsp indicators
- Toggleable ShowKeys (deferred to load only when ran -- for performance)

https://github.com/user-attachments/assets/6a78d7ab-eda4-463a-a839-850ec7f1ce38

---

- Motions:
   - Spider (`w` on `B` for `BufReadPre` goes to `R` instead of next word)
   - Hop (`fts` search across buffer for `ts`).

https://github.com/user-attachments/assets/22b1b87e-eae7-478a-8111-7d57cdbae483


## 📦 Plugin Overview

### Installed Plugins (41)
| Plugin | Purpose |
|--------|---------|
| [alpha-nvim](https://github.com/goolord/alpha-nvim) | Start screen customization |
| [arrow.nvim](https://github.com/arrow-plugin/arrow.nvim) | Smooth navigation and UI enhancements |
| [Comment.nvim](https://github.com/numToStr/Comment.nvim) | Commenting utility |
| [conform.nvim](https://github.com/stevearc/conform.nvim) | Automatic formatting |
| [dressing.nvim](https://github.com/stevearc/dressing.nvim) | UI improvements for input/select |
| [fidget.nvim](https://github.com/j-hui/fidget.nvim) | LSP progress indicators |
| [fzf-lua](https://github.com/ibhagwan/fzf-lua) | Fuzzy finder |
| [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) | Git integration |
| [hop.nvim](https://github.com/phaazon/hop.nvim) | Quick navigation |
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
| [targets.vim](https://github.com/wellle/targets.vim) | Extended text objects |
| [todo-comments.nvim](https://github.com/folke/todo-comments.nvim) | Highlight and search TODOs |
| [vim-sleuth](https://github.com/tpope/vim-sleuth) | Indentation detection |
| [which-key.nvim](https://github.com/folke/which-key.nvim) | Keybinding hints |
| [cmp-buffer](https://github.com/hrsh7th/cmp-buffer) | Autocompletion source for buffer |
| [cmp-nvim-lsp](https://github.com/hrsh7th/cmp-nvim-lsp) | LSP source for nvim-cmp |
| [cmp-path](https://github.com/hrsh7th/cmp-path) | Path completion |
| [mason-lspconfig.nvim](https://github.com/williamboman/mason-lspconfig.nvim) | Mason LSP configs |
| [mason.nvim](https://github.com/williamboman/mason.nvim) | LSP/DAP installer |
| [nvim-autopairs](https://github.com/windwp/nvim-autopairs) | Auto-closing pairs |
| [nvim-bqf](https://github.com/kevinhwang91/nvim-bqf) | Better quickfix window |
| [nvim-cmp](https://github.com/hrsh7th/nvim-cmp) | Completion engine |
| [nvim-spider](https://github.com/chrisgrieser/nvim-spider) | Enhanced motions |
| [showkeys.nvim](https://github.com/mrjones2014/showkeys.nvim) | Display active keybindings |
| [trouble.nvim](https://github.com/folke/trouble.nvim) | Diagnostics and quickfix UI |
| [vim-startuptime](https://github.com/dstein64/vim-startuptime) | Startup profiling |
| [grug-far.nvim](https://github.com/example/grug-far.nvim) | Search and replace w/ friendly UI |

### Disabled Plugins (3)

These are plugins that I may want to enable in the future -- whether I find myself needing them,
willing to compromise the performance hit for them, or find additional ways to better mitigate their
performance hits. 

Due to this, I've left them in the codebase but disabled (no performance hit).

| Plugin | Purpose |
|--------|---------|
| [neogit](https://github.com/TimUntersberger/neogit) | Disabled |
| [rainbow-delimiters.nvim](https://github.com/luukvbaal/rainbow-delimiters.nvim) | Disabled |
| [hardtime.nvim](https://github.com/m4xshen/hardtime.nvim) | Discourage bad habits; Disabled bc I find it doesn't pop-up often and it has non-zero perforamance imapct. |

### Rejected Plugins

These are plugins I tried and either felt didn't fit within the desired workflow or performance guidelines this project set out to meet.

| Plugin | Reason |
|--------|--------|
| [Neorg](https://github.com/nvim-neorg/neorg) | Performance hit was 20+ms, and workflow can be met with simpler tooling |
| [Telescope](https://github.com/nvim-telescope/telescope.nvim) | Performance hit was 15+ms even after optimizing it, fzf-lua fits the workflow and is more performant |
| Anything AI | Coding is more fun when you know what you're doing |
| [Trailblazer](https://github.com/LeonHeidelbach/trailblazer.nvim) | Arrow fits my personal development workflow better, open to moving this to `disabled` instead |
| [Menu](https://github.com/nvzone/menu) | Anti-synergy between Mouse + Neovim IMO, maybe I'm misunderstanding if it has keyboard potential. Other plugins I'd rather have in exchange for its performance hit. |


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


## ☑️ To-Do

Eventually I'd like to make a stupidly-simple interface for updating your neovim configuration while keeping it highly performant (`sensible`), with an opinionated styling, workflow, and toolset (`oxo`).

I'd like to think I'm 85% of the way their with the `oxo`, and about 20% of the way there with the `sensible`. Moving away from Astronvim removes bloat and LazyVim is innately pretty-easy to configure and the plugin location and file naming is I believe, mostly, pretty sensible. 

To get `oxo` to 100% we're going to need community feedback about alternatives (some plugins like fzf-lua vs telescope was a very intentional decision and I will NOT be adding it as a config option due to its a performance issues). Approved (specifiable in config) tools should be able to be turned on and off via the variable config (which does not exist yet). But, if there's a plugin you'd like to see supported via config option specify that in an issue on this repo -- I'm open to suggestions!

NOT STARTED:
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
- [ ] Add project navigation
- [ ] Add quick terminal options (floating, horizontal, etc)
- [ ] Add sessions, if not too harmful to load time

WIP:
- [ ] Add custom notes
   - [ ] Syntax highlighting
   - [ ] Persistent changes
   - [ ] Incredibly quick to load notes and the module

DONE:
- [x] Change `/` to use fzf-lua + vim search register w/ Oxo highlighting.
- [x] Fix inconsistent coloring in ascii art

## 🤝 Credits

    Inspired by nyoom.nvim.
    Built with ❤️ using Neovim and the amazing plugin ecosystem.
