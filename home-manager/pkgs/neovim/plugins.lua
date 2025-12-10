-- additional plugins
require("bufferline").setup({
	options = {
		right_mouse_command = false,
		middle_mouse_command = "bdelete! %d",
		indicator = { style = "underline" },
		offsets = { {
			filetype = "NvimTree",
			text = "",
			text_align = "center",
			separator = true,
		} },
		show_buffer_close_icons = true,
		show_close_icon = true,
		show_duplicate_prefix = true,
		show_tab_indicators = true,
		always_show_bufferline = true,
	},
})

local cmp = require("cmp")
local cmp_capabilities = require("cmp_nvim_lsp").default_capabilities()
cmp.setup({
	snippet = {
		expand = function(args)
			vim.snippet.expand(args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert({
		["<Tab>"] = cmp.mapping.confirm({ select = false }), -- accept only explicitly selected item
	}),
	sources = cmp.config.sources({
		{ name = "spell" },
		{ name = "render-markdown" },
		{ name = "nvim_lsp" },
		{ name = "nvim_lsp_signature_help" },
	}, { { name = "buffer" } }),
})

-- require('f-string-toggle').setup({ key_binding = '<leader>fs' })
-- require('flatten').setup({ window = 'alternate', })
require("hardtime").setup({
	max_time = 1000, -- key repeat timer
	max_count = 3, -- number of repeats allowed within max_time
	disable_mouse = false,
	hint = true,
	notification = true,
	allow_different_key = true, -- reset count with different key
	enabled = true,
	restriction_mode = "hint",
	disabled_keys = {
		["<Up>"] = { "n", "x" },
		["<Down>"] = { "n", "x" },
		["<Left>"] = { "n", "x" },
		["<Right>"] = { "n", "x" },
	},
})

require("lspconfig").bashls.setup({
	capabilities = cmp_capabilities,
})
require("lspconfig").nixd.setup({
	capabilities = cmp_capabilities,
	cmd = { "nixd" },
	settings = {
		nixd = {
			nixpkgs = {
				-- expr = "import <nixpkgs> { }",
				expr = '(builtins.getFlake "github:taiwithers/NixOS-Config").inputs.nixpkgs {}',
			},
			formatting = {
				command = { "nixfmt" },
			},
			options = {
				nixos = {
					expr = '(builtins.getFlake "github:taiwithers/NixOS-Config").nixosConfigurations.nixos-main.options',
				},
				home_manager = {
					expr = '(builtins.getFlake "github:taiwithers/NixOS-Config").homeConfigurations.tai.options',
				},
			},
			-- diagnostic = {
			--  suppress = [],
			-- },
		},
	},
})
require("lspconfig").lua_ls.setup({
	capabilities = cmp_capabilities,
})
require("lspconfig").ruff.setup({
	capabilities = cmp_capabilities,
})
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
require("mini.animate").setup({ scroll = { enable = false } })
-- require('mini.clue').setup({
--   triggers = {{ mode = 'i', keys = '<C-x>' }},
--   clues = {require('mini.clue').gen_clues.builtin_completion()}
-- })
require("mini.comment").setup()
-- require('mini.completion').setup({
--   fallback_action = "<C-x><C-i>" -- fallback to keywords
-- })
require("mini.cursorword").setup()
require("mini.icons").setup() -- still in beta and therefore not on stable branch
require("mini.indentscope").setup({ symbol = "│" })
require("mini.indentscope").gen_animation.none()
require("mini.jump").setup() -- multiline fFtT
-- require('mini.move').setup()
require("mini.pairs").setup({
	modes = { insert = true, command = true, terminal = true },
	mappings = {
		-- ['<'] = { action = 'open', pair = '<>', neigh_pattern = '[^\\].' },
		-- ['>'] = { action = 'open', pair = '<>', neigh_pattern = '[^\\].' },
	},
})
-- require("mini.surround").setup()
require("modes").setup({
	line_opacity = 0.2,
	set_cursor = false,
})

require("nvim-navic").setup({
	highlight = true,
	depth_limit = 3,
	click = true,
	lsp = { auto_attach = true },
})

require("noice").setup({
	presets = {
		long_message_to_split = true,
		lsp_doc_border = true,
		command_palette = false,
	},
	-- cmdline and popupmenu together, from noice wiki
	views = {
		cmdline_popup = {
			position = { row = 10, col = "50%" },
			size = { width = 60, height = "auto" },
		},
		popupmenu = { -- this is the completion menu
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
vim.notify = require("notify").setup({
	render = "wrapped-compact",
	stages = "static",
	top_down = false,
})
require("nvim-tree").setup()
require("nvim-treesitter.configs").setup({
	highlight = { enable = true },
	incremental_selection = { enable = true },
	intentation = { enable = true },
})

require("render-markdown").setup({ latex = { enabled = false } })
require("treesitter-context").setup({
	multiline_threshold = 4,
})
-- require('nvim-web-devicons').setup({color_icons=true})

-- require('otter').setup({})
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
require("tabout").setup({
	tabkey = "<Tab>",
	backwards_tabkey = "<S-Tab>",
	act_as_tab = true, -- if not in brackets, move line left/right
	act_as_shift_tab = true,
	default_tab = "<C-t>", -- line move action to take at beginning of a line
	default_shift_tab = "<C-d>",
	completion = true, -- set this if tab is also used for completion selection disables tabout when pum is open(?)
	ignore_beginning = true, -- if at the beginning of brackets, tab out instead of indenting
	tabouts = {
		{ open = "'", close = "'" },
		{ open = '"', close = '"' },
		{ open = "`", close = "`" },
		{ open = "(", close = ")" },
		{ open = "[", close = "]" },
		{ open = "{", close = "}" },
	},
	exclude = {}, -- filetypes
})
require("telescope").setup({
	extensions = {
		["ui-select"] = { require("telescope.themes").get_dropdown({}) },
		file_browser = { follow_symlinks = true },
		fzf = {},
	},
})
require("telescope").load_extension("file_browser")
require("telescope").load_extension("fzf")
require("telescope").load_extension("ui-select")

require("toggleterm").setup({
	start_in_insert = true,
	persist_mode = false,
})
require("which-key").setup({
	preset = "helix",
	win = { no_overlap = false },
	delay = 0,
	expand = 2,
	icons = { keys = {
		M = "ALT ",
		C = "CTRL ",
	} },
	spec = {
		{
			"<leader>",
			function()
				require("which-key").show({ global = true })
			end,
			desc = "Toggle which-key",
			mode = { "n", "v" },
		},
	},
})
require("window-picker").setup({
	hint = "floating-big-letter",
})

-- vimtex
vim.g.vimtex_complete_close_braces = 1
-- vim.g.vimtex_complete_bib.simple = 1 -- only match bibkeys for citations

-- require("legendary").setup({ -- needs to be after which-key
-- 	extensions = { which_key = {
-- 		auto_register = true,
-- 		do_binding = false,
-- 		use_groups = true,
-- 	} },
-- })
