# (Neo)Vim Notes

## Things of Interest

- [consider adding new things to lualine?](https://github.com/nvim-lualine/lualine.nvim/wiki/Component-snippets)
- colourschemes
    - [green](https://github.com/jpwol/thorn.nvim)
- [preview + execute code actions w/ telescope](https://github.com/rachartier/tiny-code-action.nvim)
- simpler options to display marks in the gutter
    - if marks.nvim ever gets which-key support i want that, but until then it's probably overkill
    - [guttermarks](https://github.com/dimtion/guttermarks.nvim)
- [telescope integration w/ marks.nvim](https://github.com/chentoast/marks.nvim/issues/71) - not super necessary since which-key already shows marks
- toggleterm
    - [fix toggleterm+lazygit](https://github.com/akinsho/toggleterm.nvim#custom-terminal-usage)
    - [change toggleterm default keybind](https://github.com/akinsho/toggleterm.nvim/wiki/Tips-and-Tricks#init-a-terminal-if-not-exist)
    - [select which pre-existing terminal you want to open](https://github.com/akinsho/toggleterm.nvim#termselect) - probably good for when i switch which buffer the terminal window is showing
- caplock warning?
- [better lsp hovers for typescript](https://github.com/Sebastian-Nielsen/better-type-hover) - not sure to what extent I actually need this
- [screenkey](https://github.com/NStefan002/screenkey.nvim)
- [native session management](https://neovim.io/doc/user/usr_21/#_sessions)
- [vimscript plugin for swapping line/charwise pastes](https://github.com/inkarkat/vim-UnconditionalPaste) - could potentially do some hacking to merge this with neoclip

- use telescope more
- change <esc> in insert mode w/ cmp open to just close the cmp menu
- in addition to yanking file name from yazi, figure out how to do that with telescope
- frecency sorting for telescope files
    - probably don't want to use this: https://github.com/mollerhoj/telescope-recent-files.nvim/tree/5866846c84a5bc9077425bbd7557414f464123b1

- reduce width of number/status column for help windows
- `git mergetool` opens nvim in conflict resolution mode
    - does nvim know it's in conflict resolution mode? if so, want to add ]c/[c to which-key (next/prev conflict), and also add branch names to winbars
    - top left is main (assuming you have main checked out, and are merging in feature)
    - top right is feature
    - top centre is base (shared common ancestor)
    - bottom is editable final (merged) version

- [prioritized diagnostic jumps](https://github.com/5long/dotfiles/blob/b80eed21e03b5937c830bbeb092ffe9baad33f60/nvim/lua/config/prioritized_diagnostic.lua)

```lua
-- Add undo break-points
vim.keymap.set("i", ",", ",<c-g>u")
vim.keymap.set("i", ".", ".<c-g>u")
vim.keymap.set("i", ";", ";<c-g>u")
```

## 0.12

- [look at builtin `undotree`](https://neovim.io/doc/user/plugins/)
- [pumborder option](https://github.com/neovim/neovim/blob/fc7e5cf6c93fef08effc183087a2c8cc9bf0d75a/runtime/doc/news.txt#L326)
- [lsp-inline-completion](https://github.com/neovim/neovim/blob/fc7e5cf6c93fef08effc183087a2c8cc9bf0d75a/runtime/doc/news.txt#L219)
- [incremental selection](https://github.com/neovim/neovim/blob/fc7e5cf6c93fef08effc183087a2c8cc9bf0d75a/runtime/doc/news.txt#L237)
- [native autocomplete stuff](https://github.com/neovim/neovim/blob/fc7e5cf6c93fef08effc183087a2c8cc9bf0d75a/runtime/doc/news.txt#L305)
- ui2 (noice replacement) stuff
    - [tiny-cmdline](https://github.com/rachartier/tiny-cmdline.nvim)
    - [notifications](https://www.reddit.com/r/neovim/comments/1sfmgkb/how_does_the_new_ui2_message_cmdline_replacement/oeyrgua/)
- [highlights for undotree](https://www.reddit.com/r/neovim/comments/1sd7gqb/undotree_visual_feedback/)

## Native completion

- [starting point](https://justinhj.github.io/2026/04/06/refreshing-your-neovim-config-for-0-12-0.html#orgb35f839)
- will want to just read docs

## LSP

- Work through diagnostics: `:lua require("telescope.builtin").diagnostics() <cr> <C-q> <cr>`
- Show information about the symbol below the cursor: `:lua vim.lsp.bum.hover()<cr>`
- LSP keymappings are under `gr` by default
- `[d` and `]d` jump to previous/next diagnostic

## Quickfix

- `:copen` and `:close` control the quickfix list, which is a window like any other
- While the quickfix list is populated, `:cn` and `:cp` can be used to jump to the next/previous entry (this can also be done be navigating the list as a buffer, and hitting enter)
- `:cdo` applies an action to all entries in the quickfix list. For example `:cdo s/find/replace`
- `:lua require("telescope.builtin").quickfix()` will open the quickfix list entries in a telescope window

### Populating the quickfix list

- In telescope, `C-q` will send all current results to the quickfix list
- In an LSP-enabled buffer, `grr` will populate the quickfix list with references to the word under the cursor (These can be seen in telescope instead of the quickfix list with `:lua require("telescope.builtin").lsp_references()`)
