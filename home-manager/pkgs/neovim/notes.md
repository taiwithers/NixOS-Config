# (Neo)Vim Notes

## LSP

- Work through diagnostics: `:lua require("telescope.builtin").diagnostics() <cr> <C-q> <cr>`
- Show information about the symbol below the cursor: `:lua vim.lsp.bum.hover()<cr>`
- LSP keymappings are under `gr` by default

## Quickfix

- `:copen` and `:close` control the quickfix list, which is a window like any other
- While the quickfix list is populated, `:cn` and `:cp` can be used to jump to the next/previous entry (this can also be done be navigating the list as a buffer, and hitting enter)
- `:cdo` applies an action to all entries in the quickfix list. For example `:cdo s/find/replace`
- `:lua require("telescope.builtin").quickfix()` will open the quickfix list entries in a telescope window

### Populating the quickfix list

- In telescope, `C-q` will send all current results to the quickfix list
- In an LSP-enabled buffer, `grr` will populate the quickfix list with references to the word under the cursor (These can be seen in telescope instead of the quickfix list with `:lua require("telescope.builtin").lsp_references()`)

