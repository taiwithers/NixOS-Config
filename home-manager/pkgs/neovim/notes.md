# (Neo)Vim Notes

## Things of Interest

- [consider adding new things to lualine?](https://github.com/nvim-lualine/lualine.nvim/wiki/Component-snippets)
- can i fix paste to just work with ctrl-v in insert mode
- colourschemes
  - [green](https://github.com/jpwol/thorn.nvim)
- [preview + execute code actions w/ telescope](https://github.com/rachartier/tiny-code-action.nvim)
- [harpoon - fileswitcher](https://github.com/ThePrimeagen/harpoon/tree/harpoon2)
- simpler options to display marks in the gutter
  - if marks.nvim ever gets which-key support i want that, but until then it's probably overkill
  - [guttermarks](https://github.com/dimtion/guttermarks.nvim)
- [telescope integration w/ marks.nvim](https://github.com/chentoast/marks.nvim/issues/71) - not super necessary since which-key already shows marks
- toggleterm
  - [fix toggleterm+lazygit](https://github.com/akinsho/toggleterm.nvim#custom-terminal-usage)
  - [change toggleterm default keybind](https://github.com/akinsho/toggleterm.nvim/wiki/Tips-and-Tricks#init-a-terminal-if-not-exist)
  - [select which pre-existing terminal you want to open](https://github.com/akinsho/toggleterm.nvim#termselect) - probably good for when i switch which buffer the terminal window is showing
- [project.nvim integration with mini.starter](http://github.com/DrKJeff16/project.nvim#ministarter)
- [~ substitution in telescope paths](https://github.com/mizlan/dots-nightly/blob/ccdde23447ba189b50a53a4df08e630f2e2d2b18/init.lua#L436) - may be outdated by my current telescope path setup
- quickfix improvements
  - [bqf (minor)](https://github.com/kevinhwang91/nvim-bqf)
  - [quicker](https://github.com/stevearc/quicker.nvim)
  - [trouble (major)](https://github.com/folke/trouble.nvim)
- [potentially useful snippets?](https://github.com/rafamadriz/friendly-snippets)
- something to insert (relative?) filepath at cursor location (for adding markdown images)
- caplock warning?
- [better lsp hoves for typescript](https://github.com/Sebastian-Nielsen/better-type-hover) - not sure to what extent I actually need this
- [undotree](https://github.com/mbbill/undotree) (built in to nvim 0.12)

- use telescope more
- fix cmp mappings in cmdline/search
- change <esc> in insert mode w/ cmp open to just close the cmp menu
- use telescope to insert filepaths (for importing stuff?)
- fix tab completion in cmdline (stop tabs from bringing up the usual menu, this might mean turning off nvim's native completion)

## 0.12

- [look at builtin `nohlsearch` and `undotree`](https://neovim.io/doc/user/plugins/)
- [pumborder option](https://github.com/neovim/neovim/blob/fc7e5cf6c93fef08effc183087a2c8cc9bf0d75a/runtime/doc/news.txt#L326)
- [lsp-inline-completion](https://github.com/neovim/neovim/blob/fc7e5cf6c93fef08effc183087a2c8cc9bf0d75a/runtime/doc/news.txt#L219)
- [incremental selection](https://github.com/neovim/neovim/blob/fc7e5cf6c93fef08effc183087a2c8cc9bf0d75a/runtime/doc/news.txt#L237)
- [native autocomplete stuff](https://github.com/neovim/neovim/blob/fc7e5cf6c93fef08effc183087a2c8cc9bf0d75a/runtime/doc/news.txt#L305)
- add foldinner from ufo readme

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
