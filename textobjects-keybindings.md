# Treesitter Textobjects Keybindings

Vim's built-in motions (`w`, `b`, `e`, `{`, `}`) operate on syntactic tokens — words, sentences, paragraphs. Treesitter textobjects go further: they let you select, move, and swap based on the **semantic structure** of your code. Instead of thinking "delete the next 3 lines", you think "delete this function", "swap these two arguments", or "jump to the next conditional". This makes editing intent-driven rather than positional, and the same keys work across every language treesitter supports.

Provided by [nvim-treesitter-textobjects](https://github.com/nvim-treesitter/nvim-treesitter-textobjects). Configured in `lua/plugins/lang/treesitter.lua`.

---

## Select

Use with operators (`d`, `c`, `y`, `v`). Prefix `a` = around, `i` = inside.

| Key   | Object                  |
|-------|-------------------------|
| `af`  | Function call (outer)   |
| `if`  | Function call (inner)   |
| `am`  | Method/function def     |
| `im`  | Method/function def     |
| `ac`  | Class                   |
| `ic`  | Class                   |
| `ai`  | Conditional             |
| `ii`  | Conditional             |
| `al`  | Loop                    |
| `il`  | Loop                    |
| `aa`  | Parameter/argument      |
| `ia`  | Parameter/argument      |
| `a=`  | Assignment (outer)      |
| `i=`  | Assignment (inner)      |
| `l=`  | Assignment left-hand    |
| `r=`  | Assignment right-hand   |
| `a:`  | Object property (outer) |
| `i:`  | Object property (inner) |
| `l:`  | Property left-hand      |
| `r:`  | Property right-hand     |

Example: `daf` deletes a function call, `cim` changes the body of a function, `via` selects an argument.

---

## Move

Navigate between code elements using `]` (next) and `[` (previous). Lowercase = jump to start, uppercase = jump to end. All movements are added to the jumplist (`<C-o>` to go back).

| Next start | Prev start | Next end | Prev end | Object              |
|------------|------------|----------|----------|---------------------|
| `]f`       | `[f`       | `]F`     | `[F`     | Function call       |
| `]m`       | `[m`       | `]M`     | `[M`     | Method/function def |
| `]c`       | `[c`       | `]C`     | `[C`     | Class               |
| `]i`       | `[i`       | `]I`     | `[I`     | Conditional         |
| `]l`       | `[l`       | `]L`     | `[L`     | Loop                |
| `]s`       | `[s`       |          |          | Scope               |
| `]z`       | `[z`       |          |          | Fold                |

Example: `]m` jumps to the next function definition, `[i` jumps back to the previous if-block.

---

## Swap

Reorder adjacent code elements. `<leader>s` prefix. Lowercase = swap with next, uppercase = swap with previous.

| Next           | Previous       | Object            |
|----------------|----------------|-------------------|
| `<leader>sa`   | `<leader>sA`   | Parameter/argument |
| `<leader>s:`   | `<leader>s;`   | Object property    |
| `<leader>sm`   | `<leader>sM`   | Method/function    |

Example: with the cursor on a function argument, `<leader>sa` swaps it with the next argument.
