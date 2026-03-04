-- local fn = vim.fn -- user-functions https://neovim.io/doc/user/eval.html#user-function

-- <leader> key. Defaults to `\`. Some people prefer space.
vim.g.mapleader = " "
-- vim.g.maplocalleader = ' '

require("options")

if io.open("wsl-clipboard") then
	require("wsl-clipboard")
end

-- to add
-- breadcrumbs? nvim-navic
-- markdown rendering? - I think this is just a bad default colour scheme
-- window picker
-- linting
-- markdown list continuation and syntax highlighting
-- multi-file search/replace

-- statuscolumn git indicators
require("gitsigns").setup()

-- change the colour of the line highlight based on current mode
require("modes").setup() -- currently not working in lua, but is in nix?

-- highlight text affected by "undo"
require("highlight-undo").setup()

-- turn off search highlight after you perform a non-search action
require("auto-hlsearch").setup()

-- bufferline makes the tab bar
require("bufferline").setup({
	options = {
		right_mouse_command = false,
		middle_mouse_command = "bdelete! %d",
		indicator = { style = "underline" },
		show_buffer_close_icons = true,
		show_close_icon = true,
		show_duplicate_prefix = true,
		show_tab_indicators = true,
		always_show_bufferline = true,
	},
})

-- lualine does the status bar at the bottom
require("lualine").setup({
	options = {
		theme = "moonfly",
		component_separators = { left = "", right = "" },
		section_separators = { left = "", right = "" },
		global_status = true,
	},
	extensions = { "fzf", "quickfix" }, -- understand additional filetypes
	sections = {
		lualine_a = { "mode" },
		lualine_b = { "branch", "diff", "diagnostics" },
		lualine_c = { "filename" },
		lualine_x = {},
		lualine_y = { "lsp_status" },
		lualine_z = { "location" },
	},
})

-- autopairing
require("mini.pairs").setup()

-- tpope-style surround
require("nvim-surround").setup()

-- filetree, neo-tree looks maybe nicer?
-- require("nvim-tree").setup()

-- style the command line and notifications?
require("noice").setup({
	presets = {
		long_message_to_split = true,
		lsp_doc_border = true,
		command_palette = false,
	},
	-- cmdline and popupmenu together, lower than `command_palette = true` from noice wiki
	views = {
		cmdline_popup = {
			position = { row = 10, col = "50%" },
			size = { width = 60, height = "auto" },
		},
		popupmenu = { -- this is the cmd completion menu
			relative = "editor",
			position = { row = 13, col = "50%" }, -- row is cmdline_popup row + 3
			size = { width = 60, height = 5 },
			border = { style = "rounded", padding = { 0, 1 } },
			win_options = { winhighlight = { Normal = "Normal", FloatBorder = "DiagnosticInfo" } },
		},
	},
	lsp = {
		override = {
			["vim.lsp.util.convert_input_to_markdown_lines"] = true,
			["vim.lsp.util.stylize_markdown"] = true,
			["cmp.entry.get_documentation"] = true,
		},
	},
})

-- whichkey
require("which-key").setup({ preset = "helix" })

-- telescope, automatically loads noice extension
require("telescope").load_extension("fzf")
local telescope = require("telescope.builtin")

local function is_git_repo()
  vim.fn.system("git rev-parse --is-inside-work-tree")
  return vim.v.shell_error == 0
end
local function get_git_root()
  local dot_git_path = vim.fn.finddir(".git", ".;")
  return vim.fn.fnamemodify(dot_git_path, ":h")
end
function vim.find_files_from_project_git_root()
  local opts = {}
  if is_git_repo() then
    opts = { cwd = get_git_root() }
  end
  require("telescope.builtin").find_files(opts)
end
function live_grep_from_project_git_root()
  local opts = {}
  if is_git_repo() then
    opts = { cwd = get_git_root() }
  end
  require("telescope.builtin").live_grep(opts)
end
vim.keymap.set({ "n", "v" }, "<leader>ff", vim.find_files_from_project_git_root, { desc = "Telescope files" })
vim.keymap.set({ "n", "v" }, "<leader>fb", telescope.buffers, { desc = "Open buffers" })
vim.keymap.set({ "n", "v" }, "<leader>fs", live_grep_from_project_git_root, { desc = "Find in folder" })
vim.keymap.set({ "n", "v", "i" }, "<F12>", telescope.lsp_definitions, { desc = "Go to definition" })

-- yank ring (clipboard history)
local yanky_mapping = require("yanky.telescope.mapping")
local yanky_telescope_mappings = {
  default = yanky_mapping.put("p"),
  i = {
    ["<C-l>"] = yanky_mapping.put("p"),
    ["<C-h>"] = yanky_mapping.put("P"),
    ["<C-d>"] = yanky_mapping.delete(),
  },
  n = {
    ["p"] = yanky_mapping.put("p"),
    ["P"] = yanky_mapping.put("P"),
    ["d"] = yanky_mapping.delete(),
  },
}
require("yanky").setup({ -- adds highlight on yank (can be done natively w/ autcmds) and on put
  ring = { permanent_wrapper = require("yanky.wrappers").remove_carriage_return }, -- wsl ^M fix
  picker = { telescope = { use_default_mappings = false, mappings = yanky_telescope_mappings } },
})
vim.keymap.set({ "n", "x" }, "p", "<Plug>(YankyPutAfter)", { desc = "Put after cursor" })
vim.keymap.set({ "n", "x" }, "P", "<Plug>(YankyPutBefore)", { desc = "Put before cursor" })
vim.keymap.set(
  { "n", "x" },
  "<leader>p",
  "<cmd>Telescope yank_history theme=cursor<cr>",
  { desc = "Open yank history" }
)
-- vim.keymap.set("n", "<c-p>", "<Plug>(YankyPreviousEntry)") -- change the pasted text after pasting
-- vim.keymap.set("n", "<c-n>", "<Plug>(YankyNextEntry)") -- change the pasted text after pasting

-- terminals
-- vim.keymap.set({ "n" }, "<leader>tj", "<cmd>:horizontal terminal<cr><cmd>:startinsert<cr>")
vim.keymap.set({ "t" }, "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
require("toggleterm").setup()
local toggleterminal = require("toggleterm.terminal").Terminal
local shell = toggleterminal:new({ cmd = vim.o.shell })
local lazygit = toggleterminal:new({ cmd = "lazygit", dir = "git_dir", direction = "float", close_on_exit = true })
-- vim.keymap.set({ "n" }, "<leader>tt", "<cmd>:ToggleTerm<cr>", { desc = "Open terminal" })
vim.keymap.set({ "n" }, "<leader>tt", function()
	shell:toggle()
end, { desc = "Open terminal" })
vim.keymap.set({ "n" }, "<leader>lg", function()
	lazygit:toggle()
end, { desc = "Open lazygit" })

-- yazi integration
-- local yazi = require("yazi")
vim.keymap.set({ "n", "v" }, "<leader>yy", "<cmd>Yazi<cr>", { desc = "Open yazi" })

-- swap wrapped and non-wrapped line movement
vim.keymap.set({ "n", "v" }, "j", "gj", { desc = "Move down one visual line" })
vim.keymap.set({ "n", "v" }, "gj", "j", { desc = "Move down one real line" })
vim.keymap.set({ "n", "v" }, "k", "gk", { desc = "Move up one visual line" })
vim.keymap.set({ "n", "v" }, "gk", "k", { desc = "Move up one real line" })

-- save with ctrl s
vim.keymap.set({ "n", "i" }, "<C-s>", "<cmd>:w<cr>")

-- comment with ctrl /
local toggle_comment = require("Comment.api").toggle.linewise.current
vim.keymap.set("n", "<C-_>", toggle_comment, { desc = "Toggle comment", remap = true })
vim.keymap.set("i", "<C-_>", toggle_comment, { desc = "Toggle comment" })

-- "tab" between buffers
vim.keymap.set({ "n", "i" }, "<leader><TAB>", "<cmd>:bn<cr>", { desc = "Go to next buffer" })
vim.keymap.set({ "n", "i" }, "<leader><S-TAB>", "<cmd>:bp<cr>", { desc = "Go to previous buffer" })

-- completion
local cmp = require("cmp")
local completion_mapping = {
	["<C-Space>"] = cmp.mapping.complete(), -- open menu if not already there
	["<CR>"] = cmp.mapping.confirm({ select = true }), -- accept first option/selected option
	["<Down>"] = cmp.mapping.select_next_item(),
	["<Up>"] = cmp.mapping.select_prev_item(),
	-- also bound by default (insert mode mapping), wrap the {} in cmp.mapping.preset.insert() to include these:
	-- <C-n>: select next item, or open completion menu
	-- <C-p>: select prev item, or open completion menu
	-- <C-y>: accept selected option
	-- <C-e>: close menu
}
cmp.setup({
	sources = cmp.config.sources({ { name = "nvim_lsp" } }),
	mapping = completion_mapping,
})
cmp.setup.cmdline(":", {
	-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
	mapping = completion_mapping,
	sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline" } }),
	matching = { disallow_symbol_nonprefix_matching = false },
})
cmp.setup.cmdline({ "/", "?" }, {
	-- Use buffer source for '/' and '?' searches
	mapping = completion_mapping,
	sources = { { name = "buffer" } },
})

-- formatting
local conform = require("conform")
conform.setup({
  formatters = {
    isort = { append_args = { "--profile", "black" } },
    stylua = { append_args = { "--indent-type", "Spaces", "--indent-width", "2" } },
  },
  formatters_by_ft = {
    lua = { "stylua" },
    just = { "just" },
    json = { "fixjson" },
    docker = { "dockerfmt" },
    sh = { "shfmt" },
    yaml = { "yamlfmt" },
    nix = { "nixpkgs_fmt" },
    python = { "isort", "black" },
    markdown = { "prettierd", "prettier", stop_after_first = true },
    javascript = { "prettierd", "prettier", stop_after_first = true },
    typescript = { "prettierd", "prettier", stop_after_first = true },
    typescriptreact = { "prettierd", "prettier", stop_after_first = true },
    html = { "prettierd", "prettier", stop_after_first = true },
    scss = { "prettierd", "prettier", stop_after_first = true },
  },
  format_on_save = {
    lsp_format = "fallback",
    timeout_ms = 500,
  },
})

-- lsp
local capabilities = require("cmp_nvim_lsp").default_capabilities() -- from nvim-cmp
capabilities.textDocument.completion.completionItem.snippetSupport = true

vim.lsp.config["lua_ls"] = {
	cmd = { "lua-language-server" },
	filetypes = { "lua" },
	root_markers = { { ".luarc.json", ".luarc.jsonc" }, ".git" },
	settings = {
		Lua = {
			runtime = { version = "LuaJIT" },
			diagnostics = { globals = { "vim" } }, -- ignore undefined `vim`
		},
	},
	capabilities = capabilities,
}
vim.lsp.config["bash_ls"] = {
	cmd = { "bash-language-server" },
	filetypes = { "sh" },
	capabilities = capabilities,
}
vim.lsp.config["nix_ls"] = {
	cmd = { "nixd" },
	filetypes = { "nix" },
	root_markers = { "flake.nix", ".git" },
	capabilities = capabilities,
}
vim.lsp.config["python_ls"] = {
	cmd = { "ruff" },
	filetypes = { "py" },
	capabilities = capabilities,
}
vim.lsp.config["css_ls"] = {
	capabilities = capabilities,
	filetypes = { "css", "scss" },
	cmd = { "vscode-css-language-server", "--stdio" },
	settings = {
		css = { validate = true },
		scss = { validate = true },
	},
}
vim.lsp.config["astro_ls"] = {
	cmd = { "astro-ls", "--stdio" },
	capabilities = capabilities,
	filetypes = { "astro" },
	root_markers = { "package.json", "tsconfig.json", ".git" },
	init_options = { typescript = {} },
	-- before_init = function(_, config)
	-- if config.init_options and config.init_options.typescript and not config.init_options.typescript.tsdk then
	-- config.init_options.typescript.tsdk =
}
vim.lsp.config["ts_ls"] = {
	cmd = { "typescript-language-server", "--stdio" },
	filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
	init_options = { hostInfo = "neovim" },
	root_markers = { "package.json", "tsconfig.json", ".git" },
}

-- use the noice style for generic notifications?
vim.notify = require("notify").setup({
	render = "wrapped-compact",
	stages = "static",
	top_down = false,
})

-- https://github.com/ntk148v/neovim-config/blob/master/lua/autocmds.lua
local autocmd = vim.api.nvim_create_autocmd -- Create autocommand

-- enable supported lsp functionality
autocmd("LspAttach", {
	callback = function(args)
		local client = assert(vim.lsp.get_client_by_id(args.data.client_id))

		-- view diagnostic for current line
		vim.keymap.set(
			{ "n" },
			"<leader>d",
			"<cmd>lua vim.diagnostic.open_float()<cr>",
			{ desc = "View LSP diagnostic for current line" }
		)
	end,
})

local function start_lsp()
	vim.lsp.enable({ "lua_ls", "nix_ls", "python_ls", "css_ls", "astro_ls", "ts_ls" })
end

start_lsp()
vim.keymap.set({ "n" }, "<leader>ls", start_lsp, { desc = "Start LSP servers" })

-- treesitter stuff
autocmd("FileType", {
	pattern = { "lua", "nix", "python", "bash", "astro" },
	callback = function()
		-- syntax highlighting
		vim.treesitter.start()
		-- folds
		vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
		vim.wo.foldmethod = expr
		-- indentation (from nvim-treesitter plugin)
		vim.bo.indentexpr = "v:lua.require('nvim-treesitter').indentexpr()"

		-- treesitter related plugins
		require("nvim-ts-autotag").setup()
	end,
})
