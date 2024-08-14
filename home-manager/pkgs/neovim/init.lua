local cmd = vim.cmd -- vim api/builtins
local fn = vim.fn -- user-functions https://neovim.io/doc/user/eval.html#user-function
local opt = vim.o -- equivalent to :set 
local g = vim.g -- define global variables
local map = vim.keymap.set

-- <leader> key. Defaults to `\`. Some people prefer space.
g.mapleader = ' '
-- g.maplocalleader = ' '

require('options')
require('plugins')
require('keymaps')
require('autocommands')
vim.g.colors_name = base16theme -- activate colour scheme?
