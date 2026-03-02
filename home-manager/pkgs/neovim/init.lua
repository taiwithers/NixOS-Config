local cmd = vim.cmd -- vim api/builtins
local fn = vim.fn -- user-functions https://neovim.io/doc/user/eval.html#user-function
local opt = vim.o -- equivalent to :set
local g = vim.g -- define global variables
local map = vim.keymap.set

-- <leader> key. Defaults to `\`. Some people prefer space.
g.mapleader = " "
-- g.maplocalleader = ' '

require("options")

if io.open("wsl-clipboard") then
	require("wsl-clipboard")
end

-- to add
-- mode-based line highlights? modes-nvim
-- breadcrumbs? nvim-navic
-- markdown rendering
-- window picker
-- multi-file search/replace
-- linting
-- view lsp issues

-- bufferline makes the tab bar
require("bufferline").setup({
	options = {
		right_mouse_command = false,
		middle_mouse_command = "bdelete! %d",
		indicator = { style = "underline" },
		offsets = {
			{
				filetype = "NvimTree",
				text = "",
				text_align = "center",
				separator = true,
			},
		},
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
	extensions = { "fzf" },
	sections = {
		lualine_a = { "mode" },
		lualine_b = { "branch", "diff", "diagnostics" },
		lualine_c = { "filename", "echo nvim_treesitter#statusline(90)" },
		lualine_x = { "encoding", "fileformat", "filetype" },
		lualine_y = { "progress" },
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
vim.keymap.set({ "n", "v" }, "<leader>ff", telescope.find_files, { desc = "Telescope files" })
vim.keymap.set({ "n", "v" }, "<leader>fs", telescope.live_grep, { desc = "Find in folder" })

-- yazi integration
-- local yazi = require("yazi")
vim.keymap.set({ "n", "v" }, "<leader>fe", "<cmd>Yazi<cr>", { desc = "Open yazi" })

-- swap wrapped and non-wrapped line movement
vim.keymap.set({ "n", "v" }, "j", "gj", { desc = "Move down one visual line" })
vim.keymap.set({ "n", "v" }, "gj", "j", { desc = "Move down one real line" })
vim.keymap.set({ "n", "v" }, "k", "gk", { desc = "Move up one visual line" })
vim.keymap.set({ "n", "v" }, "gk", "k", { desc = "Move up one real line" })

-- save with ctrl s
vim.keymap.set({ "n", "i" }, "<C-s>", "<cmd>:w<cr>")

-- comment with ctrl /
vim.keymap.set("n", "<C-_>", "gcc", { desc = "Toggle comment", remap = true })
vim.keymap.set("i", "<C-_>", "<C-o>gcc", { desc = "Toggle comment", remap = true })

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
		isort = {
			append_args = { "--profile", "black" },
		},
	},
	formatters_by_ft = {
		lua = { "stylua" },
		nix = { "nixpkgs_fmt" },
		python = { "isort", "black" },
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
	settings = { Lua = { runtime = { version = "LuaJIT" } } },
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

		-- -- enable completion
		-- if client:supports_method("textDocument/completion") then
		--   vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
		-- end
	end,
})
vim.lsp.enable({ "lua_ls", "nix_ls", "python_ls", "css_ls", "astro_ls", "ts_ls" })

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

		vim.lsp.enable("lua_ls")

		-- treesitter related plugins
		require("nvim-ts-autotag").setup()
	end,
})
