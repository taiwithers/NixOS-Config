-- https://github.com/ntk148v/neovim-config/blob/master/lua/autocmds.lua
local autocmd = vim.api.nvim_create_autocmd -- Create autocommand

-- <leader> key. Defaults to `\`. Some people prefer space.
vim.g.mapleader = " "
vim.g.maplocalleader = " " -- used by markdown-plus

require("options")
require("nix-paths")

if io.open("wsl-clipboard") then
  require("wsl-clipboard")
end

-- to add
-- breadcrumbs? nvim-navic
-- window picker
-- multi-file search/replace
-- add <cmd><cr> as a lua snippet

-- show lsp diagnostics as virtual text at the end of the current line
vim.diagnostic.config({ virtual_text = { current_line = true } })

-- show inlay hints (currently used by nixd for versions)
vim.lsp.inlay_hint.enable(true)

vim.filetype.add({
  extension = { mdx = "mdx" },
})
require("Comment.ft").set("mdx", { "{/*%s*/}", "{/**%s**/}" })

autocmd("TextYankPost", {
  -- highlight yanked text
  callback = function()
    vim.hl.on_yank({ timeout = 400 })
  end,
})

require("range-highlight").setup()

-- tab out of brackets and pairs
require("tabout").setup({
  act_as_shift_tab = true, -- dedent if no pairs, indent is true by default
})

-- statuscolumn git indicators
require("gitsigns").setup({
  sign_priority = 1000, -- don't overlap marks
  preview_config = {
    border = "rounded",
    title = "Git Blame",
  },
})
vim.keymap.set({ "n" }, "<leader>gb", function()
  require("gitsigns").blame_line({ ignore_whitespace = true, full = true })
end, { desc = "View Git blame for current line" })

-- change the colour of the line highlight based on current mode
require("modes").setup()

-- highlight text affected by "undo"
require("highlight-undo").setup()

-- turn off search highlight after you perform a non-search action
require("auto-hlsearch").setup()

-- lualine does the status bar at the bottom and also the tab bar at the top
local function visually_selected_line_count()
  local starts = vim.fn.line("v")
  local ends = vim.fn.line(".")
  local count = starts <= ends and ends - starts + 1 or starts - ends + 1
  return count .. "V"
end
local function in_visual_mode()
  return vim.fn.mode():find("[Vv]") ~= nil
end
require("lualine").setup({
  options = {
    theme = "moonfly",
    component_separators = { left = "", right = "" },
    section_separators = { left = "", right = "" },
    global_status = true,
  },
  extensions = { "fzf", "quickfix", "toggleterm" }, -- understand additional filetypes
  sections = {
    lualine_a = { "mode" },
    lualine_b = { { "branch", icon = "" }, "diagnostics" },
    lualine_c = {},
    lualine_x = {},
    lualine_y = { { "filetype", icon_only = true }, "lsp_status" },
    lualine_z = { "location", { visually_selected_line_count, cond = in_visual_mode } },
  },
  tabline = {
    lualine_a = { { "buffers", use_mode_colors = true } },
    lualine_z = { { "tabs", use_mode_colors = true } },
  },
})

-- autopairing
require("mini.pairs").setup()

require("mini.bufremove").setup()
vim.keymap.set({ "n" }, "<leader>dd", "<cmd>lua MiniBufremove.delete()<cr>", { desc = "Close buffer" })

require("mini.indentscope").setup({
  draw = {
    animation = require("mini.indentscope").gen_animation.none(),
  },
})
vim.api.nvim_set_hl(0, "MiniIndentscopeSymbol", { fg = "#555555" })

-- colourize hex, css, rgb colours
-- mini.hipatterns doesn't quite match this functionality
require("colorizer").setup({
  lazy_load = true,
  options = {
    parsers = {
      css = true,
      css_color = { enable = true },
      sass = { enable = true },
      xcolor = { enable = true },
    },
  },
})

-- tpope-style surround
require("nvim-surround").setup()

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

-- flash - fFtT motions and labelled search results
require("flash").setup({
  -- repeat fFtT motions with fFtT (as well as , ;)
  -- fFtT travel across lines
  labels = "aeichtsnuoybldwvkjxgrmfp", -- ordered by accessibility on based on keyboard layout
  search = { multi_window = false },
  label = { uppercase = false, min_pattern_length = 2 },
  modes = {
    search = { enabled = true }, -- three-character jumps during /? searches
  },
})

-- template/f-string conversion (uses treesitter, so could move this inside the treesitter setup)
require("template-string").setup({
  filetypes = {
    "html",
    "typescript",
    "javascript",
    "typescriptreact",
    "javascriptreact",
    "vue",
    "svelte",
    "python",
    "cs",
    "astro",
  },
  remove_template_string = true,
  restore_quotes = { normal = [["]] },
})

-- project/workspace/session management
require("project").setup({
  silent_chdir = false,
  patterns = { ">projects", "flake.nix" },
})
vim.keymap.set("n", "<leader>fP", "<cmd>Project<cr>", { desc = "Manage projects" })
vim.keymap.set("n", "<leader>fp", "<cmd>Telescope projects theme=dropdown<cr>", { desc = "Select project" })

-- show marks on the left
-- not working w/ whichkey is known issue https://github.com/chentoast/marks.nvim/issues/113
require("marks").setup({})

-- markdown (may also take over for table mode at some point)
require("markdown-plus").setup({
  features = {
    list_management = true,
    text_formatting = false,
    thematic_break = false,
    links = false,
    images = false,
    headers_toc = false,
    quotes = false,
    callouts = false,
    code_block = false,
    html_block_awareness = true,
    table = true,
    footnotes = false,
  },
  list = { checkbox_completion = { enabled = false } },
  keymaps = { enabled = false },
  filetypes = { "markdown", "mdx", "text" },
})
autocmd({ "BufEnter", "BufWinEnter" }, {
  -- set keybindings for markdown plus
  pattern = { "*.md", "*.mdx", "*.txt" },
  callback = function()
    -- navigation
    vim.keymap.set({ "n" }, "gn", "<Plug>(MarkdownPlusNextHeader)", { desc = "Go to next header", buffer = true })
    vim.keymap.set({ "n" }, "gp", "<Plug>(MarkdownPlusPrevHeader)", { desc = "Go to previous header", buffer = true })

    -- tables
    -- add keybind that opens a picker for the column/row manipulation keybinds?
    vim.keymap.set(
      { "n" },
      "<leader>mtn",
      "<Plug>(MarkdownPlusTableCreate)",
      { desc = "Create markdown table", buffer = true }
    )
    vim.keymap.set(
      { "n", "i" },
      "<c-l>",
      "<Plug>(MarkdownPlusTableNavRight)",
      { desc = "Move to right cell", buffer = true }
    )
    vim.keymap.set(
      { "n", "i" },
      "<c-h>",
      "<Plug>(MarkdownPlusTableNavLeft)",
      { desc = "Move to left cell", buffer = true }
    )
    vim.keymap.set(
      { "n", "i" },
      "<c-j>",
      "<Plug>(MarkdownPlusTableNavDown)",
      { desc = "Move to below cell", buffer = true }
    )
    vim.keymap.set(
      { "n", "i" },
      "<c-k>",
      "<Plug>(MarkdownPlusTableNavUp)",
      { desc = "Move to above cell", buffer = true }
    )

    -- lists
    vim.keymap.set({ "i" }, "<cr>", "<Plug>(MarkdownPlusListEnter)", { desc = "Add new list item", buffer = true })
    vim.keymap.set(
      { "i" },
      "<s-cr>",
      "<Plug>(MarkdownPlusListShiftEnter)",
      { desc = "Continue list item on next line", buffer = true }
    )
    vim.keymap.set({ "i" }, "<tab>", "<Plug>(MarkdownPlusListIndent)", { desc = "Indent list item", buffer = true })
    vim.keymap.set({ "i" }, "<s-tab>", "<Plug>(MarkdownPlusListOutdent)", { desc = "Outdent list item", buffer = true })
    vim.keymap.set(
      { "i" },
      "<bs>",
      "<Plug>(MarkdownPlusListBackspace)",
      { desc = "Smart list backspace", buffer = true }
    )
    vim.keymap.set({ "n" }, "o", "<Plug>(MarkdownPlusNewListItemBelow)", { desc = "Add new list item", buffer = true })
    vim.keymap.set(
      { "n" },
      "O",
      "<Plug>(MarkdownPlusNewListItemAbove)",
      { desc = "Add new list item above", buffer = true }
    )
    vim.keymap.set(
      { "n" },
      "<leader>mc",
      "<Plug>(MarkdownPlusToggleCheckbox)",
      { desc = "Toggle checkbox", buffer = true }
    )
  end,
})

-- whichkey
require("which-key").setup({
  preset = "helix",
  expand = 2, -- if a group has 2 or fewer keymaps, show them all
})
require("which-key").add({
  { "gr", group = "LSP" },
  -- { "<leader>d", group = "Delete" },
  { "<leader>f", group = "Find" },
  { "<leader>g", group = "Git" },
  -- { "<leader>t", group = "Terminal" },
  -- { "<leader>y", group = "Yazi" },
})

-- telescope, automatically loads noice extension
local telescope = require("telescope")
local telescope_builtins = require("telescope.builtin")
telescope.setup({
  defaults = {
    dynamic_preview_title = true, -- for neoclip
    path_display = { "smart" },
    file_previewer = require("telescope.previewers").cat.new,
    grep_previewer = require("telescope.previewers").vimgrep.new,
    qflist_previewer = require("telescope.previewers").qflist.new,
    mappings = {
      n = {
        ["q"] = require("telescope.actions").close,
        ["<leader>"] = require("telescope.actions").which_key,
      },
    },
  },
})
telescope.load_extension("fzf")
telescope.load_extension("ui-select")

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
  telescope_builtins.find_files(opts)
end
local function live_grep_from_project_git_root()
  local opts = {}
  if is_git_repo() then
    opts = { cwd = get_git_root() }
  end
  telescope_builtins.live_grep(opts)
end
vim.keymap.set({ "n" }, "<leader>ff", vim.find_files_from_project_git_root, { desc = "Telescope files" })
vim.keymap.set({ "n" }, "<leader>fb", telescope_builtins.buffers, { desc = "Open buffers" })
vim.keymap.set({ "n" }, "<leader>fs", live_grep_from_project_git_root, { desc = "Find in folder" })
vim.keymap.set({ "n", "i" }, "<F12>", "<cmd>Telescope lsp_definitions theme=cursor<cr>", { desc = "Go to definition" })
vim.keymap.set({ "n", "i" }, "<S-F12>", "<cmd>Telescope lsp_references theme=cursor<cr>", { desc = "Go to references" })
vim.keymap.set({ "n" }, "<leader>fm", "<cmd>Telescope marks theme=dropdown<cr>", { desc = "Marks" })

-- yank ring (clipboard history)
local function is_whitespace(line)
  local trimmed = vim.trim(line)
  return string.len(trimmed) > 0
end
require("neoclip").setup({
  history = 50,
  enable_persistent_history = true,
  preview = true, -- show the type of paste in the telescope title (char/line wise)
  dedent_picker_display = true,
  filter = function(data)
    local lines = vim.tbl_values(data.event.regcontents)
    local all_whitespace = vim.iter(lines):all(is_whitespace)
    return all_whitespace
  end,
  keys = {
    telescope = {
      i = {
        select = {},
        paste = { "<cr>", "<c-l>" },
        paste_behind = "<c-h>",
        replay = {}, -- replay macros
        delete = "<c-d>",
        edit = "<c-e>",
      },
      n = {
        select = {},
        paste = { "<cr>", "p" },
        paste_behind = "P",
        replay = {}, -- replay macros
        delete = "d",
        edit = "e",
      },
    },
  },
})
vim.keymap.set("n", "<leader>p", "<cmd>Telescope neoclip theme=cursor<cr>", { desc = "Yank history" })

-- terminals
vim.keymap.set({ "t" }, "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" }) -- causes problems w/ lazygit
require("toggleterm").setup()
local toggleterminal = require("toggleterm.terminal").Terminal
local shell = toggleterminal:new({ cmd = vim.o.shell })
local lazygit = toggleterminal:new({ cmd = "lazygit", dir = "git_dir", direction = "float", close_on_exit = true })
vim.keymap.set({ "n" }, "<leader>tt", function()
  shell:toggle()
end, { desc = "Open terminal" })
vim.keymap.set({ "n" }, "<leader>gg", function()
  lazygit:toggle()
end, { desc = "Open lazygit" })

-- yazi integration
-- local yazi = require("yazi")
vim.keymap.set({ "n" }, "<leader>yy", "<cmd>Yazi<cr>", { desc = "Open yazi" })
vim.g.loaded_netrwPlugin = 1 -- don't load native netrw
autocmd("UIEnter", {
  callback = function()
    require("yazi").setup({
      open_for_directories = true,
    })
  end,
})

-- swap wrapped and non-wrapped line movement
vim.keymap.set({ "n", "v" }, "j", "gj", { desc = "Move down one visual line" })
vim.keymap.set({ "n", "v" }, "gj", "j", { desc = "Move down one real line" })
vim.keymap.set({ "n", "v" }, "k", "gk", { desc = "Move up one visual line" })
vim.keymap.set({ "n", "v" }, "gk", "k", { desc = "Move up one real line" })

-- save with ctrl s
vim.keymap.set({ "n", "i" }, "<C-s>", "<cmd>:w<cr>")

-- comment with ctrl /
require("ts_context_commentstring").setup({
  enable_autocmd = false,
})
require("Comment").setup({
  pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
})
local toggle_comment = require("Comment.api").toggle.linewise.current
vim.keymap.set("n", "<C-_>", toggle_comment, { desc = "Toggle comment", remap = true })
vim.keymap.set("i", "<C-_>", toggle_comment, { desc = "Toggle comment" })

-- "tab" between buffers
vim.keymap.set({ "n", "i" }, "<leader><TAB>", "<cmd>:bn<cr>", { desc = "Go to next buffer" })
vim.keymap.set({ "n", "i" }, "<leader><S-TAB>", "<cmd>:bp<cr>", { desc = "Go to previous buffer" })

-- completion
local cmp = require("cmp")
local insert_completion_mapping = cmp.mapping.preset.insert({
  ["<C-Space>"] = cmp.mapping.complete(), -- open menu if not already there
  ["<CR>"] = cmp.mapping.confirm({ select = true }), -- accept first option/selected option
  ["<Down>"] = cmp.mapping.select_next_item(),
  ["<Up>"] = cmp.mapping.select_prev_item(),
  ["<C-n>"] = cmp.mapping.select_next_item(),
  ["<C-p>"] = cmp.mapping.select_prev_item(),
  -- <C-y>: accept selected option
  -- <C-e>: close menu
})
local cmdline_completion_mapping = cmp.mapping.preset.cmdline({
  ["<C-z>"] = cmp.config.disable,
  ["<Tab>"] = cmp.config.disable, -- if i disable this (and shift-tab) they now open the native menu I think?
  ["<S-Tab>"] = cmp.config.disable,
  -- keep the C-n and C-p mappings and C-e to close
  ["<C-y>"] = { c = cmp.mapping.confirm({ select = true }) }, -- same as insert mode <cr>
  ["<cr>"] = { c = cmp.mapping.confirm({ select = false }) }, -- NOT same as insert mode
})

vim.g.test_icon = require("nvim-web-devicons").get_icon("nf-oct-code")
vim.g.utf_icon = "\\uf44f"
local kind_icons = {
  Text = "",
  Method = "󰆧",
  Function = "󰊕",
  Constructor = "",
  Field = "󰇽",
  Variable = "󰂡",
  Class = "󰠱",
  Interface = "",
  Module = "",
  Property = "󰜢",
  Unit = "",
  Value = "󰎠",
  Enum = "",
  Keyword = "󰌋",
  Snippet = "",
  Color = "󰏘",
  File = "󰈙",
  Reference = "",
  Folder = "󰉋",
  EnumMember = "",
  Constant = "󰏿",
  Struct = "",
  Event = "",
  Operator = "󰆕",
  TypeParameter = "󰅲",
}
cmp.setup({
  snippet = {
    expand = function(args)
      vim.snippet.expand(args.body)
    end,
  },
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "nvim_lua" },
    { name = "buffer" },
  }),
  formatting = {
    format = function(entry, vim_item)
      -- concatenate icon with type
      vim_item.kind = string.format("%s %s", kind_icons[vim_item.kind], vim_item.kind)
      -- Source
      vim_item.menu = ({
        buffer = "[Buffer]",
        nvim_lsp = "[LSP]",
        luasnip = "[LuaSnip]",
        nvim_lua = "[Lua]",
        latex_symbols = "[LaTeX]",
      })[entry.source.name]
      return vim_item
    end,
  },
  window = {
    completion = cmp.config.window.bordered(),
  },
  mapping = insert_completion_mapping,
})
require("nvim-autopairs").setup()
cmp.event:on("confirm_done", require("nvim-autopairs.completion.cmp").on_confirm_done()) -- add brackets after fn names

cmp.setup.cmdline(":", {
  mapping = cmdline_completion_mapping,
  sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline" } }),
  matching = { disallow_symbol_nonprefix_matching = false },
})
cmp.setup.cmdline({ "/", "?" }, {
  -- Use buffer source for '/' and '?' searches
  mapping = cmdline_completion_mapping,
  sources = { { name = "buffer" } },
})

-- formatting
local conform = require("conform")
conform.setup({
  formatters = {
    isort = { append_args = { "--profile", "black" } },
    stylua = { append_args = { "--indent-type", "Spaces", "--indent-width", "2" } },
    prettier = {
      args = function(self, ctx)
        if vim.endswith(ctx.filename, ".astro") then
          return { "--stdin-filepath", "$FILENAME", "--plugin", vim.g.prettier_plugin_astro }
        end
        return { "--stdin-filepath", "$FILENAME" }
      end,
    },
  },
  formatters_by_ft = {
    lua = { "stylua" },
    just = { "just" },
    json = { "fixjson" },
    docker = { "dockerfmt" },
    sh = { "shfmt" },
    yaml = { "yamlfmt" },
    nix = { "nixfmt" },
    python = { "isort", "black" },
    markdown = { "prettierd", "prettier", stop_after_first = true },
    -- mdx = { "prettierd", "prettier", stop_after_first = true },
    astro = { "prettier" },
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
vim.lsp.config("*", {
  capabilities = capabilities,
  root_markers = { "flake.nix", ".git" },
})
vim.lsp.config["astro_ls"] = {
  cmd = { "astro-ls", "--stdio" },
  filetypes = { "astro" },
  root_markers = { "package.json", "tsconfig.json", ".git" },
  init_options = { typescript = { tsdk = vim.g.tsdk } },
}
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
}
vim.lsp.config["bash_ls"] = {
  cmd = { "bash-language-server", "start" },
  filetypes = { "sh", "bash" },
  settings = { bashIde = { globPattern = "*@(.sh|.inc|.bash|.command)" } },
}
vim.lsp.config["nix_ls"] = {
  cmd = { "nixd", "--inlay-hints=true" },
  filetypes = { "nix" },
  root_markers = { "flake.nix", ".git" },
  settings = { nixd = {
    nixpkgs = { expr = vim.g.nixpkgs_expr },
  } },
}
vim.lsp.config["python_ls"] = {
  cmd = { "ruff" },
  filetypes = { "py" },
}
vim.lsp.config["css_ls"] = {
  filetypes = { "css", "scss" },
  cmd = { "vscode-css-language-server", "--stdio" },
  settings = {
    css = { validate = true },
    scss = { validate = true },
  },
}
vim.lsp.config["ts_ls"] = {
  cmd = { "typescript-language-server", "--stdio" },
  filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
  init_options = { hostInfo = "neovim" },
  root_markers = { "package.json", "tsconfig.json", ".git" },
}
vim.lsp.config["mdx_ls"] = {
  cmd = { "mdx-language-server", "--stdio" },
  filetypes = { "mdx" },
  root_markers = { "package.json", ".git" },
  init_options = {
    typescript = { enabled = true, tsdk = vim.g.tsdk },
  },
}

-- restore cursor position when opening a file
autocmd("BufReadPost", {
  pattern = "*",
  callback = function()
    local skipFileTypes = { "commit", "help" }
    local line = vim.fn.line("'\"")
    if
      line > 1
      and line <= vim.fn.line("$")
      and not vim.list_contains({ skipFileTypes, vim.bo.filetype })
      and vim.fn.line("$") < 2000
    then
      vim.cmd('normal! g`"')
      vim.notify("Restored cursor to line " .. line)
    end
  end,
})

local function start_lsp()
  vim.lsp.enable({ "lua_ls", "nix_ls", "python_ls", "css_ls", "astro_ls", "ts_ls", "mdx_ls", "bash_ls" })
end

start_lsp()
vim.keymap.set({ "n" }, "grs", start_lsp, { desc = "Start LSP servers" })
vim.keymap.set({ "n" }, "gr", function()
  start_lsp()
  require("which-key").show({ keys = "gr" })
end, { desc = "Start LSP servers" })
vim.keymap.set("n", "grh", vim.lsp.buf.hover, { desc = "Show LSP hover information" })
vim.keymap.set("n", "grd", function()
  vim.diagnostic.setqflist({ open = false })
  telescope_builtins.quickfix()
end, { desc = "Send diagnostics to the quickfix list" })
vim.keymap.set("n", "<F2>", vim.lsp.buf.rename, { desc = "Rename symbol" })

-- Descriptions for defaults
vim.keymap.set({ "n", "v" }, "gra", vim.lsp.buf.code_action, { desc = "View available code actions in telescope" })
vim.keymap.set("n", "gri", vim.lsp.buf.implementation, { desc = "Send implementations to QF" })
vim.keymap.del("n", "grn") -- rename
vim.keymap.set("n", "grr", vim.lsp.buf.references, { desc = "Send references to QF" })
vim.keymap.del("n", "grt") -- jump to definition of type of current object
vim.keymap.set("n", "grx", vim.lsp.codelens.run, { desc = "Run codelens" })
vim.keymap.del("n", "gO") -- list all symbols in document in the loc list

-- if in certain buffer types, activate otter
autocmd("FileType", {
  pattern = { "md", "mdx", "just", "tex", "nix" },
  callback = require("otter").activate,
})

-- treesitter stuff
autocmd({ "BufEnter", "BufWinEnter" }, {
  callback = function()
    local ok, parsers = pcall(require, "nvim-treesitter.parsers")
    if ok and parsers.has_parser() then
      -- vim.cmd("colorscheme miniautumn") -- for some reason the easiest way to tell if this works

      -- syntax highlighting
      vim.treesitter.start()
      -- folds
      vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
      vim.wo[0][0].foldmethod = "expr"
      -- indentation (from nvim-treesitter plugin)
      vim.bo.indentexpr = "v:lua.require('nvim-treesitter').indentexpr()"

      -- treesitter related plugins
      require("nvim-ts-autotag").setup({ aliases = { ["mdx"] = "html" } })

      vim.keymap.set({ "x", "o" }, "af", "<cmd>TSTextobjectSelect @function.outer<cr>", { desc = "Function" })
      vim.keymap.set({ "x", "o" }, "if", "<cmd>TSTextobjectSelect @function.inner<cr>", { desc = "Function" })
      vim.keymap.set(
        { "n", "x", "o" },
        "[f",
        "<cmd>TSTextobjectGotoPreviousStart @function.outer<cr>",
        { desc = "Go to start of previous function" }
      )
      vim.keymap.set(
        { "n", "x", "o" },
        "]f",
        "<cmd>TSTextobjectGotoNextStart @function.outer<cr>",
        { desc = "Go to start of next function" }
      )
    end
  end,
})

-- create directories when saving files (allow creating the file /nonexistent/parents/get/created.txt)
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function()
    local file_path = vim.fn.expand("<afile>:p:h")
    if vim.fn.isdirectory(file_path) == 0 then
      vim.fn.mkdir(file_path, "p")
    end
  end,
})
