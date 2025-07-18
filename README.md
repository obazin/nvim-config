# Neovim Config – Kickstart-based, Modular, and Opinionated

Welcome! This is my personal Neovim configuration, designed for clarity, readability, and modern Neovim development.\
It started from the great [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim) distribution, but files have been split for maintainability, and plugins have been carefully chosen to match my workflow.

## Approach

- **Readable & Modular**: All settings and plugin configs are organized into small files, easy to understand and extend.
- **Non-classic IDE**: By default, there is *no* file tree on the left (but it’s available if you want it). The idea is to promote navigation and fuzzy search as the main workflow.
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

- `git` (for plugin management)
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
git clone https://github.com/yourusername/your-nvim-config.git ~/.config/nvim
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
  - `dashboard-nvim` (custom start screen)
  - `noice.nvim` (better notifications and cmdline)
  - `which-key.nvim` (keymap hints)
  - `indent-blankline.nvim` (indent guides)
  - `zen-mode.nvim` (distraction free mode)
  - `dimming` (editor background dim)
  - `mini.nvim` (UI tweaks)
- **Folding & Conceal**:
  - Better folding and conceal options for cleaner code

### General Language Support

- **LSP & Formatting**:
  - `nvim-lspconfig`
  - `null-ls.nvim` (formatting, linting)
  - `nvim-cmp` (completion)
  - `nvim-treesitter` (highlighting, structure)
- **Snippets**:
  - [LuaSnip](https://github.com/L3MON4D3/LuaSnip) (if configured)

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

  - `telescope.nvim` (fuzzy find everything)
  - `vim-tmux-navigator` (move between tmux/nvim panes)
  - `aerial.nvim` (outline/symbols)
  - `neo-tree.nvim` (file tree, *not started automatically when neovim opems a folder*, enable this behavior if you want)

- **Version Control**:

  - `lazygit.nvim` (in-Nvim git)

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

- `avante` (local AI assistant)
- (You can also uncomment ChatGPT, Copilot plugins if you want)

---

## File Explorer

> **Note:** By default, *no* file explorer is shown on the left for a more modern, fuzzy-find or yazi based workflow.
>
> If you want a file tree, just enable `neo-tree` in the config!

---

## Customization

- All config is split in the `lua/` folder for easier navigation.
- You can add or remove plugins by editing the corresponding files in `lua/plugins/`.

---

## Credits

- [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim) for the original structure.
- All plugin authors!

---

## License

MIT

