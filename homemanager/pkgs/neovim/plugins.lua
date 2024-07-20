-- additional plugins
-- nui.nvim, plenary.nvim
require("block").setup({
  percent = .7, -- .8=20% darker
  -- automatic = true,
})
require('fzf-lua').setup({})
require('lspconfig').bashls.setup({})
require('lspconfig').nixd.setup({})
require('lspconfig').lua_ls.setup({})
require('lspconfig').ruff.setup({})
require('lualine').setup({
  options = {
    theme = "moonfly",
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
  },
  tabline = {
    lualine_a = {'buffers'},
    -- lualine_b = {'tabs'},
  },
  -- winbar = {lualine_c = {'filename'}},
  extensions = {'fzf'}
})
require('mini.animate').setup({scroll={enable=false}})
require('mini.clue').setup({
  triggers = {{ mode = 'i', keys = '<C-x>' }},
  clues = {require('mini.clue').gen_clues.builtin_completion()}
})
-- require('mini.completion').setup({set_vim_settings=false,fallback_action='<C-x>s'})
require('mini.cursorword').setup()
-- require('mini.icons').setup() -- still in beta and therefore not on stable branch
require('mini.indentscope').setup({symbol='│'})
require('mini.indentscope').gen_animation.none()
require('mini.move').setup()
require('mini.pairs').setup()
require('mini.surround').setup()
require('modes').setup({
  line_opacity = 0.2,
  set_cursor = false,
})
require('neo-tree').setup({
  hide_root_node = true,
  sort_case_insensitive=true,
  source_selector = {
    statusline = true,
    show_scrolled_off_parent_node = true,
  },
})
require('noice').setup()
vim.notify = require('notify')
require('nvim-web-devicons').setup({color_icons=true})
require('precognition').setup({
  showBlankVirtLine = false,
  hints = {
    Caret = {text='H'},
    Dollar = {text='L'},
    MatchingPair = {text='M'},
    w = {prio=0}, -- disable due to spider-overwrite
    b = {prio=0},
    e = {prio=0},
  },
})
require('tabout').setup({
  tabkey = '<Tab>',
  backwards_tabkey = '<S-Tab>',
  act_as_tab = true, -- if not in brackets, move line left/right
  act_as_shift_tab = true,
  default_tab = '<C-t>', -- line move action to take at beginning of a line
  default_shift_tab = '<C-d>',
  completion = false, -- set this if tab is also used for completion selection disables tabout when pum is open(?)
  ignore_beginning = true, -- if at the beginning of brackets, tab out instead of indenting
  tabouts = {
    { open = "'", close = "'" },
    { open = '"', close = '"' },
    { open = '`', close = '`' },
    { open = '(', close = ')' },
    { open = '[', close = ']' },
    { open = '{', close = '}' },
  },
  exclude = {}, -- filetypes
})
require('toggleterm').setup()
require('which-key').setup({
  preset="helix",
  win={no_overlap=false}, 
  delay=0,
  expand = 2,
  -- key_labels={"<cr>" = "<return>"}, -- not sure about syntax of <cr> here
  icons = {keys={
    M='ALT ',
    C='CTRL '
  }},
  spec = {
    {"<leader>",function() require("which-key").show({ global = true }) end, desc="Toggle which-key", mode={'n','v'}}
  }
})
