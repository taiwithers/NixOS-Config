-- Neovim builtin options
-- See :h <option> to see what the options do

vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
-- vim.g.loaded_node_provider = 0

vim.g.editorconfig = true
vim.cmd("syntax on")

local opt = vim.o -- equivalent to :set

-- indentation
opt.autochdir = false
opt.autoindent = true -- using this instead of treesitter
opt.breakindent = true -- wrapped lines maintain indentation
opt.copyindent = true -- when autoindenting, follow the tab/space convention of other lines in file
opt.expandtab = true -- use spaces not tabs
opt.shiftwidth = 2 -- width of an indent in spaces
opt.smarttab = true -- use shiftwidth instead of tabstop when pressing tab at the start of a line
opt.softtabstop = 2 -- in insert mode, tab moves this many spaces (instead of inserting a tab char)
opt.smartindent = true -- smart indent when starting new line

-- completion - completion is mostly done w/ nvim-cmp
opt.completeopt = "menuone,noinsert,noselect"
opt.wildchar = 0 -- avoid triggering native cmdline completion w/ default <Tab>
opt.wildignore = "__pycache__,*.pyc" -- unused - native cmdline completion
opt.wildmode = "list:longest" -- unused - native cmdline completion
opt.infercase = true

-- ui/visuals
-- opt.cmdheight = 2 -- how many lines to use for the command line when not in use, no effect w/ noice
opt.cursorline = true -- highlight current line
opt.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
opt.number = true -- print line numbers
opt.relativenumber = true -- print relative line numbers
opt.signcolumn = "yes:2" --always show 3 wide
opt.statusline = "%<%f %h%m%r %= %(%l,%c%V%)" -- format for statusline
opt.statusline = "" -- format for statusline
opt.tabline = "" -- tabline content
opt.termguicolors = true
opt.winblend = 0 -- transparency of floating windows
opt.winborder = "rounded" -- for stuff like lsp hover window
opt.showmode = true -- indicate mode in statusline
opt.scrolloff = 10 -- minimum lines above/below cursor

-- folding - handled by nvim-ufo in init.lua
opt.foldcolumn = "auto" -- when/how to draw the fold column
opt.foldlevel = 99 -- start editing with no folds closed
opt.foldlevelstart = 99 -- start editing with no folds closed
opt.foldminlines = 5 -- only allow closing folds if they are X + 1 lines when open
opt.foldnestmax = 5 -- don't nest folds too deeply

-- pumwindow (window that appears on mouse click)
opt.pumblend = 0 -- transparency for popup menu
opt.pumheight = 10 -- popup menu lines
opt.pumwidth = 50 -- popup menu width

-- spellcheck
opt.spell = false -- spellchecking, turned on for certain filetypes in init.lua
opt.spelllang = "en_ca"
opt.spelloptions = "camel"
opt.spellsuggest = "best" -- note number of suggestions is run by whichkey

-- searching
opt.grepprg = "batgrep" -- not sure if this will work....
opt.hlsearch = true -- highlight matches from the last search
opt.ignorecase = true -- ignore search case by default
opt.incsearch = true -- show search matches while typing
opt.smartcase = true -- override ignorecase if search string contains uppercase
opt.wrapscan = true -- wrap searches

-- text wrapping
opt.linebreak = true -- don't wrap lines mid-word
opt.showbreak = "    " -- string to print at start of wrapped lines
opt.wrap = true

-- other
opt.clipboard = "unnamedplus" -- use system clipboard if available ?
opt.confirm = true -- raise dialog instead of failing if say :q fails
opt.guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20,a:blinkon400"
opt.history = 100 -- how many : commands to store
opt.iskeyword = "@,48-57,192-255" -- remove _ from the default list of word breaks
opt.laststatus = 3 -- required for global lualine
opt.matchpairs = "(:),{:},[:]" -- characters that form pairs
opt.mouse = "a" -- mouse support in all modes
opt.mousemodel = "popup" -- action for mouse presses
opt.nrformats = "alpha,unsigned" -- number formats to recognize for increment/decrement
opt.path = vim.o.path .. "**" -- Search down into subfolders
opt.previewwindow = true -- "identifies the preview window"
opt.showmatch = true -- Highlight matching parentheses, etc
opt.splitbelow = true
opt.splitright = true -- where to put new windows
opt.tm = 500 -- ms timeout for mapped sequences
opt.undofile = true
opt.visualbell = true
