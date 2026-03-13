-- https://github.com/ntk148v/neovim-config/blob/master/lua/autocmds.lua
local autocmd = vim.api.nvim_create_autocmd -- Create autocommand

-- <leader> key. Defaults to `\`. Some people prefer space.
vim.g.mapleader = " "
-- vim.g.maplocalleader = ' '

require("options")

if io.open("wsl-clipboard") then
  require("wsl-clipboard")
end
require("nix-paths")

-- to add
-- breadcrumbs? nvim-navic
-- window picker
-- markdown list continuation and syntax highlighting
-- multi-file search/replace
-- add <cmd><cr> as a lua snippet

-- show lsp diagnostics as virtual text at the end of the current line
vim.diagnostic.config({ virtual_text = { current_line = true } })

-- show inlay hints (currently used by nixd for versions)
vim.lsp.inlay_hint.enable(true)

vim.filetype.add({
  extension = { mdx = "mdx" },
})

autocmd("TextYankPost", {
  -- highlight yanked text
  callback = function()
    vim.hl.on_yank({ timeout = 400 })
  end,
})

-- statuscolumn git indicators
require("gitsigns").setup({
  sign_priority = 1000, -- don't overlap marks
})

-- change the colour of the line highlight based on current mode
require("modes").setup()

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

require("mini.bufremove").setup()
vim.keymap.set({ "n" }, "<leader>dd", "<cmd>lua MiniBufremove.delete()<cr>", { desc = "Close buffer" })

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

-- configuration for the vimscript vim-table-mode plugin, which understands md and rst files, but not mdx
autocmd("filetype", {
  pattern = { "mdx" },
  callback = function()
    vim.g.table_mode_corner = "|"
  end,
})
-- unlikely to use tableize (convert from csv) and it uses <leader>tt which overwrites my terminal mapping
vim.g.table_mode_disable_tableize_mappings = 1

-- whichkey
require("which-key").setup({
  preset = "helix",
  expand = 2, -- if a group has 2 or fewer keymaps, show them all
})
require("which-key").add({
  -- { "<leader>d", group = "Delete" },
  { "<leader>f", group = "Find" },
  -- { "<leader>l", group = "LSP" },
  -- { "<leader>t", group = "Terminal" },
  -- { "<leader>y", group = "Yazi" },
  --
  -- better descriptions for table mode commands
  { "<leader>tm", "<cmd>TableModeToggle<cr>", desc = "Toggle table mode" },
})

-- telescope, automatically loads noice extension
local telescope = require("telescope")
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
local function live_grep_from_project_git_root()
  local opts = {}
  if is_git_repo() then
    opts = { cwd = get_git_root() }
  end
  require("telescope.builtin").live_grep(opts)
end
vim.keymap.set({ "n", "v" }, "<leader>ff", vim.find_files_from_project_git_root, { desc = "Telescope files" })
vim.keymap.set({ "n", "v" }, "<leader>fb", require("telescope.builtin").buffers, { desc = "Open buffers" })
vim.keymap.set({ "n", "v" }, "<leader>fs", live_grep_from_project_git_root, { desc = "Find in folder" })
vim.keymap.set(
  { "n", "v", "i" },
  "<F12>",
  "<cmd>Telescope lsp_definitions theme=cursor<cr>",
  { desc = "Go to definition" }
)
vim.keymap.set(
  { "n", "v", "i" },
  "<S-F12>",
  "<cmd>Telescope lsp_references theme=cursor<cr>",
  { desc = "Go to references" }
)
vim.keymap.set({ "n", "v" }, "<leader>fm", "<cmd>Telescope marks theme=dropdown<cr>", { desc = "Marks" })

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
vim.keymap.set("n", "<leader>p", "<cmd>Telescope neoclip theme=cursor<cr>")

-- terminals
vim.keymap.set({ "t" }, "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" }) -- causes problems w/ lazygit
require("toggleterm").setup()
local toggleterminal = require("toggleterm.terminal").Terminal
local shell = toggleterminal:new({ cmd = vim.o.shell })
local lazygit = toggleterminal:new({ cmd = "lazygit", dir = "git_dir", direction = "float", close_on_exit = true })
vim.keymap.set({ "n" }, "<leader>tt", function()
  shell:toggle()
end, { desc = "Open terminal" })
vim.keymap.set({ "n" }, "<leader>g", function()
  lazygit:toggle()
end, { desc = "Open lazygit" })

-- yazi integration
-- local yazi = require("yazi")
vim.keymap.set({ "n", "v" }, "<leader>yy", "<cmd>Yazi<cr>", { desc = "Open yazi" })
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
  mapping = completion_mapping,
})
-- cmp.setup.cmdline(":", {
--   -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
--   mapping = completion_mapping,
--   sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline" } }),
--   matching = { disallow_symbol_nonprefix_matching = false },
-- })
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

-- use the noice style for generic notifications?
-- vim.notify = require("notify").setup({
--   render = "wrapped-compact",
--   stages = "static",
--   top_down = false,
-- })

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

-- enable supported lsp functionality
-- diagnostics are now always shown when you're on a relevant line, so don't need to keymap
-- autocmd("LspAttach", {
--   callback = function(args)
--     local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
--   end,
-- })

local function start_lsp()
  vim.lsp.enable({ "lua_ls", "nix_ls", "python_ls", "css_ls", "astro_ls", "ts_ls", "mdx_ls", "bash_ls" })
end

start_lsp()
vim.keymap.set({ "n" }, "<leader>ls", start_lsp, { desc = "Start LSP servers" })

-- if in certain buffer types, activate otter
autocmd("FileType", {
  pattern = { "md", "mdx", "just", "tex", "nix" },
  callback = require("otter").activate,
})

-- treesitter stuff
autocmd("FileType", {
  pattern = { "lua", "nix", "python", "bash", "astro", "typescript", "tsx", "typescriptreact", "mdx" },
  callback = function()
    -- syntax highlighting
    vim.treesitter.start()
    -- folds
    vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
    vim.wo[0][0].foldmethod = "expr"
    -- indentation (from nvim-treesitter plugin)
    vim.bo.indentexpr = "v:lua.require('nvim-treesitter').indentexpr()"

    -- treesitter related plugins
    require("nvim-ts-autotag").setup()
  end,
})
