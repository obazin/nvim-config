# Neovim Config – Kickstart-based, Modular, and Opinionated

Welcome! This is my personal Neovim configuration, designed for clarity, readability, and modern Neovim development.\
It started from the great [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim) distribution, but files have been split for maintainability, and plugins have been carefully chosen to match my workflow. Over everything else, i choosed kickstart for its outstanding pedagogical approach : more than a ready-to-go config, kickstart is both a documentation on how to build your own one plus a reasonnable starting point. 
This repo is basically just what i added to this starting point. 

## Approach

- **Readable & Modular**: All settings and plugin configs are organized into small files, easy to understand and extend.
- **Non-classic IDE**: By default, there is *no* file tree on the left (but it’s available if you want it). The idea is to promote navigation and fuzzy search as the main workflow. After all, neovim has its own capabilities, a full semantic approach with its motions and i like to idea to do not try to emulate most known IDEs user experience inside nvim, but this of course only personal choice.
- **Minimal yet Powerful**: Includes everything for a full-featured code/notes workflow, but nothing more.
- **Nerd Font Ready**: Make sure your terminal uses a Nerd Font for full symbol support.

---

## Installation

### 1. Install Neovim

#### **macOS**

```sh
brew install neovim
```

#### **Ubuntu**

```sh
sudo apt update
sudo apt install neovim
```

#### **Arch Linux**

```sh
sudo pacman -S neovim
```

**Recommended dependencies:**

- `git` (of course)
- latest version of node 
- `ripgrep` (for fast search)
- `fd` (for file finding)
- `fzf` (optional, for fuzzy finding)
- [Nerd Font](https://www.nerdfonts.com/) (install & set in your terminal)

### 2. Clone this config

First, back up your current config if you have one:

```sh
mv ~/.config/nvim ~/.config/nvim.backup
```

Then clone:

```sh
git clone https://github.com/obazin/nvim-config.git ~/.config/nvim
```

Open Neovim – plugins will auto-install via [lazy.nvim](https://github.com/folke/lazy.nvim).


### Beginners guide

This repo features a [beginners friendly guide](./neovim-training.md) to help you in your neovim journey. Its purpose is to suggest a kind of
training plan to build strong habits that will help you to feel free and fluent.


## Plugins Overview

Here’s how plugins are grouped in this config:

### Visual Comfort

- **Themes**:
  - [catppuccin](https://github.com/catppuccin/nvim)
  - [nordic](https://github.com/AlexvZyl/nordic.nvim)
  - [kanso](https://github.com/briones-gabriel/kanso.nvim)
- **UI Enhancements**:
  - `dashboard-nvim` (custom start screen, useful mainly to quickly reopen last edited files and have a clear view of
  last projects)
  - `noice.nvim` (better notifications and cmdline)
  - `which-key.nvim` (keymap hintsby just by pressing leader key)
  - `indent-blankline.nvim` (indent guides)
  - `zen-mode.nvim` (distraction free mode)
  - `dimming` (editor background dim)
  - `mini.nvim` (UI tweaks)
- **Folding & Conceal**:
  - Better folding and conceal options for cleaner code

### General Language Support

- **LSP & Formatting**:
  - `nvim-lspconfig` (provides healthy setups for most languages in conjonction with Mason)
  - `conform.nvim` (formatting, linting)
  - `blink` (completion)
  - `nvim-treesitter` (highlighting, structure) configured with text objects
- **Snippets**:
  - [LuaSnip](https://github.com/L3MON4D3/LuaSnip) (if configured) & friendly-snippets 

### Specific Language Support

- **Rust**:
  - `rustaceanvim` (Rust tools)
- **Tailwind CSS**:
  - Tailwind tools integration
- **Markdown/Notes**:
  - Markdown preview & support
  - [Obsidian.nvim](https://github.com/epwalsh/obsidian.nvim)

### IDE Features

- **Navigation**:

  - `telescope.nvim` (fuzzy find everything : files, symbols, class members, etc ...)
  - `vim-tmux-navigator` (move between tmux/nvim panes)
  - `aerial.nvim` (outline/symbols)
  - `neo-tree.nvim` (file tree, *not started automatically when neovim opems a folder*, you can enable this behavior if you want)

- **Version Control**:

  - `lazygit.nvim`

- **Editing**:

  - `nvim-autopairs` (auto-close pairs)
  - `Comment.nvim` (quick comments)
  - `neoclip.nvim` (clipboard history)
  - TODO highlighting (`todo-comments.nvim`)

- **Debug**:

  - DAP (Debug Adapter Protocol) support and UI, set up mainly for Rust

- **Troubleshooting**:

  - `trouble.nvim` (diagnostics in a panel)

- **Clipboard, Yazi (file manager integration), etc**

### AI (Optional)

- `avante` (great AI assistant made with offering a cursor-like experience to neovim users, without the price) 
- (You can also uncomment ChatGPT, Copilot plugins if you want)

---

## Customization

- All config is split in the `lua/` folder for easier navigation.
- You can add or remove plugins by editing/removing/adding the corresponding files in `lua/plugins/`.

---

## Credits

- [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim) for the original structure.
- All plugin authors!

---

## License

MIT

