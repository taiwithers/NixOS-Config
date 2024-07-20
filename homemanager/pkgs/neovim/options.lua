-- Neovim builtin options 
-- See :h <option> to see what the options do

vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0

local opt = vim.o -- equivalent to :set 

opt.autochdir = false
opt.autoindent = true
opt.breakindent = true -- wrapped lines maintain indentation
opt.cmdheight = 2 -- how many lines to use for the command line when not in use
opt.compatible = false
opt.completeopt = 'menuone,noinsert,noselect'
opt.confirm = true -- raise dialog instead of failing if say :q fails
opt.copyindent = true -- when autoindenting, follow the tab/space convention of other lines in file
opt.cursorline = true -- highlight current line
opt.expandtab = true -- use spaces not tabs
opt.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
opt.foldcolumn = 'auto' -- when/how to draw the fold column
opt.foldenable = true
opt.foldlevelstart = 99 -- start editing with no folds closed
opt.foldmethod = 'syntax' -- manual, indent, expr, marker, syntax, diff
opt.foldminlines = 5 -- unsure exactly what this does
opt.grepprg = 'batgrep' -- not sure if this will work....
opt.guicursor='n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20,a:blinkon400'
opt.history = 100 -- how many : commands to store
opt.hlsearch = true -- highlight matches from the last search
opt.ignorecase = true -- ignore search case by default
opt.incsearch = true -- show search matches while typing
opt.infercase = true
opt.linebreak = true -- don't wrap lines mid-word
opt.matchpairs = '(:),{:},[:]' -- characters that form pairs
opt.mouse = 'a' -- mouse support in all modes
opt.mousemodel = 'popup' -- actione for mouse presses
opt.nrformats = 'alpha,unsigned' -- number formats to recogize for increment/decrement
opt.number = true -- print line numbers
opt.path = vim.o.path .. '**' -- Search down into subfolders
opt.previewwindow = true -- "identifies the preview window"
opt.pumblend = 0 -- transparency for popup menu
opt.pumheight = 10 -- popup menu lines
opt.pumwidth = 50 -- popup menu width
opt.relativenumber = true -- print relative line numbers
opt.ruler = true -- show cursor line/column
opt.scrolloff = 10 -- minimum lines above/below cursor
opt.shiftwidth = 2
opt.showbreak = '    ' -- string to print at start of wrapped lines
opt.showmatch = true -- Highlight matching parentheses, etc
opt.showmode = true -- indicate mode in statusline
opt.showtabline = 2 -- 2: always show tabline
opt.smartcase = true -- override ignorecase if search string contains uppercase
opt.smartindent = true -- smart indent when starting new line
opt.smarttab = true -- use shiftwidth instead of tabstop when pressing tab at the start of a line
opt.softtabstop = 2
opt.spell = false -- spellchecking
opt.spelllang = 'en'
opt.spelloptions = 'camel' 
opt.splitbelow = true
opt.splitright = true -- where to put new windows
opt.statusline = '%<%f %h%m%r %= %(%l,%c%V%)' -- format for statusline
opt.tabline = '' -- tabline content
opt.tabstop = 8
opt.termguicolors = true
opt.undofile = true
opt.visualbell = true
opt.wildignore = '__pycache__,*.pyc'
opt.wildmode = 'list:longest'
opt.winblend = 0 -- transparency of floating windows
opt.wrap = true
opt.wrapscan = true -- wrap searches

