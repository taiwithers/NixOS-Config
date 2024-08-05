-- add keymappings with which-key
local lazygit_terminal = require('toggleterm.terminal').Terminal:new({ 
  cmd = "lazygit", 
  hidden = true,
  display_name = "lazygit",
  direction = 'float',
})
function lazygit_toggle()
  lazygit_terminal:toggle()
end
require('which-key').add({
  -- mode characters: https://neovim.io/doc/user/map.html#map-listing

  -- normal, visual, select, and operator-pending modes
  { mode = {'n', 'v', 'o'},
    {'H', '^', desc='Start of line'}, -- overwrites "cursor to line N from top of screen"
    {'L', '$', desc='End of line'}, -- overwrites "cursor to line N from bottom of screen"
    {'M', '%', desc='Matching ()[]{}'}, --overwrites cursor to middle of screen
    {'j', [[v:count == 0 ? 'gj' : 'j']], expr=true, desc='Down (visual line)'},
    {'k', [[v:count == 0 ? 'gk' : 'k']], expr=true, desc='Up (visual line)'},
    {'w', '<cmd>lua require("spider").motion("w")<CR>', desc='Next word (spider)'},
    {'e', '<cmd>lua require("spider").motion("e")<CR>', desc='Next end of word (spider)'},
    {'b', '<cmd>lua require("spider").motion("b")<CR>', desc='Previous word (spider)'},
  },

  -- normal, visual, and select modes
  { mode = {'n', 'v'},
    {'gy', '"+y', desc = 'Copy to system clipboard'},
    {';', ':', desc='Enter command mode'}, -- save shift key
    {';ww', '<cmd>w<CR>', desc='Save buffer'},
  },

  -- normal and visual modes
  { mode = {'n','x'},
    {'<C-s>', '<Cmd>silent! update | redraw<CR>', desc='Save'},
  },

  -- visual mode
  { mode = {'x'}, 
    {'g/', '<esc>/\\%V', desc = 'Search inside visual selection', silent=false}, -- silence makes it take effect immediately
  },

  -- normal mode
  { mode = {'n'}, 
    {'q', '<NOP>', desc='Remove recording mapping', hidden=true} ,
    {'Q', '<NOP>', desc='Remove mini.clue recording mapping', hidden=true} ,
    {'@', '<NOP>', desc='Remove mini.clue macro mapping', hidden=true} ,
    {'<C-q>', '<cmd>bdelete<CR>', desc='Close buffer'},
    {'<C-n>', '<cmd>vnew<CR>', desc='Vertical split to new buffer'},
    {'<S-C-n>', '<cmd>enew<CR>', desc='Horizontal split to new buffer'},
    {'<M-n>', '<cmd>new<CR>', desc='New buffer'},
    {'<leader>f', '<cmd>NvimTreeToggle<CR>', desc='Toggle filetree'},
    {'<leader>t', '<cmd>ToggleTerm<CR>', desc='Toggle lower terminal'},
    {'<leader>lg', '<cmd>lua lazygit_toggle()<CR>', desc='Toggle lower terminal'},
  },

  -- insert mode
  { mode = {'i'}, 
    {'<C-s>', '<Esc><Cmd>silent! update | redraw<CR>', desc='Save and go to Normal mode'},
  },

  -- insert mode and command mode
  { mode = {'i', 'c'}, 
    {'<C-a>', '<Home>', desc='Start of line'},
    {'<C-e>', '<End>', desc='End of line'},
  },

  -- terminal mode
  { mode = {'t'},
    {'<C-[>', '<C-\\><C-n>', desc='Go to normal mode'},
    {'<LeftRelease>', '<LeftRelease><cmd>startinsert<CR>'},
  }
})
