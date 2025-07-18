## Getting Started With Neovim: A Training Plan for Beginners

Neovim (and Vim) is unique—mastering it changes the way you work. Here’s a simple step-by-step training plan to build strong foundations and avoid common frustrations:

### 1. Learn With `vimtutor`

- **Before anything else:**  
  Run `vimtutor` from your terminal and follow the tutorial. Do it regularly (not just once!). It’s the quickest, most effective way to build muscle memory for basic motions and commands.

### 2. Understand the Modes

- **Take the habit of switching modes:**  
  - Normal mode (`ESC`)
  - Insert mode (`i`, `a`, `o`, etc.)
  - Visual mode (`v`, `V`, `Ctrl-v`)
  - Command-line mode (`:`)
- Practice switching and know which mode you’re in at all times.

### 3. Get Comfortable With Registers & Clipboard

- **Registers:**  
  Learn about the unnamed register, numbered registers, and especially the `+` register for system clipboard.
- **Copy/Paste:**  
  Know the difference between `yy`, `p`, `"*p`, `"+p`, etc.
- **System Clipboard:**  
  Try copying from Neovim and pasting into another app (and vice versa).

### 4. Master Basic Motions

- **Move with purpose:**  
  - `h` `j` `k` `l` (left, down, up, right)
  - `w`, `b`, `e` (next/previous word)
  - `{` `}` (paragraphs)
  - `gg`, `G` (start/end of file)
- **Repeat:**  
  Use numbers to repeat (e.g., `3w` = move three words forward).

### 5. Learn to Search and Jump

- **Searching:**  
  - `/` (forward search)
  - `n` / `N` (next/previous match)
- **Find character in line:**  
  - `f<char>`, `t<char>`, `;`, `,`

### 6. Learn Substitute and Global Commands

- **Substitute (`:s`):**  
  - `:s/old/new/` (on the current line)
  - `:%s/old/new/g` (in the whole file)
- **Global (`:g`) commands:**  
  Use `:g/pattern/cmd` for powerful, multi-line edits.

### 7. Internalize Neovim “Grammar”

- **Command structure:**  
  - Verb + Motion/Delimiter + Object (e.g., `ciw` = Change Inside Word, `di(` = Delete Inside Parentheses)
  - Learn a few: `ciw`, `viw`, `di{`, `caw`, etc.
- **Visualize every edit as a *sentence* using this grammar.**

### 8. Enhance With Treesitter & Text Objects

- **Treesitter:**  
  Enables smart text objects for code (e.g., functions, classes).
- **Use enhanced motions:**  
  - `af`/`if` (a function / inner function)
  - `ac`/`ic` (a class / inner class)
  - Move and edit *semantic* units (not just lines or words).

### 9. Explore IDE Features

- **Now, discover Neovim as a modern IDE:**  
  - LSP (Language Server Protocol) features: *go to definition, declaration, code actions, rename, hover, diagnostics*, etc.
  - Try fuzzy-finding files and symbols, running code actions, debugging, and more—**after** you’re comfortable with the basics.

---

### Why This Order?

Vim/Neovim rewards foundational skills. IDE features feel “magical” only if you’re comfortable moving and editing with precision!

---

**See my [Resource Links](#) for further reading and video tutorials.  
Happy hacking!**

---

