-- additional plugins
require('auto-hlsearch').setup()
require('better_escape').setup()
require("block").setup({
  percent = .7, -- .8=20% darker
})
require('bufferline').setup({options={
  right_mouse_command = false,
  middle_mouse_command = 'bdelete! %d',
  indicator = {style='underline'},
  offsets = { {
    filetype = 'NvimTree',
    text = '',
    text_align = 'center',
    separator = true,
  } },
  show_buffer_close_icons = true,
  show_close_icon = true,
  show_duplicate_prefix = true,
  show_tab_indicators = true,
  always_show_bufferline = true,
} })
-- require('dashboard').setup({
--   shuffle_letter = false,
--   disable_move = true,
--   config = { week_header = {enable = true, }}
-- })
-- require('fzf-lua').setup({})
require('f-string-toggle').setup({ key_binding = '<leader>fs' })
require('flatten').setup({ window = 'alternate', })
require('hardtime').setup({
  -- disabled_filetypes = {'NvimTree',}, -- not sure if/how to add terminal to this, nvimtree is already in defaults
  max_time = 1000, -- key repeat timer
  max_count = 3, -- number of repeats allowed within max_time
  disable_mouse = false,
  hint = true,
  notification = true,
  allow_different_key = true, -- reset count with different key
  enabled = true,
  restriction_mode = 'hint',
})
require('hmts')
require('lspconfig').bashls.setup({})
require('lspconfig').nixd.setup({})
require('lspconfig').lua_ls.setup({})
require('lspconfig').ruff.setup({})
require('lualine').setup({
  options = {
    theme = "moonfly",
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    global_status = true,
  },
  extensions = {'fzf'},
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'filename', 'echo nvim_treesitter#statusline(90)'},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
})
require('mini.animate').setup({scroll={enable=false}})
require('mini.clue').setup({
  triggers = {{ mode = 'i', keys = '<C-x>' }},
  clues = {require('mini.clue').gen_clues.builtin_completion()}
})
require('mini.completion').setup()
require('mini.cursorword').setup()
-- require('mini.icons').setup() -- still in beta and therefore not on stable branch
require('mini.indentscope').setup({symbol='│'})
require('mini.indentscope').gen_animation.none()
require('mini.move').setup()
require('mini.pairs').setup({
  modes = {insert=true, command=true, terminal=true},
  mappings = {
    ['<'] = { action = 'open', pair = '<>', neigh_pattern = '[^\\].' },
    ['>'] = { action = 'open', pair = '<>', neigh_pattern = '[^\\].' },
  }
})
-- require('mini.starter').setup()
require('mini.surround').setup()
require('modes').setup({
  line_opacity = 0.2,
  set_cursor = false,
})
require('nvim-tree').setup()
require('nvim-treesitter.configs').setup({
  highlight = {enable=true,},
  incremental_selection = {enable=true,},
  intentation = {enable=true,},
})
require('noice').setup({
  presets = {
    long_message_to_split = true,
    lsp_doc_border = true,
    command_palette = false,
  },
  -- cmdline and popupmenu together, from noice wiki
  views = {
    cmdline_popup = {
      position = {row=10, col='50%',},
      size = {width=60, height='auto'},
    },
    popupmenu = { -- this is the completion menu
      relative = 'editor',
      position = {row=13, col='50%',}, -- row is cmdline_popup row + 3
      size = {width=60, height=5,},
      border = {style='rounded', padding={0,1},},
      win_options = {winhighlight={Normal='Normal', FloatBorder='DiagnosticInfo',},},
    },
  },
  lsp = {
    override = {
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      ["vim.lsp.util.stylize_markdown"] = true,
    },
  },
})
vim.notify = require('notify').setup({
  render = "wrapped-compact",
  stages = "slide",
})
require('scrollview').setup()
require('nvim-web-devicons').setup({color_icons=true})
require('treesitter-context').setup({
  multiline_threshold = 4,
})
-- require('precognition').setup({
--   showBlankVirtLine = false,
--   hints = {
--     Caret = {text='H'},
--     Dollar = {text='L'},
--     MatchingPair = {text='M'},
--     w = {prio=0}, -- disable due to spider-overwrite
--     b = {prio=0},
--     e = {prio=0},
--   },
-- })
-- require('persistence').setup()
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
require('telescope').setup({
  extensions = {
    ['ui-select'] = {require('telescope.themes').get_dropdown({})},
    file_browser = {follow_symlinks=true},
    fzf = {},
  }
})
require('telescope').load_extension('ui-select')
require('telescope').load_extension('file_browser')
-- require('telescope').load_extension('frecency')
require('telescope').load_extension('fzf')
equire('texpresso')
require('tip').setup({seconds=2})
require('toggleterm').setup({
  start_in_insert = true,
  persist_mode = false,
})
require('window-picker').setup({
  hint = 'floating-big-letter',
})
require('which-key').setup({
  preset="helix",
  win={no_overlap=false},
  delay=0,
  expand = 2,
  icons = {keys={
    M='ALT ',
    C='CTRL '
  }},
  spec = {
    {"<leader>",function() require("which-key").show({ global = true }) end, desc="Toggle which-key", mode={'n','v'}}
  }
})
require('legendary').setup({
  extensions = {which_key = {
    auto_register = true,
    do_binding = false,
    use_groups = true,
  }}
})
