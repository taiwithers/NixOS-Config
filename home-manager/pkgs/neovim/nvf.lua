-- SECTION: globalsScript
vim.g.editorconfig = true
vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- SECTION: basic
vim.cmd("syntax on")
vim.o.smartcase = false
vim.o.ignorecase = false

-- SECTION: theme
require("rose-pine").setup({
	dark_variant = "main", -- main, moon, or dawn
	dim_inactive_windows = false,
	extend_background_behind_borders = true,

	enable = {
		terminal = true,
		migrations = true,
	},

	styles = {
		bold = false,
		italic = false, -- I would like to add more options for this
		transparency = false,
	},
})
vim.cmd("colorscheme rose-pine")

-- SECTION: optionsScript
vim.o.autoindent = true
vim.o.backup = true
vim.o.cmdheight = 1
vim.o.cursorlineopt = "line"
vim.o.encoding = "utf-8"
vim.o.errorbells = false
vim.o.expandtab = true
vim.o.hidden = true
vim.o.mouse = "nvi"
vim.o.number = true
vim.o.relativenumber = true
vim.o.shiftwidth = 8
vim.o.signcolumn = "yes"
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.swapfile = true
vim.o.tabstop = 8
vim.o.termguicolors = true
vim.o.tm = 500
vim.o.updatetime = 300
vim.o.visualbell = false
vim.o.wrap = true
vim.o.writebackup = true

-- SECTION: lazyConfigs
require("lz.n").load({
	{
		"cheatsheet-nvim",
		["after"] = function()
			require("cheatsheet").setup({})
		end,
		["before"] = function()
			require("lz.n").trigger_load("telescope")
		end,
		["cmd"] = { "Cheatsheet", "CheatsheetEdit" },
		["lazy"] = false,
	},

	{
		"cmp-buffer",
		["after"] = function()
			local path = vim.fn.globpath(vim.o.packpath, "pack/*/opt/cmp-buffer")
			require("rtp_nvim").source_after_plugin_dir(path)
		end,
		["lazy"] = true,
	},

	{
		"cmp-nvim-lsp",
		["after"] = function()
			local path = vim.fn.globpath(vim.o.packpath, "pack/*/opt/cmp-nvim-lsp")
			require("rtp_nvim").source_after_plugin_dir(path)
		end,
		["lazy"] = true,
	},
	{
		"cmp-path",
		["after"] = function()
			local path = vim.fn.globpath(vim.o.packpath, "pack/*/opt/cmp-path")
			require("rtp_nvim").source_after_plugin_dir(path)
		end,
		["lazy"] = true,
	},
	{
		"cmp-treesitter",
		["after"] = function()
			local path = vim.fn.globpath(vim.o.packpath, "pack/*/opt/cmp-treesitter")
			require("rtp_nvim").source_after_plugin_dir(path)
		end,
		["lazy"] = true,
	},
	{
		"comment-nvim",
		["after"] = function()
			require("Comment").setup({ ["mappings"] = { ["basic"] = false, ["extra"] = false } })
		end,
		["keys"] = {
			{
				"gc",
				"<Plug>(comment_toggle_linewise)",
				["desc"] = "Toggle line comment",
				["expr"] = false,
				["mode"] = "n",
				["noremap"] = true,
				["nowait"] = false,
				["script"] = false,
				["silent"] = true,
				["unique"] = false,
			},
			{
				"gb",
				"<Plug>(comment_toggle_blockwise)",
				["desc"] = "Toggle block comment",
				["expr"] = false,
				["mode"] = "n",
				["noremap"] = true,
				["nowait"] = false,
				["script"] = false,
				["silent"] = true,
				["unique"] = false,
			},
			{
				"gcc",
				function()
					return vim.api.nvim_get_vvar("count") == 0 and "<Plug>(comment_toggle_linewise_current)"
						or "<Plug>(comment_toggle_linewise_count)"
				end,
				["desc"] = "Toggle current line comment",
				["expr"] = true,
				["mode"] = "n",
				["noremap"] = true,
				["nowait"] = false,
				["script"] = false,
				["silent"] = true,
				["unique"] = false,
			},
			{
				"gbc",
				function()
					return vim.api.nvim_get_vvar("count") == 0 and "<Plug>(comment_toggle_blockwise_current)"
						or "<Plug>(comment_toggle_blockwise_count)"
				end,
				["desc"] = "Toggle current block comment",
				["expr"] = true,
				["mode"] = { "n" },
				["noremap"] = true,
				["nowait"] = false,
				["script"] = false,
				["silent"] = true,
				["unique"] = false,
			},
			{
				"gc",
				"<Plug>(comment_toggle_linewise_visual)",
				["desc"] = "Toggle selected comment",
				["expr"] = false,
				["mode"] = "x",
				["noremap"] = true,
				["nowait"] = false,
				["script"] = false,
				["silent"] = true,
				["unique"] = false,
			},
			{
				"gb",
				"<Plug>(comment_toggle_blockwise_visual)",
				["desc"] = "Toggle selected block",
				["expr"] = false,
				["mode"] = "x",
				["noremap"] = true,
				["nowait"] = false,
				["script"] = false,
				["silent"] = true,
				["unique"] = false,
			},
		},
		["lazy"] = false,
	},
	{
		"nvim-cmp",
		["after"] = function()
			local cmp = require("cmp")

			local kinds = require("cmp.types").lsp.CompletionItemKind
			local deprio = function(kind)
				return function(e1, e2)
					if e1:get_kind() == kind then
						return false
					end
					if e2:get_kind() == kind then
						return true
					end
					return nil
				end
			end

			cmp.setup({
				["completion"] = { ["completeopt"] = "menu,menuone,noinsert" },
				["formatting"] = {
					["format"] = function(entry, vim_item)
						vim_item.menu = ({
							["buffer"] = "[Buffer]",
							["nvim_lsp"] = "[LSP]",
							["path"] = "[Path]",
							["treesitter"] = "[Treesitter]",
						})[entry.source.name]
						return vim_item
					end,
				},
				["mapping"] = {
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-d>"] = cmp.mapping.scroll_docs(-4),
					["<C-e>"] = cmp.mapping.abort(),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<CR>"] = cmp.mapping.confirm({ select = true }),
					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						else
							fallback()
						end
					end),
					["<Tab>"] = cmp.mapping(function(fallback)
						local has_words_before = function()
							local line, col = unpack(vim.api.nvim_win_get_cursor(0))
							return col ~= 0
								and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s")
									== nil
						end

						if cmp.visible() then
							cmp.select_next_item()
						elseif has_words_before() then
							cmp.complete()
						else
							fallback()
						end
					end),
				},
				["sorting"] = {
					["comparators"] = {
						deprio(kinds.Text),
						deprio(kinds.Snippet),
						cmp.config.compare.offset,
						cmp.config.compare.exact,
						cmp.config.compare.score,
						cmp.config.compare.kind,
						cmp.config.compare.length,
						cmp.config.compare.sort_text,
					},
				},
				["sources"] = {
					{ ["name"] = "buffer" },
					{ ["name"] = "nvim-cmp" },
					{ ["name"] = "nvim_lsp" },
					{ ["name"] = "path" },
					{ ["name"] = "treesitter" },
				},
				["window"] = {
					["completion"] = { ["border"] = "rounded" },
					["documentation"] = { ["border"] = "rounded" },
				},
			})

			require("lz.n").trigger_load("cmp-buffer")
			require("lz.n").trigger_load("cmp-path")
			require("lz.n").trigger_load("cmp-treesitter")
			require("lz.n").trigger_load("cmp-nvim-lsp")
		end,
		["event"] = { "InsertEnter", "CmdlineEnter" },
		["lazy"] = false,
	},
	{
		"nvim-surround",
		["after"] = function()
			require("nvim-surround").setup({
				["keymaps"] = {
					["change"] = "gzr",
					["change_line"] = "gZR",
					["delete"] = "gzd",
					["insert"] = "<C-g>z",
					["insert_line"] = "<C-g>Z",
					["normal"] = "gz",
					["normal_cur"] = "gZ",
					["normal_cur_line"] = "gZZ",
					["normal_line"] = "gzz",
					["visual"] = "gz",
					["visual_line"] = "gZ",
				},
			})
		end,
		["keys"] = {
			{
				"<C-g>z",
				["expr"] = false,
				["mode"] = "i",
				["noremap"] = true,
				["nowait"] = false,
				["script"] = false,
				["silent"] = true,
				["unique"] = false,
			},
			{
				"<C-g>Z",
				["expr"] = false,
				["mode"] = "i",
				["noremap"] = true,
				["nowait"] = false,
				["script"] = false,
				["silent"] = true,
				["unique"] = false,
			},
			{
				"gz",
				["expr"] = false,
				["mode"] = "x",
				["noremap"] = true,
				["nowait"] = false,
				["script"] = false,
				["silent"] = true,
				["unique"] = false,
			},
			{
				"gZ",
				["expr"] = false,
				["mode"] = "x",
				["noremap"] = true,
				["nowait"] = false,
				["script"] = false,
				["silent"] = true,
				["unique"] = false,
			},
			{
				"gz",
				["expr"] = false,
				["mode"] = "n",
				["noremap"] = true,
				["nowait"] = false,
				["script"] = false,
				["silent"] = true,
				["unique"] = false,
			},
			{
				"gZ",
				["expr"] = false,
				["mode"] = "n",
				["noremap"] = true,
				["nowait"] = false,
				["script"] = false,
				["silent"] = true,
				["unique"] = false,
			},
			{
				"gzz",
				["expr"] = false,
				["mode"] = "n",
				["noremap"] = true,
				["nowait"] = false,
				["script"] = false,
				["silent"] = true,
				["unique"] = false,
			},
			{
				"gZZ",
				["expr"] = false,
				["mode"] = "n",
				["noremap"] = true,
				["nowait"] = false,
				["script"] = false,
				["silent"] = true,
				["unique"] = false,
			},
			{
				"gzd",
				["expr"] = false,
				["mode"] = "n",
				["noremap"] = true,
				["nowait"] = false,
				["script"] = false,
				["silent"] = true,
				["unique"] = false,
			},
			{
				"gzr",
				["expr"] = false,
				["mode"] = "n",
				["noremap"] = true,
				["nowait"] = false,
				["script"] = false,
				["silent"] = true,
				["unique"] = false,
			},
			{
				"gZR",
				["expr"] = false,
				["mode"] = "n",
				["noremap"] = true,
				["nowait"] = false,
				["script"] = false,
				["silent"] = true,
				["unique"] = false,
			},
		},
		["lazy"] = false,
	},
	{
		"nvim-tree-lua",
		["after"] = function()
			require("nvim-tree").setup({
				["actions"] = {
					["change_dir"] = { ["enable"] = true, ["global"] = false, ["restrict_above_cwd"] = false },
					["expand_all"] = {
						["exclude"] = { ".git", "target", "build", "result" },
						["max_folder_discovery"] = 300,
					},
					["file_popup"] = {
						["open_win_config"] = {
							["border"] = "rounded",
							["col"] = 1,
							["relative"] = "cursor",
							["row"] = 1,
							["style"] = "minimal",
						},
					},
					["open_file"] = {
						["eject"] = false,
						["quit_on_open"] = false,
						["resize_window"] = false,
						["window_picker"] = {
							["chars"] = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
							["enable"] = false,
							["exclude"] = {
								["buftype"] = { "nofile", "terminal", "help" },
								["filetype"] = { "notify", "packer", "qf", "diff", "fugitive", "fugitiveblame" },
							},
							["picker"] = "default",
						},
					},
					["remove_file"] = { ["close_window"] = true },
					["use_system_clipboard"] = true,
				},
				["auto_reload_on_write"] = true,
				["diagnostics"] = {
					["debounce_delay"] = 50,
					["enable"] = false,
					["icons"] = { ["error"] = "", ["hint"] = "", ["info"] = "", ["warning"] = "" },
					["severity"] = {
						["max"] = vim.diagnostic.severity.ERROR,
						["min"] = vim.diagnostic.severity.HINT,
					},
					["show_on_dirs"] = false,
					["show_on_open_dirs"] = true,
				},
				["disable_netrw"] = false,
				["filesystem_watchers"] = { ["debounce_delay"] = 50, ["enable"] = true, ["ignore_dirs"] = {} },
				["filters"] = {
					["dotfiles"] = false,
					["exclude"] = {},
					["git_clean"] = false,
					["git_ignored"] = false,
					["no_buffer"] = false,
				},
				["git"] = {
					["disable_for_dirs"] = {},
					["enable"] = false,
					["show_on_dirs"] = true,
					["show_on_open_dirs"] = true,
					["timeout"] = 400,
				},
				["hijack_cursor"] = false,
				["hijack_directories"] = { ["auto_open"] = false, ["enable"] = true },
				["hijack_netrw"] = true,
				["hijack_unnamed_buffer_when_opening"] = false,
				["live_filter"] = { ["always_show_folders"] = true, ["prefix"] = "[FILTER]: " },
				["modified"] = { ["enable"] = false, ["show_on_dirs"] = true, ["show_on_open_dirs"] = true },
				["notify"] = { ["absolute_path"] = true, ["threshold"] = vim.log.levels.INFO },
				["prefer_startup_root"] = false,
				["reload_on_bufenter"] = false,
				["renderer"] = {
					["add_trailing"] = false,
					["full_name"] = false,
					["group_empty"] = false,
					["highlight_git"] = false,
					["highlight_modified"] = "none",
					["highlight_opened_files"] = "none",
					["icons"] = {
						["git_placement"] = "before",
						["glyphs"] = {
							["default"] = "",
							["folder"] = {
								["arrow_closed"] = "",
								["arrow_open"] = "",
								["default"] = "",
								["empty"] = "",
								["empty_open"] = "",
								["open"] = "",
								["symlink"] = "",
								["symlink_open"] = "",
							},
							["git"] = {
								["deleted"] = "",
								["ignored"] = "◌",
								["renamed"] = "➜",
								["staged"] = "✓",
								["unmerged"] = "",
								["unstaged"] = "✗",
								["untracked"] = "★",
							},
							["modified"] = "",
							["symlink"] = "",
						},
						["modified_placement"] = "after",
						["padding"] = " ",
						["show"] = {
							["file"] = true,
							["folder"] = true,
							["folder_arrow"] = true,
							["git"] = false,
							["modified"] = true,
						},
						["symlink_arrow"] = " ➛ ",
						["webdev_colors"] = true,
					},
					["indent_markers"] = {
						["enable"] = false,
						["icons"] = {
							["bottom"] = "─",
							["corner"] = "└",
							["edge"] = "│",
							["item"] = "│",
							["none"] = "",
						},
						["inline_arrows"] = true,
					},
					["indent_width"] = 2,
					["root_folder_label"] = false,
					["special_files"] = {
						"Cargo.toml",
						"README.md",
						"readme.md",
						"Makefile",
						"MAKEFILE",
						"flake.nix",
					},
					["symlink_destination"] = true,
				},
				["respect_buf_cwd"] = false,
				["root_dirs"] = {},
				["select_prompts"] = false,
				["sort"] = { ["folders_first"] = true, ["sorter"] = "name" },
				["sync_root_with_cwd"] = false,
				["system_open"] = {
					["args"] = {},
					["cmd"] = "/nix/store/9v7x5vabddvggsmy4gyim551gww2hsan-xdg-utils-1.2.1/bin/xdg-open",
				},
				["tab"] = { ["sync"] = { ["close"] = false, ["ignore"] = {}, ["open"] = false } },
				["trash"] = {
					["cmd"] = "/nix/store/dklvr5fs30r3jlkyjalb2ax5dw3vipha-glib-2.82.1-bin/bin/gio trash",
				},
				["ui"] = { ["confirm"] = { ["remove"] = true, ["trash"] = true } },
				["update_focused_file"] = { ["enable"] = false, ["ignore_list"] = {}, ["update_root"] = false },
				["view"] = {
					["centralize_selection"] = false,
					["cursorline"] = true,
					["debounce_delay"] = 15,
					["float"] = {
						["enable"] = false,
						["open_win_config"] = {
							["border"] = "rounded",
							["col"] = 1,
							["height"] = 30,
							["relative"] = "editor",
							["row"] = 1,
							["width"] = 30,
						},
						["quit_on_focus_loss"] = true,
					},
					["number"] = false,
					["preserve_window_proportions"] = false,
					["relativenumber"] = false,
					["side"] = "left",
					["signcolumn"] = "yes",
					["width"] = 30,
				},
			})
		end,
		["cmd"] = {
			"NvimTreeClipboard",
			"NvimTreeClose",
			"NvimTreeCollapse",
			"NvimTreeCollapseKeepBuffers",
			"NvimTreeFindFile",
			"NvimTreeFindFileToggle",
			"NvimTreeFocus",
			"NvimTreeHiTest",
			"NvimTreeOpen",
			"NvimTreeRefresh",
			"NvimTreeResize",
			"NvimTreeToggle",
		},
		["keys"] = {
			{
				"<leader>t",
				":NvimTreeToggle<cr>",
				["desc"] = "Toggle NvimTree",
				["expr"] = false,
				["mode"] = "n",
				["noremap"] = true,
				["nowait"] = false,
				["script"] = false,
				["silent"] = true,
				["unique"] = false,
			},
			{
				"<leader>tr",
				":NvimTreeRefresh<cr>",
				["desc"] = "Refresh NvimTree",
				["expr"] = false,
				["mode"] = "n",
				["noremap"] = true,
				["nowait"] = false,
				["script"] = false,
				["silent"] = true,
				["unique"] = false,
			},
			{
				"<leader>tg",
				":NvimTreeFindFile<cr>",
				["desc"] = "Find file in NvimTree",
				["expr"] = false,
				["mode"] = "n",
				["noremap"] = true,
				["nowait"] = false,
				["script"] = false,
				["silent"] = true,
				["unique"] = false,
			},
			{
				"<leader>tf",
				":NvimTreeFocus<cr>",
				["desc"] = "Focus NvimTree",
				["expr"] = false,
				["mode"] = "n",
				["noremap"] = true,
				["nowait"] = false,
				["script"] = false,
				["silent"] = true,
				["unique"] = false,
			},
		},
		["lazy"] = false,
	},
	{
		"telescope",
		["after"] = function()
			require("telescope").setup({
				["defaults"] = {
					["color_devicons"] = true,
					["entry_prefix"] = "  ",
					["file_ignore_patterns"] = {
						"node_modules",
						".git/",
						"dist/",
						"build/",
						"target/",
						"result/",
					},
					["initial_mode"] = "insert",
					["layout_config"] = {
						["height"] = 0.800000,
						["horizontal"] = {
							["preview_width"] = 0.550000,
							["prompt_position"] = "top",
							["results_width"] = 0.800000,
						},
						["preview_cutoff"] = 120,
						["vertical"] = { ["mirror"] = false },
						["width"] = 0.800000,
					},
					["layout_strategy"] = "horizontal",
					["path_display"] = { "absolute" },
					["pickers"] = {
						["find_command"] = { "/nix/store/6ycjl52s737iyhqsarah44q9109xdfgc-fd-10.2.0/bin/fd" },
					},
					["prompt_prefix"] = "     ",
					["selection_caret"] = "  ",
					["selection_strategy"] = "reset",
					["set_env"] = { ["COLORTERM"] = "truecolor" },
					["sorting_strategy"] = "ascending",
					["vimgrep_arguments"] = {
						"/nix/store/4rhrla8ldkgjrhx3hgpfa2vhp7j034qc-ripgrep-14.1.1/bin/rg",
						"--color=never",
						"--no-heading",
						"--with-filename",
						"--line-number",
						"--column",
						"--smart-case",
						"--hidden",
						"--no-ignore",
					},
					["winblend"] = 0,
				},
			})
			local telescope = require("telescope")
			telescope.load_extension("noice")
			telescope.load_extension("notify")
		end,
		["before"] = function()
			vim.g.loaded_telescope = nil
		end,
		["cmd"] = { "Telescope" },
		["keys"] = {
			{
				"<leader>ff",
				"<cmd>Telescope find_files<CR>",
				["desc"] = "Find files [Telescope]",
				["expr"] = false,
				["mode"] = "n",
				["noremap"] = true,
				["nowait"] = false,
				["script"] = false,
				["silent"] = true,
				["unique"] = false,
			},
			{
				"<leader>fg",
				"<cmd>Telescope live_grep<CR>",
				["desc"] = "Live grep [Telescope]",
				["expr"] = false,
				["mode"] = "n",
				["noremap"] = true,
				["nowait"] = false,
				["script"] = false,
				["silent"] = true,
				["unique"] = false,
			},
			{
				"<leader>fb",
				"<cmd>Telescope buffers<CR>",
				["desc"] = "Buffers [Telescope]",
				["expr"] = false,
				["mode"] = "n",
				["noremap"] = true,
				["nowait"] = false,
				["script"] = false,
				["silent"] = true,
				["unique"] = false,
			},
			{
				"<leader>fh",
				"<cmd>Telescope help_tags<CR>",
				["desc"] = "Help tags [Telescope]",
				["expr"] = false,
				["mode"] = "n",
				["noremap"] = true,
				["nowait"] = false,
				["script"] = false,
				["silent"] = true,
				["unique"] = false,
			},
			{
				"<leader>ft",
				"<cmd>Telescope<CR>",
				["desc"] = "Open [Telescope]",
				["expr"] = false,
				["mode"] = "n",
				["noremap"] = true,
				["nowait"] = false,
				["script"] = false,
				["silent"] = true,
				["unique"] = false,
			},
			{
				"<leader>fr",
				"<cmd>Telescope resume<CR>",
				["desc"] = "Resume (previous search) [Telescope]",
				["expr"] = false,
				["mode"] = "n",
				["noremap"] = true,
				["nowait"] = false,
				["script"] = false,
				["silent"] = true,
				["unique"] = false,
			},
			{
				"<leader>fvcw",
				"<cmd>Telescope git_commits<CR>",
				["desc"] = "Git commits [Telescope]",
				["expr"] = false,
				["mode"] = "n",
				["noremap"] = true,
				["nowait"] = false,
				["script"] = false,
				["silent"] = true,
				["unique"] = false,
			},
			{
				"<leader>fvcb",
				"<cmd>Telescope git_bcommits<CR>",
				["desc"] = "Git buffer commits [Telescope]",
				["expr"] = false,
				["mode"] = "n",
				["noremap"] = true,
				["nowait"] = false,
				["script"] = false,
				["silent"] = true,
				["unique"] = false,
			},
			{
				"<leader>fvb",
				"<cmd>Telescope git_branches<CR>",
				["desc"] = "Git branches [Telescope]",
				["expr"] = false,
				["mode"] = "n",
				["noremap"] = true,
				["nowait"] = false,
				["script"] = false,
				["silent"] = true,
				["unique"] = false,
			},
			{
				"<leader>fvs",
				"<cmd>Telescope git_status<CR>",
				["desc"] = "Git status [Telescope]",
				["expr"] = false,
				["mode"] = "n",
				["noremap"] = true,
				["nowait"] = false,
				["script"] = false,
				["silent"] = true,
				["unique"] = false,
			},
			{
				"<leader>fvx",
				"<cmd>Telescope git_stash<CR>",
				["desc"] = "Git stash [Telescope]",
				["expr"] = false,
				["mode"] = "n",
				["noremap"] = true,
				["nowait"] = false,
				["script"] = false,
				["silent"] = true,
				["unique"] = false,
			},
			{
				"<leader>flsb",
				"<cmd>Telescope lsp_document_symbols<CR>",
				["desc"] = "LSP Document Symbols [Telescope]",
				["expr"] = false,
				["mode"] = "n",
				["noremap"] = true,
				["nowait"] = false,
				["script"] = false,
				["silent"] = true,
				["unique"] = false,
			},
			{
				"<leader>flsw",
				"<cmd>Telescope lsp_workspace_symbols<CR>",
				["desc"] = "LSP Workspace Symbols [Telescope]",
				["expr"] = false,
				["mode"] = "n",
				["noremap"] = true,
				["nowait"] = false,
				["script"] = false,
				["silent"] = true,
				["unique"] = false,
			},
			{
				"<leader>flr",
				"<cmd>Telescope lsp_references<CR>",
				["desc"] = "LSP References [Telescope]",
				["expr"] = false,
				["mode"] = "n",
				["noremap"] = true,
				["nowait"] = false,
				["script"] = false,
				["silent"] = true,
				["unique"] = false,
			},
			{
				"<leader>fli",
				"<cmd>Telescope lsp_implementations<CR>",
				["desc"] = "LSP Implementations [Telescope]",
				["expr"] = false,
				["mode"] = "n",
				["noremap"] = true,
				["nowait"] = false,
				["script"] = false,
				["silent"] = true,
				["unique"] = false,
			},
			{
				"<leader>flD",
				"<cmd>Telescope lsp_definitions<CR>",
				["desc"] = "LSP Definitions [Telescope]",
				["expr"] = false,
				["mode"] = "n",
				["noremap"] = true,
				["nowait"] = false,
				["script"] = false,
				["silent"] = true,
				["unique"] = false,
			},
			{
				"<leader>flt",
				"<cmd>Telescope lsp_type_definitions<CR>",
				["desc"] = "LSP Type Definitions [Telescope]",
				["expr"] = false,
				["mode"] = "n",
				["noremap"] = true,
				["nowait"] = false,
				["script"] = false,
				["silent"] = true,
				["unique"] = false,
			},
			{
				"<leader>fld",
				"<cmd>Telescope diagnostics<CR>",
				["desc"] = "Diagnostics [Telescope]",
				["expr"] = false,
				["mode"] = "n",
				["noremap"] = true,
				["nowait"] = false,
				["script"] = false,
				["silent"] = true,
				["unique"] = false,
			},
			{
				"<leader>fs",
				"<cmd>Telescope treesitter<CR>",
				["desc"] = "Treesitter [Telescope]",
				["expr"] = false,
				["mode"] = "n",
				["noremap"] = true,
				["nowait"] = false,
				["script"] = false,
				["silent"] = true,
				["unique"] = false,
			},
		},
		["lazy"] = false,
	},
	{
		"toggleterm-nvim",
		["after"] = function()
			require("toggleterm").setup({
				["direction"] = "horizontal",
				["enable_winbar"] = false,
				["size"] = function(term)
					if term.direction == "horizontal" then
						return 15
					elseif term.direction == "vertical" then
						return vim.o.columns * 0.4
					end
				end,
				["winbar"] = {
					["enabled"] = true,
					["name_formatter"] = function(term)
						return term.name
					end,
				},
			})
			local terminal = require("toggleterm.terminal")
			local lazygit = terminal.Terminal:new({
				cmd = "/nix/store/k0pcxln96q75n16yk4rpik0als3dwhyx-lazygit-0.44.1/bin/lazygit",
				direction = "float",
				hidden = true,
				on_open = function(term)
					vim.cmd("startinsert!")
				end,
			})

			vim.keymap.set("n", "<leader>gg", function()
				lazygit:toggle()
			end, { silent = true, noremap = true, desc = "Open lazygit [toggleterm]" })
		end,
		["cmd"] = {
			"ToggleTerm",
			"ToggleTermSendCurrentLine",
			"ToggleTermSendVisualLines",
			"ToggleTermSendVisualSelection",
			"ToggleTermSetName",
			"ToggleTermToggleAll",
		},
		["keys"] = {
			{
				"<c-t>",
				'<Cmd>execute v:count . "ToggleTerm"<CR>',
				["desc"] = "Toggle terminal",
				["expr"] = false,
				["mode"] = "n",
				["noremap"] = true,
				["nowait"] = false,
				["script"] = false,
				["silent"] = true,
				["unique"] = false,
			},
			{
				"<leader>gg",
				["desc"] = "Open lazygit [toggleterm]",
				["expr"] = false,
				["mode"] = "n",
				["noremap"] = true,
				["nowait"] = false,
				["script"] = false,
				["silent"] = true,
				["unique"] = false,
			},
		},
		["lazy"] = false,
	},
	{
		"trouble",
		["after"] = function()
			require("trouble").setup({})
		end,
		["cmd"] = "Trouble",
		["keys"] = {
			{
				"<leader>lwd",
				"<cmd>Trouble toggle diagnostics<CR>",
				["desc"] = "Workspace diagnostics [trouble]",
				["expr"] = false,
				["mode"] = "n",
				["noremap"] = true,
				["nowait"] = false,
				["script"] = false,
				["silent"] = true,
				["unique"] = false,
			},
			{
				"<leader>ld",
				"<cmd>Trouble toggle diagnostics filter.buf=0<CR>",
				["desc"] = "Document diagnostics [trouble]",
				["expr"] = false,
				["mode"] = "n",
				["noremap"] = true,
				["nowait"] = false,
				["script"] = false,
				["silent"] = true,
				["unique"] = false,
			},
			{
				"<leader>lr",
				"<cmd>Trouble toggle lsp_references<CR>",
				["desc"] = "LSP References [trouble]",
				["expr"] = false,
				["mode"] = "n",
				["noremap"] = true,
				["nowait"] = false,
				["script"] = false,
				["silent"] = true,
				["unique"] = false,
			},
			{
				"<leader>xq",
				"<cmd>Trouble toggle quickfix<CR>",
				["desc"] = "QuickFix [trouble]",
				["expr"] = false,
				["mode"] = "n",
				["noremap"] = true,
				["nowait"] = false,
				["script"] = false,
				["silent"] = true,
				["unique"] = false,
			},
			{
				"<leader>xl",
				"<cmd>Trouble toggle loclist<CR>",
				["desc"] = "LOCList [trouble]",
				["expr"] = false,
				["mode"] = "n",
				["noremap"] = true,
				["nowait"] = false,
				["script"] = false,
				["silent"] = true,
				["unique"] = false,
			},
			{
				"<leader>xs",
				"<cmd>Trouble toggle symbols<CR>",
				["desc"] = "Symbols [trouble]",
				["expr"] = false,
				["mode"] = "n",
				["noremap"] = true,
				["nowait"] = false,
				["script"] = false,
				["silent"] = true,
				["unique"] = false,
			},
		},
		["lazy"] = false,
	},
})
require("lzn-auto-require").enable()

-- SECTION: pluginConfigs
-- SECTION: autopairs
require("nvim-autopairs").setup({})

-- SECTION: null_ls-setup
local null_ls = require("null-ls")
local null_helpers = require("null-ls.helpers")
local null_methods = require("null-ls.methods")
local ls_sources = {}

-- SECTION: bash-diagnostics-shellcheck
table.insert(
	ls_sources,
	null_ls.builtins.diagnostics.shellcheck.with({
		command = "/nix/store/ssr5xilyw2fn1bha56fga0qh3ckkzlsl-shellcheck-0.10.0-bin/bin/shellcheck",
		diagnostics_format = "#{m} [#{c}]",
	})
)

-- SECTION: bash-format
table.insert(
	ls_sources,
	null_ls.builtins.formatting.shfmt.with({
		command = "/nix/store/4x3zrm2z11sqxp81zd51zvalkhkw744l-shfmt-3.10.0/bin/shfmt",
	})
)

-- SECTION: lsp-setup
vim.g.formatsave = false

local attach_keymaps = function(client, bufnr)
	vim.keymap.set(
		"n",
		"<leader>lgD",
		vim.lsp.buf.declaration,
		{ buffer = bufnr, noremap = true, silent = true, desc = "Go to declaration" }
	)
	vim.keymap.set(
		"n",
		"<leader>lgd",
		vim.lsp.buf.definition,
		{ buffer = bufnr, noremap = true, silent = true, desc = "Go to definition" }
	)
	vim.keymap.set(
		"n",
		"<leader>lgt",
		vim.lsp.buf.type_definition,
		{ buffer = bufnr, noremap = true, silent = true, desc = "Go to type" }
	)
	vim.keymap.set(
		"n",
		"<leader>lgi",
		vim.lsp.buf.implementation,
		{ buffer = bufnr, noremap = true, silent = true, desc = "List implementations" }
	)
	vim.keymap.set(
		"n",
		"<leader>lgr",
		vim.lsp.buf.references,
		{ buffer = bufnr, noremap = true, silent = true, desc = "List references" }
	)
	vim.keymap.set(
		"n",
		"<leader>lgn",
		vim.diagnostic.goto_next,
		{ buffer = bufnr, noremap = true, silent = true, desc = "Go to next diagnostic" }
	)
	vim.keymap.set(
		"n",
		"<leader>lgp",
		vim.diagnostic.goto_prev,
		{ buffer = bufnr, noremap = true, silent = true, desc = "Go to previous diagnostic" }
	)
	vim.keymap.set(
		"n",
		"<leader>le",
		vim.diagnostic.open_float,
		{ buffer = bufnr, noremap = true, silent = true, desc = "Open diagnostic float" }
	)
	vim.keymap.set(
		"n",
		"<leader>lH",
		vim.lsp.buf.document_highlight,
		{ buffer = bufnr, noremap = true, silent = true, desc = "Document highlight" }
	)
	vim.keymap.set(
		"n",
		"<leader>lS",
		vim.lsp.buf.document_symbol,
		{ buffer = bufnr, noremap = true, silent = true, desc = "List document symbols" }
	)
	vim.keymap.set(
		"n",
		"<leader>lwa",
		vim.lsp.buf.add_workspace_folder,
		{ buffer = bufnr, noremap = true, silent = true, desc = "Add workspace folder" }
	)
	vim.keymap.set(
		"n",
		"<leader>lwr",
		vim.lsp.buf.remove_workspace_folder,
		{ buffer = bufnr, noremap = true, silent = true, desc = "Remove workspace folder" }
	)
	vim.keymap.set("n", "<leader>lwl", function()
		vim.notify(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, { buffer = bufnr, noremap = true, silent = true, desc = "List workspace folders" })
	vim.keymap.set(
		"n",
		"<leader>lws",
		vim.lsp.buf.workspace_symbol,
		{ buffer = bufnr, noremap = true, silent = true, desc = "List workspace symbols" }
	)
	vim.keymap.set(
		"n",
		"<leader>lh",
		vim.lsp.buf.hover,
		{ buffer = bufnr, noremap = true, silent = true, desc = "Trigger hover" }
	)
	vim.keymap.set(
		"n",
		"<leader>ls",
		vim.lsp.buf.signature_help,
		{ buffer = bufnr, noremap = true, silent = true, desc = "Signature help" }
	)
	vim.keymap.set(
		"n",
		"<leader>ln",
		vim.lsp.buf.rename,
		{ buffer = bufnr, noremap = true, silent = true, desc = "Rename symbol" }
	)
	vim.keymap.set(
		"n",
		"<leader>la",
		vim.lsp.buf.code_action,
		{ buffer = bufnr, noremap = true, silent = true, desc = "Code action" }
	)
	vim.keymap.set(
		"n",
		"<leader>lf",
		vim.lsp.buf.format,
		{ buffer = bufnr, noremap = true, silent = true, desc = "Format" }
	)
	vim.keymap.set("n", "<leader>ltf", function()
		vim.b.disableFormatSave = not vim.b.disableFormatSave
	end, { buffer = bufnr, noremap = true, silent = true, desc = "Toggle format on save" })
end

-- Enable formatting
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

format_callback = function(client, bufnr)
	if vim.g.formatsave then
		vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
		vim.api.nvim_create_autocmd("BufWritePre", {
			group = augroup,
			buffer = bufnr,
			callback = function()
				if vim.b.disableFormatSave then
					return
				end

				local function is_null_ls_formatting_enabled(bufnr)
					local file_type = vim.api.nvim_buf_get_option(bufnr, "filetype")
					local generators = require("null-ls.generators").get_available(
						file_type,
						require("null-ls.methods").internal.FORMATTING
					)
					return #generators > 0
				end

				if is_null_ls_formatting_enabled(bufnr) then
					vim.lsp.buf.format({
						bufnr = bufnr,
						filter = function(client)
							return client.name == "null-ls"
						end,
					})
				else
					vim.lsp.buf.format({
						bufnr = bufnr,
					})
				end
			end,
		})
	end
end

local navic = require("nvim-navic")
default_on_attach = function(client, bufnr)
	attach_keymaps(client, bufnr)
	format_callback(client, bufnr)
	-- let navic attach to buffers
	if client.server_capabilities.documentSymbolProvider then
		navic.attach(client, bufnr)
	end
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
-- HACK: copied from cmp-nvim-lsp. If we ever lazy load lspconfig we
-- should re-evaluate whether we can just use `default_capabilities`
capabilities = {
	textDocument = {
		completion = {
			dynamicRegistration = false,
			completionItem = {
				snippetSupport = true,
				commitCharactersSupport = true,
				deprecatedSupport = true,
				preselectSupport = true,
				tagSupport = {
					valueSet = {
						1, -- Deprecated
					},
				},
				insertReplaceSupport = true,
				resolveSupport = {
					properties = {
						"documentation",
						"detail",
						"additionalTextEdits",
						"sortText",
						"filterText",
						"insertText",
						"textEdit",
						"insertTextFormat",
						"insertTextMode",
					},
				},
				insertTextModeSupport = {
					valueSet = {
						1, -- asIs
						2, -- adjustIndentation
					},
				},
				labelDetailsSupport = true,
			},
			contextSupport = true,
			insertTextMode = 1,
			completionList = {
				itemDefaults = {
					"commitCharacters",
					"editRange",
					"insertTextFormat",
					"insertTextMode",
					"data",
				},
			},
		},
	},
}

-- SECTION: lspconfig
local lspconfig = require("lspconfig")

require("lspconfig.ui.windows").default_options.border = "rounded"

-- SECTION: bash-lsp
lspconfig.bashls.setup({
	capabilities = capabilities,
	on_attach = default_on_attach,
	cmd = { "/nix/store/2jfbhhbf96sdqqrvlivfp2xmpw6vqw25-bash-language-server-5.4.0/bin/bash-language-server", "start" },
})

-- SECTION: breadcrumbs

local navic = require("nvim-navic")
require("nvim-navic").setup({
	highlight = true,
})

-- SECTION: highlight-undo
require("highlight-undo").setup({ ["duration"] = 500 })

-- SECTION: indent-blankline
require("ibl").setup({
	["debounce"] = 200,
	["indent"] = { ["char"] = "│", ["priority"] = 1, ["repeat_linebreak"] = true, ["smart_indent_cap"] = true },
	["scope"] = {
		["char"] = "│",
		["enabled"] = true,
		["exclude"] = {
			["language"] = {},
			["node_type"] = { ["*"] = { "source_file", "program" }, ["lua"] = { "chunk" }, ["python"] = { "module" } },
		},
		["include"] = { ["node_type"] = {} },
		["injected_languages"] = true,
		["priority"] = 1024,
		["show_end"] = false,
		["show_exact_scope"] = false,
		["show_start"] = false,
	},
	["viewport_buffer"] = { ["max"] = 500, ["min"] = 30 },
	["whitespace"] = { ["remove_blankline_trail"] = true },
})

-- SECTION: lua-lsp
lspconfig.lua_ls.setup({
	capabilities = capabilities,
	on_attach = default_on_attach,
	cmd = { "/nix/store/qryh1ybbgydvbh2w119wypzsd7aq37j3-lua-language-server-3.13.0/bin/lua-language-server" },
})

-- SECTION: lualine
local lualine = require("lualine")
lualine.setup({
	["extensions"] = { "nvim-tree" },
	["inactive_sections"] = {
		["lualine_a"] = {},
		["lualine_b"] = {},
		["lualine_c"] = { "filename" },
		["lualine_x"] = { "location" },
		["lualine_y"] = {},
		["lualine_z"] = {},
	},
	["options"] = {
		["always_divide_middle"] = true,
		["component_separators"] = { "", "" },
		["globalstatus"] = true,
		["icons_enabled"] = true,
		["refresh"] = { ["statusline"] = 1000, ["tabline"] = 1000, ["winbar"] = 1000 },
		["section_separators"] = { "", "" },
		["theme"] = "auto",
	},
	["sections"] = {
		["lualine_a"] = {
			{
				"mode",
				icons_enabled = true,
				separator = {
					left = "▎",
					right = "",
				},
			},
			{
				"",
				draw_empty = true,
				separator = { left = "", right = "" },
			},
		},
		["lualine_b"] = {
			{
				"filetype",
				colored = true,
				icon_only = true,
				icon = { align = "left" },
			},
			{
				"filename",
				symbols = { modified = " ", readonly = " " },
				separator = { right = "" },
			},
			{
				"",
				draw_empty = true,
				separator = { left = "", right = "" },
			},
		},
		["lualine_c"] = {
			{
				"diff",
				colored = false,
				diff_color = {
					-- Same color values as the general color option can be used here.
					added = "DiffAdd", -- Changes the diff's added color
					modified = "DiffChange", -- Changes the diff's modified color
					removed = "DiffDelete", -- Changes the diff's removed color you
				},
				symbols = { added = "+", modified = "~", removed = "-" }, -- Changes the diff symbols
				separator = { right = "" },
			},
		},
		["lualine_x"] = {
			{
				-- Lsp server name
				function()
					local buf_ft = vim.api.nvim_get_option_value("filetype", {})

					-- List of buffer types to exclude
					local excluded_buf_ft = { "toggleterm", "NvimTree", "neo-tree", "TelescopePrompt" }

					-- Check if the current buffer type is in the excluded list
					for _, excluded_type in ipairs(excluded_buf_ft) do
						if buf_ft == excluded_type then
							return ""
						end
					end

					-- Get the name of the LSP server active in the current buffer
					local clients = vim.lsp.get_active_clients()
					local msg = "No Active Lsp"

					-- if no lsp client is attached then return the msg
					if next(clients) == nil then
						return msg
					end

					for _, client in ipairs(clients) do
						local filetypes = client.config.filetypes
						if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
							return client.name
						end
					end

					return msg
				end,
				icon = " ",
				separator = { left = "" },
			},
			{
				"diagnostics",
				sources = { "nvim_lsp", "nvim_diagnostic", "nvim_diagnostic", "vim_lsp", "coc" },
				symbols = { error = "󰅙  ", warn = "  ", info = "  ", hint = "󰌵 " },
				colored = true,
				update_in_insert = false,
				always_visible = false,
				diagnostics_color = {
					color_error = { fg = "red" },
					color_warn = { fg = "yellow" },
					color_info = { fg = "cyan" },
				},
			},
		},
		["lualine_y"] = {
			{
				"",
				draw_empty = true,
				separator = { left = "", right = "" },
			},
			{
				"searchcount",
				maxcount = 999,
				timeout = 120,
				separator = { left = "" },
			},
			{
				"branch",
				icon = " •",
				separator = { left = "" },
			},
		},
		["lualine_z"] = {
			{
				"",
				draw_empty = true,
				separator = { left = "", right = "" },
			},
			{
				"progress",
				separator = { left = "" },
			},
			{ "location" },
			{
				"fileformat",
				color = { fg = "black" },
				symbols = {
					unix = "", -- e712
					dos = "", -- e70f
					mac = "", -- e711
				},
			},
		},
	},
	["winbar"] = { ["lualine_c"] = { { "navic", draw_empty = true } } },
})

-- SECTION: markdown-format
table.insert(
	ls_sources,
	null_ls.builtins.formatting.deno_fmt.with({
		filetypes = { "markdown" },
		command = "/nix/store/f17kw3ncb2b1420ix4r9cmqnjk1m94cl-deno-2.1.4/bin/deno",
	})
)

-- SECTION: markdown-lsp
lspconfig.marksman.setup({
	capabilities = capabilities,
	on_attach = default_on_attach,
	cmd = { "/nix/store/asdazw5svhj384j9r93d3vrs0gg6bmpk-marksman-2024-10-07/bin/marksman", "server" },
})

-- SECTION: modes-nvim
require("modes").setup({
	["colors"] = { ["copy"] = "#f5c359", ["delete"] = "#c75c6a", ["insert"] = "#78ccc5", ["visual"] = "#9745be" },
	["line_opacity"] = { ["visual"] = 0.000000 },
	["setCursorline"] = false,
})

-- SECTION: nix
vim.api.nvim_create_autocmd("FileType", {
	pattern = "nix",
	callback = function(opts)
		local bo = vim.bo[opts.buf]
		bo.tabstop = 2
		bo.shiftwidth = 2
		bo.softtabstop = 2
	end,
})

-- SECTION: nix-diagnostics-deadnix
table.insert(
	ls_sources,
	null_ls.builtins.diagnostics.deadnix.with({
		command = "/nix/store/bziskf2rm9wks5fqpjaaywpldm9bpi6g-deadnix-1.2.1/bin/deadnix",
	})
)

-- SECTION: nix-diagnostics-statix
table.insert(
	ls_sources,
	null_ls.builtins.diagnostics.statix.with({
		command = "/nix/store/pkqp4is8aybllw37406hb3n0081jdhgq-statix-0.5.8/bin/statix",
	})
)

-- SECTION: nix-lsp
lspconfig.nil_ls.setup({
	capabilities = capabilities,
	on_attach = default_on_attach,
	cmd = { "/nix/store/qz1623cq39ar2acvllbxry8x41l7dspc-nil-2024-08-06/bin/nil" },
	settings = {
		["nil"] = {
			formatting = {
				command = { "/nix/store/agj4r1ibcdrzn71vcg1pngbv2rgwhk12-nixfmt-unstable-2024-12-04/bin/nixfmt" },
			},
		},
	},
})

-- SECTION: noice-nvim
require("noice").setup({
	["format"] = {
		["cmdline"] = { ["icon"] = "", ["lang"] = "vim", ["pattern"] = "^:" },
		["filter"] = { ["icon"] = "", ["lang"] = "bash", ["pattern"] = "^:%s*!" },
		["help"] = { ["icon"] = "󰋖", ["pattern"] = "^:%s*he?l?p?%s+" },
		["lua"] = { ["icon"] = "", ["lang"] = "lua", ["pattern"] = "^:%s*lua%s+" },
		["search_down"] = { ["icon"] = " ", ["kind"] = "search", ["lang"] = "regex", ["pattern"] = "^/" },
		["search_up"] = { ["icon"] = " ", ["kind"] = "search", ["lang"] = "regex", ["pattern"] = "^%?" },
	},
	["lsp"] = {
		["override"] = {
			["cmp.entry.get_documentation"] = true,
			["vim.lsp.util.convert_input_to_markdown_lines"] = true,
			["vim.lsp.util.stylize_markdown"] = true,
		},
		["signature"] = { ["enabled"] = false },
	},
	["presets"] = {
		["bottom_search"] = true,
		["command_palette"] = true,
		["inc_rename"] = false,
		["long_message_to_split"] = true,
		["lsp_doc_border"] = true,
	},
	["routes"] = {
		{
			["filter"] = { ["event"] = "msg_show", ["find"] = "written", ["kind"] = "" },
			["opts"] = { ["skip"] = true },
		},
	},
})

-- SECTION: python-format
table.insert(
	ls_sources,
	null_ls.builtins.formatting.isort.with({
		command = "/nix/store/fyfidwrpq0d5sz92x3vzly1249bkhsys-python3.12-isort-5.13.2/bin/isort",
	})
)

-- SECTION: null_ls
require("null-ls").setup({
	debug = false,
	diagnostics_format = "[#{m}] #{s} (#{c})",
	debounce = 250,
	default_timeout = 5000,
	sources = ls_sources,
	on_attach = default_on_attach,
})

-- SECTION: nvim-cursorline
require("nvim-cursorline").setup({
	["cursorline"] = { ["enable"] = false, ["number"] = false, ["timeout"] = 1000 },
	["cursorword"] = { ["enable"] = false, ["hl"] = { ["underline"] = true }, ["min_length"] = 3, ["timeout"] = 1000 },
})

-- SECTION: nvim-docs-view
require("docs-view").setup({ ["height"] = 10, ["position"] = "right", ["update_mode"] = "auto", ["width"] = 60 })

-- SECTION: nvim-notify
local notify = require("notify")
notify.setup({
	["background_colour"] = "NotifyBackground",
	["icons"] = { ["DEBUG"] = "", ["ERROR"] = "", ["INFO"] = "", ["TRACE"] = "", ["WARN"] = "" },
	["position"] = "top_right",
	["render"] = "compact",
	["stages"] = "fade_in_slide_out",
	["timeout"] = 1000,
})
vim.notify = notify.notify

-- SECTION: nvim-tree

require("lz.n").trigger_load("nvim-tree-lua")
-- autostart behaviour
-- Open on startup has been deprecated
-- see https://github.com/nvim-tree/nvim-tree.lua/wiki/Open-At-Startup

-- use a nix eval to dynamically insert the open on startup function
local function open_nvim_tree(data)
	local IGNORED_FT = {
		"markdown",
	}

	-- buffer is a real file on the disk
	local real_file = vim.fn.filereadable(data.file) == 1

	-- buffer is a directory
	local directory = vim.fn.isdirectory(data.file) == 1

	-- buffer is a [No Name]
	local no_name = data.file == "" and vim.bo[data.buf].buftype == ""

	-- &ft
	local filetype = vim.bo[data.buf].ft

	-- only files please
	if not real_file and not directory and not no_name then
		return
	end

	-- skip ignored filetypes
	if vim.tbl_contains(IGNORED_FT, filetype) then
		return
	end

	-- cd if buffer is a directory
	if directory then
		vim.cmd.cd(data.file)
	end
	-- open the tree but don't focus it
	require("nvim-tree.api").tree.toggle({ focus = false })
end

-- function to automatically open the tree on VimEnter
vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })

-- SECTION: nvim-web-devicons
require("nvim-web-devicons").setup({ ["color_icons"] = true, ["override"] = {} })

-- SECTION: nvimBufferline
require("bufferline").setup({
	["highlights"] = {},
	["options"] = {
		["always_show_bufferline"] = true,
		["auto_toggle_bufferline"] = true,
		["buffer_close_icon"] = " 󰅖 ",
		["close_command"] = function(bufnum)
			require("bufdelete").bufdelete(bufnum, false)
		end,
		["close_icon"] = "  ",
		["color_icons"] = true,
		["diagnostics"] = "nvim_lsp",
		["diagnostics_indicator"] = function(count, level, diagnostics_dict, context)
			local s = " "
			for e, n in pairs(diagnostics_dict) do
				local sym = e == "error" and "   " or (e == "warning" and "   " or "  ")
				s = s .. n .. sym
			end
			return s
		end,
		["diagnostics_update_in_insert"] = false,
		["duplicates_across_groups"] = true,
		["enforce_regular_tabs"] = false,
		["hover"] = { ["delay"] = 200, ["enabled"] = true, ["reveal"] = { "close" } },
		["indicator"] = { ["style"] = "underline" },
		["left_mouse_command"] = "buffer %d",
		["left_trunc_marker"] = "",
		["max_name_length"] = 18,
		["max_prefix_length"] = 15,
		["mode"] = "buffers",
		["modified_icon"] = "● ",
		["move_wraps_at_ends"] = false,
		["numbers"] = function(opts)
			return string.format("%s·%s", opts.raise(opts.id), opts.lower(opts.ordinal))
		end,
		["offsets"] = {
			{
				["filetype"] = "NvimTree",
				["highlight"] = "Directory",
				["separator"] = true,
				["text"] = "File Explorer",
			},
		},
		["persist_buffer_sort"] = true,
		["right_mouse_command"] = "vertical sbuffer %d",
		["right_trunc_marker"] = "",
		["separator_style"] = "thin",
		["show_buffer_close_icons"] = true,
		["show_buffer_icons"] = true,
		["show_close_icon"] = true,
		["show_duplicate_prefix"] = true,
		["show_tab_indicators"] = true,
		["sort_by"] = "extension",
		["style_preset"] = require("bufferline").style_preset.default,
		["tab_size"] = 18,
		["themable"] = true,
		["truncate_names"] = true,
	},
})

-- SECTION: otter-nvim
-- Enable otter diagnostics viewer
require("otter").setup({
	["buffers"] = { ["set_filetype"] = false, ["write_to_disk"] = false },
	["handle_leading_whitespace"] = false,
	["lsp"] = { ["diagnostic_update_event"] = { "BufWritePost" } },
	["strip_wrapping_quote_characters"] = { "'", '"', "`" },
})

-- SECTION: python-lsp
lspconfig.basedpyright.setup({
	capabilities = capabilities,
	on_attach = default_on_attach,
	cmd = { "/nix/store/8qp4fq020iflcy1pil9mg0ywzh7gxqlz-basedpyright-1.21.1/bin/basedpyright-langserver", "--stdio" },
})

-- SECTION: render-markdown-nvim
require("render-markdown").setup({ ["auto_override_publish_diagnostics"] = true })

-- SECTION: todo-comments
require("todo-comments").setup({
	["highlight"] = { ["pattern"] = ".*<(KEYWORDS)(\\([^\\)]*\\))?:" },
	["search"] = {
		["args"] = { "--color=never", "--no-heading", "--with-filename", "--line-number", "--column" },
		["command"] = "/nix/store/4rhrla8ldkgjrhx3hgpfa2vhp7j034qc-ripgrep-14.1.1/bin/rg",
		["pattern"] = "\\b(KEYWORDS)(\\([^\\)]*\\))?:",
	},
})

-- SECTION: treesitter
require("nvim-treesitter.configs").setup({
	-- Disable imperative treesitter options that would attempt to fetch
	-- grammars into the read-only Nix store. To add additional grammars here
	-- you must use the `config.vim.treesitter.grammars` option.
	auto_install = false,
	sync_install = false,
	ensure_installed = {},
	-- Indentation module for Treesitter
	indent = {
		enable = true,
		disable = {},
	},
	-- Highlight module for Treesitter
	highlight = {
		enable = true,
		disable = {},
		additional_vim_regex_highlighting = false,
	},
	-- Indentation module for Treesitter
	-- Keymaps are set to false here as they are
	-- handled by `vim.maps` entries calling lua
	-- functions achieving the same functionality.
	incremental_selection = {
		enable = true,
		disable = {},
		keymaps = {
			init_selection = false,
			node_incremental = false,
			scope_incremental = false,
			node_decremental = false,
		},
	},
})

-- SECTION: treesitter-context
require("treesitter-context").setup({
	["line_numbers"] = true,
	["max_lines"] = 0,
	["min_window_height"] = 0,
	["mode"] = "cursor",
	["multiline_threshold"] = 20,
	["separator"] = "-",
	["trim_scope"] = "outer",
	["zindex"] = 20,
})

-- SECTION: treesitter-fold
-- This is required by treesitter-context to handle folds
vim.o.foldmethod = "expr"
vim.o.foldexpr = "nvim_treesitter#foldexpr()"

-- This is optional, but is set rather as a sane default.
-- If unset, opened files will be folded by automatically as
-- the files are opened
vim.o.foldenable = false

-- SECTION: vim-illuminate
require("illuminate").configure({
	filetypes_denylist = {
		"dirvish",
		"fugitive",
		"NvimTree",
		"TelescopePrompt",
	},
})

-- SECTION: whichkey
local wk = require("which-key")
wk.setup({
	["notify"] = true,
	["preset"] = "modern",
	["replace"] = { ["<cr>"] = "RETURN", ["<leader>"] = "SPACE", ["<space>"] = "SPACE", ["<tab>"] = "TAB" },
	["win"] = { ["border"] = "rounded" },
})
wk.add({
	{ "<leader>b", desc = "+Buffer" },
	{ "<leader>bm", desc = "BufferLineMove" },
	{ "<leader>bs", desc = "BufferLineSort" },
	{ "<leader>bsi", desc = "BufferLineSortById" },
	{ "<leader>f", desc = "+Telescope" },
	{ "<leader>fl", desc = "Telescope LSP" },
	{ "<leader>fm", desc = "Cellular Automaton" },
	{ "<leader>fv", desc = "Telescope Git" },
	{ "<leader>fvc", desc = "Commits" },
	{ "<leader>lw", desc = "+Workspace" },
	{ "<leader>t", desc = "+NvimTree" },
	{ "<leader>x", desc = "+Trouble" },
})

-- SECTION: extraPluginConfigs

-- SECTION: mappings
vim.keymap.set({ "n" }, "<leader>bc", ":BufferLinePick<CR>", {
	["desc"] = "Pick buffer",
	["expr"] = false,
	["noremap"] = true,
	["nowait"] = false,
	["script"] = false,
	["silent"] = true,
	["unique"] = false,
})
vim.keymap.set({ "n" }, "<leader>bmn", ":BufferLineMoveNext<CR>", {
	["desc"] = "Move next buffer",
	["expr"] = false,
	["noremap"] = true,
	["nowait"] = false,
	["script"] = false,
	["silent"] = true,
	["unique"] = false,
})
vim.keymap.set({ "n" }, "<leader>bmp", ":BufferLineMovePrev<CR>", {
	["desc"] = "Move previous buffer",
	["expr"] = false,
	["noremap"] = true,
	["nowait"] = false,
	["script"] = false,
	["silent"] = true,
	["unique"] = false,
})
vim.keymap.set({ "n" }, "<leader>bn", ":BufferLineCycleNext<CR>", {
	["desc"] = "Next buffer",
	["expr"] = false,
	["noremap"] = true,
	["nowait"] = false,
	["script"] = false,
	["silent"] = true,
	["unique"] = false,
})
vim.keymap.set({ "n" }, "<leader>bp", ":BufferLineCyclePrev<CR>", {
	["desc"] = "Previous buffer",
	["expr"] = false,
	["noremap"] = true,
	["nowait"] = false,
	["script"] = false,
	["silent"] = true,
	["unique"] = false,
})
vim.keymap.set({ "n" }, "<leader>bsd", ":BufferLineSortByDirectory<CR>", {
	["desc"] = "Sort buffers by directory",
	["expr"] = false,
	["noremap"] = true,
	["nowait"] = false,
	["script"] = false,
	["silent"] = true,
	["unique"] = false,
})
vim.keymap.set({ "n" }, "<leader>bse", ":BufferLineSortByExtension<CR>", {
	["desc"] = "Sort buffers by extension",
	["expr"] = false,
	["noremap"] = true,
	["nowait"] = false,
	["script"] = false,
	["silent"] = true,
	["unique"] = false,
})
vim.keymap.set({ "n" }, "<leader>bsi", function()
	require("bufferline").sort_buffers_by(function(buf_a, buf_b)
		return buf_a.id < buf_b.id
	end)
end, {
	["desc"] = "Sort buffers by ID",
	["expr"] = false,
	["noremap"] = true,
	["nowait"] = false,
	["script"] = false,
	["silent"] = true,
	["unique"] = false,
})
vim.keymap.set({ "n" }, "<leader>lo", "<cmd>lua require'otter'.activate()<CR>", {
	["desc"] = "Activate LSP on Cursor Position [otter-nvim]",
	["expr"] = false,
	["noremap"] = true,
	["nowait"] = false,
	["script"] = false,
	["silent"] = true,
	["unique"] = false,
})
vim.keymap.set({ "n" }, "<leader>tdq", ":TodoQuickFix<CR>", {
	["desc"] = "Open Todo-s in a quickfix list",
	["expr"] = false,
	["noremap"] = true,
	["nowait"] = false,
	["script"] = false,
	["silent"] = true,
	["unique"] = false,
})
vim.keymap.set({ "n" }, "<leader>tds", ":TodoTelescope<CR>", {
	["desc"] = "Open Todo-s in telescope",
	["expr"] = false,
	["noremap"] = true,
	["nowait"] = false,
	["script"] = false,
	["silent"] = true,
	["unique"] = false,
})
vim.keymap.set({ "n" }, "<leader>tdt", ":TodoTrouble<CR>", {
	["desc"] = "Open Todo-s in Trouble",
	["expr"] = false,
	["noremap"] = true,
	["nowait"] = false,
	["script"] = false,
	["silent"] = true,
	["unique"] = false,
})
vim.keymap.set({ "n" }, "gnn", ":lua require('nvim-treesitter.incremental_selection').init_selection()<CR>", {
	["desc"] = "Init selection [treesitter]",
	["expr"] = false,
	["noremap"] = true,
	["nowait"] = false,
	["script"] = false,
	["silent"] = true,
	["unique"] = false,
})
vim.keymap.set({ "n" }, "lvt", "<cmd>DocsViewToggle<CR>", {
	["desc"] = "Open or close the docs view panel",
	["expr"] = false,
	["noremap"] = true,
	["nowait"] = false,
	["script"] = false,
	["silent"] = true,
	["unique"] = false,
})
vim.keymap.set({ "n" }, "lvu", "<cmd>DocsViewUpdate<CR>", {
	["desc"] = "Manually update the docs view panel",
	["expr"] = false,
	["noremap"] = true,
	["nowait"] = false,
	["script"] = false,
	["silent"] = true,
	["unique"] = false,
})
vim.keymap.set(
	{ "n", "x" },
	"grc",
	"<cmd>lua require('nvim-treesitter.incremental_selection').scope_incremental()<CR>",
	{
		["desc"] = "Increment selection by scope [treesitter]",
		["expr"] = false,
		["noremap"] = true,
		["nowait"] = false,
		["script"] = false,
		["silent"] = true,
		["unique"] = false,
	}
)
vim.keymap.set(
	{ "n", "x" },
	"grm",
	"<cmd>lua require('nvim-treesitter.incremental_selection').node_decremental()<CR>",
	{
		["desc"] = "Decrement selection by node [treesitter]",
		["expr"] = false,
		["noremap"] = true,
		["nowait"] = false,
		["script"] = false,
		["silent"] = true,
		["unique"] = false,
	}
)
vim.keymap.set(
	{ "n", "x" },
	"grn",
	"<cmd>lua require('nvim-treesitter.incremental_selection').node_incremental()<CR>",
	{
		["desc"] = "Increment selection by node [treesitter]",
		["expr"] = false,
		["noremap"] = true,
		["nowait"] = false,
		["script"] = false,
		["silent"] = true,
		["unique"] = false,
	}
)
