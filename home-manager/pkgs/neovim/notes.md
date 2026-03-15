# (Neo)Vim Notes

## Things of Interest

- roll personal keybinds for markdown-plus
- [preview css colours](https://github.com/catgoose/nvim-colorizer.lua)
  - [mini.nvim alternative](https://github.com/nvim-mini/mini.nvim/blob/main/readmes/mini-hipatterns.md)
  - [other alternative](https://github.com/dinh-khuong/csscolor.nvim)
- [highlight the lines referenced in cmdline commands](https://github.com/winston0410/range-highlight.nvim)
- [explore other features of already-installed comment.nvim](https://github.com/numToStr/Comment.nvim)
  - also fix insert mode toggling
- [consider adding new things to lualine?](https://github.com/nvim-lualine/lualine.nvim/wiki/Component-snippets)
- can i fix paste to just work with ctrl-v in insert mode
- colourschemes
  - [green](https://github.com/jpwol/thorn.nvim)
- [preview + execute code actions w/ telescope](https://github.com/rachartier/tiny-code-action.nvim)
- [harpoon - fileswitcher](https://github.com/ThePrimeagen/harpoon/tree/harpoon2)
- simpler options to display marks in the gutter
  - if marks.nvim ever gets which-key support i want that, but until then it's probably overkill
  - [guttermarks](https://github.com/dimtion/guttermarks.nvim)
- toggleterm
  - [fix toggleterm+lazygit](https://github.com/akinsho/toggleterm.nvim#custom-terminal-usage)
  - [change toggleterm default keybind](https://github.com/akinsho/toggleterm.nvim/wiki/Tips-and-Tricks#init-a-terminal-if-not-exist)
  - [select which pre-existing terminal you want to open](https://github.com/akinsho/toggleterm.nvim#termselect) - probably good for when i switch which buffer the terminal window is showing
- [project.nvim integration with mini.starter](github.com/DrKJeff16/project.nvim#ministarter)
- [telescope icons? not sure where these would actually be used](https://github.com/nvim-tree/nvim-web-devicons)
- figure out getting proper completion suggestions for cmdline
- [~ substitution in telescope paths](https://github.com/mizlan/dots-nightly/blob/ccdde23447ba189b50a53a4df08e630f2e2d2b18/init.lua#L436) - may be outdated by my current telescope path setup
- [send vim.ui.select to telescope](https://github.com/nvim-telescope/telescope-ui-select.nvim)
- quickfix improvements
  - [bqf (minor)](https://github.com/kevinhwang91/nvim-bqf)
  - [trouble (major)](https://github.com/folke/trouble.nvim)
- [remote development](https://github.com/nosduco/remote-sshfs.nvim)
  - there are probably alternatives to this that would be worth looking into
- [pretty block comments](https://github.com/s1n7ax/nvim-comment-frame)
- [mini.animate](https://github.com/nvim-mini/mini.nvim/blob/main/readmes/mini-animate.md)
- [tabout](https://github.com/abecodes/tabout.nvim) - more stars but last committed 2 years ago
  - [alternative](https://github.com/kawre/neotab.nvim)
- [goto-preview](https://github.com/rmagatti/goto-preview) - get similar functionality to this by removing telescope's LSP_definition keybind and only binding lsp_references? with a bigger window?
- [indent guides](https://github.com/lukas-reineke/indent-blankline.nvim)
  - [mini.nvim alternative](https://github.com/nvim-mini/mini.nvim/blob/main/readmes/mini-indentscope.md)
- [auto-add brackets on completions](github.com/windwp/nvim-autopairs#you-need-to-add-mapping-cr-on-nvim-cmp-setupcheck-readmemd-on-nvim-cmp-repo)
- [potentially useful snippets?](https://github.com/rafamadriz/friendly-snippets)

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
