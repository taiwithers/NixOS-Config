local autocmd = vim.api.nvim_create_autocmd -- Create autocommand

-- <leader>/<localleader> keys
vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("options")
require("nix-paths")

if io.open("wsl-clipboard") then
  require("wsl-clipboard")
end

----------------------------------------------------------------------
--                            Filetypes                             --
----------------------------------------------------------------------

vim.filetype.add({
  extension = { mdx = "mdx", jinja = "jinja" },
  pattern = {
    [".*/%.github[%w/]+workflows[%w/]+.*%.ya?ml"] = "yaml.github",
  },
})

----------------------------------------------------------------------
--                             autocmds                             --
----------------------------------------------------------------------

-- highlight yanked text
autocmd("TextYankPost", {
  callback = function()
    vim.hl.on_yank({ timeout = 400 })
  end,
})

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

-- create directories when saving files (allow creating the file /nonexistent/parents/get/created.txt)
autocmd("BufWritePre", {
  pattern = "*",
  callback = function()
    local file_path = vim.fn.expand("<afile>:p:h")
    if vim.fn.isdirectory(file_path) == 0 then
      vim.fn.mkdir(file_path, "p")
    end
  end,
})

-- activate spellcheck in certain filetypes
-- maybe change this so I can also activate/deactivate with a command or keybind
autocmd("FileType", {
  pattern = { "markdown", "mdx", "plaintex", "text", "gitcommit", "rst" },
  callback = function()
    vim.opt_local.spell = true
    -- I  don't care about these types of issues
    vim.cmd("highlight clear  SpellRare")
    vim.cmd("highlight clear  SpellLocal")
  end,
})

-- close neovim if the only open window is the quickfix list
autocmd("BufEnter", {
  pattern = { "*" },
  callback = function()
    if (vim.bo.filetype == "qf") and (#vim.api.nvim_list_wins() == 1) then
      vim.cmd("quit")
    end
  end,
})

----------------------------------------------------------------------
--                             Keymaps                              --
--                       (not plugin related)                       --
----------------------------------------------------------------------

-- remove some defaults (more removed elsewhere, in LSP and whichkey)
vim.keymap.del("n", "[A") -- first file
vim.keymap.del("n", "]A") -- last file
vim.keymap.del("n", "]a") -- next file
vim.keymap.del("n", "[a") -- previous file
vim.keymap.del("n", "[B") -- first buffer
vim.keymap.del("n", "]B") -- last buffer
vim.keymap.del("n", "]b") -- next buffer
vim.keymap.del("n", "[b") -- previous buffer
vim.keymap.del("n", "]<C-l>") -- first item in next file in location list
vim.keymap.del("n", "[<C-l>") -- first item in prev file in location list
vim.keymap.del("n", "]<C-q>") -- first item in next file in QF
vim.keymap.del("n", "[<C-q>") -- first item in prev file in QF
vim.keymap.del("n", "]<C-t>") -- next tag in new window
vim.keymap.del("n", "[<C-t>") -- previous tag in new window
vim.keymap.del("n", "[L") -- first item in location list
vim.keymap.del("n", "]L") -- last item in location list
vim.keymap.del("n", "[Q") -- first item in QF
vim.keymap.del("n", "]Q") -- last item in QF
vim.keymap.del("n", "]T") -- first tag
vim.keymap.del("n", "[T") -- last tag
vim.keymap.del("n", "]t") -- next tag
vim.keymap.del("n", "[t") -- previous tag
vim.keymap.del("n", "&") -- repeat last `:s`

-- save with ctrl s
vim.keymap.set({ "n", "i" }, "<C-s>", "<cmd>:w<cr>", { desc = ":w" })

-- "tab" between buffers
vim.keymap.set({ "n", "i" }, "<leader><TAB>", "<cmd>:bn<cr>", { desc = "Go to next buffer" })
vim.keymap.set({ "n", "i" }, "<leader><S-TAB>", "<cmd>:bp<cr>", { desc = "Go to previous buffer" })

-- duplicate line, comment out original
vim.keymap.set("n", "gyy", "yy<cmd>normal gcc<CR>p", { noremap = true, desc = "Duplicate line and comment original" })
local function duplicate_and_comment()
  -- Exit visual mode
  local esc = vim.api.nvim_replace_termcodes("<Esc>", true, false, true)
  vim.api.nvim_feedkeys(esc, "x", false)

  -- Get selection range
  local start_line = vim.fn.line("'<")
  local end_line = vim.fn.line("'>")

  -- Yank and paste below
  vim.cmd(start_line .. "," .. end_line .. "yank")
  vim.cmd((end_line + 1) .. "put")

  vim.api.nvim_feedkeys("gv", "n", false) -- Reselect pasted block
  vim.api.nvim_feedkeys("gc", "v", false) -- Comment the original selection
end
vim.keymap.set("v", "gy", duplicate_and_comment, { noremap = true, desc = "Duplicate selection and comment original" })

-- emacs binds on command line
vim.keymap.set("c", "<C-a>", "<Home>")
vim.keymap.set("c", "<C-e>", "<End>")

-- show/hide special windows
vim.keymap.set("n", "<leader>wq", function()
  -- stolen from lazyvim (config/keymaps.lua)
  local success, err = pcall(vim.fn.getqflist({ winid = 0 }).winid ~= 0 and vim.cmd.cclose or vim.cmd.copen)
  if not success and err then
    vim.notify(err, vim.log.levels.ERROR)
  end
end, { desc = "Toggle QF" })
vim.keymap.set("n", "<leader>wh", "<cmd>:helpclose<cr>", { desc = "`:helpclose`" })

-- make direction of n/N absolute (not relative to whether /? was used)
vim.keymap.set("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next Search Result" })
vim.keymap.set({ "x", "o" }, "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
vim.keymap.set("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev Search Result" })
vim.keymap.set({ "x", "o" }, "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })

-- don't un-select when >'ing lines
vim.keymap.set("x", "<", "<gv", { desc = "Dedent" })
vim.keymap.set("x", ">", ">gv", { desc = "Indent" })

-- text wrapping
vim.keymap.set("v", "<leader>r", ":!fmt -w80<cr>", { desc = "Wrap selection to 80 characters" })
vim.keymap.set("n", "<leader>R", "<C-v>:!fmt -w80<cr>", { desc = "Wrap line to 80 characters" })

-- jump through snippet regions like the completion list
vim.keymap.set({ "i", "s" }, "<c-n>", function()
  return vim.snippet.active({ direction = 1 }) and vim.snippet.jump(1)
end, { desc = "Jump to next snippet region" })
vim.keymap.set({ "i", "s" }, "<c-p>", function()
  return vim.snippet.active({ direction = -1 }) and vim.snippet.jump(-1)
end, { desc = "Jump to previous snippet region" })

----------------------------------------------------------------------
--                         General Plugins                          --
----------------------------------------------------------------------
local mini_icons = require("mini.icons")
mini_icons.setup()
mini_icons.mock_nvim_web_devicons() -- required until lualine supports mini.icons

-- statuscolumn git indicators
local gitsigns_symbols = {
  add = { text = "+" },
  change = { text = "~" },
  delete = { text = "-" },
  topdelete = { text = "^" }, -- first line(s) of file was deleted
  changedelete = { text = "&" }, -- first line(s) of file was deleted, AND this line was changed
  untracked = { text = "┆" },
}
require("gitsigns").setup({
  sign_priority = 1000, -- don't overlap marks
  preview_config = { title = "Git Blame" },
  signs = gitsigns_symbols,
  signs_staged = gitsigns_symbols,
})
vim.keymap.set({ "n" }, "<leader>gb", function()
  require("gitsigns").blame_line({ ignore_whitespace = true, full = true })
end, { desc = "View Git blame for current line" })

-- close buffers without changing window layout
require("mini.bufremove").setup()
vim.keymap.set({ "n" }, "<leader>dd", "<cmd>lua MiniBufremove.delete()<cr>", { desc = "Close buffer" })

-- flash - fFtT motions and labelled search results
-- repeat fFtT motions with fFtT (as well as , ;)
-- fFtT travel across lines
require("flash").setup({
  labels = "aeichtsnuoybldwvkjxgrmfp", -- ordered by accessibility on based on keyboard layout
  search = { multi_window = false },
  label = { uppercase = false, min_pattern_length = 2 },
  modes = { search = { enabled = true } }, -- three-character jumps during /? searches
})

-- whichkey
require("which-key").setup({
  preset = "helix",
  expand = 2,
  plugins = { spelling = { suggestions = 8 } },
})
require("which-key").add({
  { "gr", group = "LSP" },
  { "<leader>f", group = "Find" },
  { "<leader>g", group = "Git" },
  { "<leader>w", group = "Special [W]indows" },
  { "zA", "<nop>", hidden = true },
  { "zb", "<nop>", hidden = true },
  { "zc", "<nop>", hidden = true },
  { "zC", "<nop>", hidden = true },
  { "zd", "<nop>", hidden = true },
  { "zD", "<nop>", hidden = true },
  { "ze", "<nop>", hidden = true },
  { "zE", "<nop>", hidden = true },
  { "zf", "<nop>", hidden = true },
  { "zH", "<nop>", hidden = true },
  { "zL", "<nop>", hidden = true },
  { "zo", "<nop>", hidden = true },
  { "zs", "<nop>", hidden = true },
  { "zt", "<nop>", hidden = true },
  { "zv", "<nop>", hidden = true },
  { "zx", "<nop>", hidden = true },
  { "z<cr>", "<nop>", hidden = true },
  { "<Plug>(fzf-normal)", "<nop>", hidden = true }, -- clogs whichkey
  { "[/", "<nop>", hidden = true }, -- jumping to C comments
  { "]/", "<nop>", hidden = true }, -- jumping to C comments
  { "gh", "<nop>", hidden = true }, -- enter select mode (: h Select-mode)
  { "gH", "<nop>", hidden = true }, -- enter select mode (: h Select-mode)
  { "g<C-h>", "<nop>", hidden = true }, -- enter select mode (: h Select-mode)
  { "gq", "<nop>", hidden = true, mode = { "n", "v" } }, -- operator to format text
  { "gw", "<nop>", hidden = true, mode = { "n", "v" } }, -- operator to format text
  { "K", "<nop>", hidden = true }, -- nvim creates this on LspAttach
})
vim.keymap.set("n", "<leader>H", require("which-key").show, { desc = "Open which-key" })

-- telescope
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
local function telescope_cursor(opts)
  return require("telescope.themes").get_cursor(opts)
end
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
vim.keymap.set({ "n" }, "<leader>fq", telescope_builtins.quickfix, { desc = "Open quickfix" })
vim.keymap.set({ "n" }, "<leader>fs", live_grep_from_project_git_root, { desc = "Find in folder" })
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
vim.keymap.set("n", "<leader>p", function()
  telescope.extensions.neoclip.default(telescope_cursor({ layout_config = { height = 15 } }))
end, { desc = "Yank history" })

-- terminals
require("toggleterm").setup()
local toggleterminal = require("toggleterm.terminal").Terminal
local shell = toggleterminal:new({ cmd = vim.o.shell })
local lazygit = toggleterminal:new({ cmd = "lazygit", dir = "git_dir", direction = "float", close_on_exit = true })
vim.keymap.set({ "t" }, "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" }) -- causes problems w/ lazygit
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

----------------------------------------------------------------------
--                        Aesthetic Plugins                         --
----------------------------------------------------------------------

require("range-highlight").setup() -- highlight visual selection in cmdline
require("highlight-undo").setup() -- highlight text affected by "undo"
vim.cmd("packadd nohlsearch")

require("marks").setup() -- show marks on the left
-- not working w/ whichkey is known issue https://github.com/chentoast/marks.nvim/issues/113

require("mini.indentscope").setup({
  draw = { animation = require("mini.indentscope").gen_animation.none() },
})
vim.api.nvim_set_hl(0, "MiniIndentscopeSymbol", { fg = "#555555" })
vim.api.nvim_set_hl(0, "FoldColumn", { fg = "#CCCCCC" })

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
require("notify").setup({
  render = "wrapped-default",
  max_width = 60,
  minimum_width = 30,
})

local mode_colours = {
  normal = { primary = "#303030", contrast = "#eeeeee" },
  insert = { primary = "#9affff", contrast = "#303030" }, -- lualine auto uses this for visual mode
  visual = { primary = "#ae81ff", contrast = "#303030" },
  copy = { primary = "#fce094", contrast = "#303030" }, -- `IncSearch` highlight colour, used for TextYankPost
  delete = { primary = "#ff5189", contrast = "#303030" }, -- lualine moonfly replace colour
  command = { primary = "#245361", contrast = "#eeeeee" }, -- modes.nvim replace colour
}

-- colour line highlight based on current mode
require("modes").setup({
  colors = {
    copy = mode_colours.copy.primary,
    delete = mode_colours.delete.primary,
    format = mode_colours.visual.primary,
    insert = mode_colours.insert.primary,
    replace = mode_colours.delete.primary,
    visual = mode_colours.visual.primary,
  },
})

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

local function make_lualine_mode(colour_table, inactive)
  local gui = inactive and "nocombine" or "bold" -- slightly odd ternary assignment
  -- making "inactive" not bold gives differentiation in normal mode tabline buffers
  return {
    a = { bg = colour_table.primary, fg = colour_table.contrast, gui = gui },
    b = { bg = mode_colours.normal.primary, fg = "#aaaaaa" },
    c = { bg = mode_colours.normal.primary, fg = mode_colours.normal.contrast },
  }
end
require("nvim-navic").setup({ -- breadcrumbs provider
  lsp = {
    auto_attach = true,
    preference = { "basedpyright" }, -- use bpy over jinja
  },
})
require("lualine").setup({
  options = {
    theme = {
      command = make_lualine_mode(mode_colours.command),
      inactive = make_lualine_mode(mode_colours.normal, true),
      insert = make_lualine_mode(mode_colours.insert),
      normal = make_lualine_mode(mode_colours.normal),
      replace = make_lualine_mode(mode_colours.delete),
      terminal = make_lualine_mode(mode_colours.command),
      visual = make_lualine_mode(mode_colours.visual),
    },
    component_separators = { left = "", right = "" },
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
  winbar = {
    lualine_c = { { "navic", navic_opts = { click = true } } },
  },
  inactive_winbar = {
    lualine_c = { { "navic", navic_opts = { click = true } } },
  },
})

require("quicker").setup({
  opts = { number = true }, -- nvim options to set in the qf window
  keys = {
    { ">", require("quicker").toggle_expand, desc = "Toggle context lines" },
  }, -- keymaps for qf window only
  edit = { enabled = false },
  trim_leading_whitespace = "all",
})

----------------------------------------------------------------------
--                    Code/Text Editing Plugins                     --
----------------------------------------------------------------------

require("nvim-surround").setup() -- tpope-style surround

-- comment with ctrl /
require("Comment.ft").set("mdx", { "{/*%s*/}", "{/**%s**/}" })
require("Comment.ft").set("jinja", require("Comment.ft").get("html"))
local toggle_comment = require("Comment.api").toggle.linewise.current
vim.keymap.set("n", "<C-_>", toggle_comment, { desc = "Toggle comment", remap = true })
vim.keymap.set("i", "<C-_>", toggle_comment, { desc = "Toggle comment" })

-- fix commenting in react files
require("ts_context_commentstring").setup({
  enable_autocmd = false,
})
require("Comment").setup({
  pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
})

-- create boxed comments
require("nvim-comment-frame").setup({
  disable_default_keymap = true,
  keymap = "",
  multiline_keymap = "",
})
vim.keymap.set("n", "<leader>c", require("nvim-comment-frame").add_multiline_comment, { desc = "Create boxed comment" })

-- markdown
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
  filetypes = { "markdown", "mdx" },
})

autocmd({ "BufEnter", "BufWinEnter" }, {
  -- set keybindings for markdown plus
  pattern = { "*.md", "*.mdx" },
  callback = function()
    local function keyset(modes, lhs, rhs, desc)
      vim.keymap.set(modes, lhs, rhs, { desc = desc, buffer = true })
    end

    -- code blocks
    keyset("n", "<leader>C", "<Plug>(MarkdownPlusCodeBlockInsert)", "Insert code block")

    -- navigation
    keyset("n", "gn", "<Plug>(MarkdownPlusNextHeader)", "Go to next header")
    keyset({ "n" }, "gp", "<Plug>(MarkdownPlusPrevHeader)", "Go to previous header")

    -- tables
    keyset("n", "<leader>mt", function()
      -- open a telescope picker for the more specific table functions
      require("markdown-plus-telescope").table_commands(require("telescope.themes").get_dropdown())
    end, "Table commands")
    keyset({ "n", "i" }, "<c-l>", "<Plug>(MarkdownPlusTableNavRight)", "Move to right cell")
    keyset({ "n", "i" }, "<c-h>", "<Plug>(MarkdownPlusTableNavLeft)", "Move to left cell")
    keyset({ "n", "i" }, "<c-j>", "<Plug>(MarkdownPlusTableNavDown)", "Move to below cell")
    keyset({ "n", "i" }, "<c-k>", "<Plug>(MarkdownPlusTableNavUp)", "Move to above cell")

    -- lists
    keyset({ "i" }, "<cr>", "<Plug>(MarkdownPlusListEnter)", "Add new list item")
    keyset({ "i" }, "<s-cr>", "<Plug>(MarkdownPlusListShiftEnter)", "Continue list item on next line")
    keyset({ "i" }, "<tab>", "<Plug>(MarkdownPlusListIndent)", "Indent list item")
    keyset({ "i" }, "<s-tab>", "<Plug>(MarkdownPlusListOutdent)", "Outdent list item")
    keyset({ "i" }, "<bs>", "<Plug>(MarkdownPlusListBackspace)", "Smart list backspace")
    keyset({ "n" }, "o", "<Plug>(MarkdownPlusNewListItemBelow)", "Add new list item below")
    keyset({ "n" }, "O", "<Plug>(MarkdownPlusNewListItemAbove)", "Add new list item above")
    keyset({ "n" }, "<leader>mc", "<Plug>(MarkdownPlusToggleCheckbox)", "Toggle checkbox")
  end,
})

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
  ["<Tab>"] = cmp.config.disable,
  ["<S-Tab>"] = cmp.config.disable,
  -- keep the C-n and C-p mappings and C-e to close
  ["<C-y>"] = { c = cmp.mapping.confirm({ select = true }) }, -- same as insert mode <cr>
  ["<C-e>"] = { c = cmp.mapping.disable }, -- conflicts w/ emacs-style <End>
  ["<cr>"] = { c = cmp.mapping.confirm({ select = false }) }, -- NOT same as insert mode
})
local global_snippets = {
  { trigger = "sheb", body = "#!/usr/bin/env $0" },
  {
    trigger = "lipsum",
    body = "Lorem ipsum dolor sit amet, officia excepteur ex fugiat reprehenderit enim labore culpa sint ad nisi Lorem pariatur mollit ex esse exercitation amet. Nisi anim cupidatat excepteur officia. Reprehenderit nostrud nostrud ipsum Lorem est aliquip amet voluptate voluptate dolor minim nulla est proident. Nostrud officia pariatur ut officia. Sit irure elit esse ea nulla sunt ex occaecat reprehenderit commodo officia dolor Lorem duis laboris cupidatat officia voluptate. Culpa proident adipisicing id nulla nisi laboris ex in Lorem sunt duis officia eiusmod. Aliqua reprehenderit commodo ex non excepteur duis sunt velit enim. Voluptate laboris sint cupidatat ullamco ut ea consectetur et est culpa et culpa duis.",
  },
}
local custom_snippets = {
  { ft = { "python" }, trigger = "def", body = "def ${1:name}(${2:args})->None:\n\t$0" },
  { ft = { "python" }, trigger = "main", body = "def main()->None:\n\t$0" },
  { ft = { "python" }, trigger = "ifmain", body = 'if __name__ == "__main__":\n\t${1:main()}' },
  { ft = { "python" }, trigger = "match", body = "match ${1:test}:\n\tcase ${2:result}:\n\t\t$0" },
  {
    ft = { "html", "jinja", "astro" },
    trigger = "doctype",
    body = '<!doctype html>\n<html lang="en">\n\t<head>\n\t\t<meta charset="UTF-8">\n\t\t<meta name="viewport" content="width=device-width, initial-scale=1.0">\nzt\t<title>${1:Document}</title>\n\t</head>\n\t<body>\n\t\t$0\n\t</body>\n</html>',
  },
  {
    ft = { "css", "scss", "astro" },
    trigger = "media",
    body = "@media screen and (${1:max-width: 300px}) {\n\t$0\n}",
  },
  {
    ft = { "lua" },
    trigger = "keymap",
    body = 'vim.keymap.set({"${1:n}"}, "${2:<leader>}", ${3:rhs}, { desc = "${4:description}" })',
  },
}

-- https://www.reddit.com/r/neovim/comments/1cxfhom/builtin_snippets_so_good_i_removed_luasnip/
local function get_buf_snips()
  local ft = vim.bo.filetype
  local snips = vim.list_slice(global_snippets)
  for _, snippet in ipairs(custom_snippets) do
    if ft and vim.list_contains(snippet.ft, ft) then
      vim.list_extend(snips, { snippet })
    end
  end
  return snips
end
local function register_cmp_snippets()
  local cmp_source = {}
  local cache = {}
  function cmp_source.complete(_, _, callback)
    local bufnr = vim.api.nvim_get_current_buf()
    if not cache[bufnr] then
      local completion_items = vim.tbl_map(function(s)
        local item = {
          word = s.trigger,
          label = s.trigger,
          kind = vim.lsp.protocol.CompletionItemKind.Snippet,
          insertText = s.body,
          insertTextFormat = vim.lsp.protocol.InsertTextFormat.Snippet,
        }
        return item
      end, get_buf_snips())

      cache[bufnr] = completion_items
    end

    callback(cache[bufnr])
  end

  require("cmp").register_source("custom_snippets", cmp_source)
end
register_cmp_snippets()
cmp.setup({
  snippet = {
    expand = function(args)
      vim.snippet.expand(args.body)
    end,
  },
  sources = cmp.config.sources({
    { name = "custom_snippets" },
    { name = "nvim_lsp" },
    { name = "nvim_lua" },
    { name = "buffer" },
    { name = "path" }, -- useful for markdown links etc
    { name = "scss", option = { folders = { "src/styles" } } },
  }),
  window = { completion = cmp.config.window.bordered() },
  mapping = insert_completion_mapping,
  formatting = {
    format = function(entry, vim_item)
      -- concatenate icon with type
      local icon, hl, _ = MiniIcons.get("lsp", vim_item.kind)
      vim_item.kind = string.format("%s %s", icon, vim_item.kind)
      vim_item.kind_hl_group = hl
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
  sorting = {
    comparators = {
      cmp.config.compare.offset, -- smaller offset -> higher ranking
      cmp.config.compare.exact, -- exact matches ?
      cmp.config.compare.scopes, -- locals above globals
      cmp.config.compare.score, -- higher score ??
      function(entry1, entry2)
        -- sort items starting w/ __ later in the list
        -- https://github.com/lukas-reineke/cmp-under-comparator/blob/master/lua/cmp-under-comparator/init.lua
        local _, entry1_under = entry1.completion_item.label:find("^_+")
        local _, entry2_under = entry2.completion_item.label:find("^_+")
        entry1_under = entry1_under or 0
        entry2_under = entry2_under or 0
        if entry1_under > entry2_under then
          return false
        elseif entry1_under < entry2_under then
          return true
        end
      end,
      cmp.config.compare.recently_used,
      cmp.config.compare.locality, -- used near cursor
      cmp.config.compare.kind, -- sort by LSP kind ?
      cmp.config.compare.sort_text, -- alphabetical
      cmp.config.compare.length, -- short items first
      cmp.config.compare.order, -- smaller id ??
    },
  },
})
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

require("nvim-autopairs").setup()
cmp.event:on("confirm_done", require("nvim-autopairs.completion.cmp").on_confirm_done()) -- add brackets after fn names

-- formatting
local conform = require("conform")
conform.setup({
  formatters = {
    black = {
      append_args = {
        "--target-version",
        "py311",
        "--target-version",
        "py312",
        "--target-version",
        "py313",
        "--target-version",
        "py314",
      },
    },
    isort = { append_args = { "--profile", "black" } },
    stylua = { append_args = { "--indent-type", "Spaces", "--indent-width", "2" } },
    prettier = {
      args = function(_, ctx)
        if vim.endswith(ctx.filename, ".astro") then
          return { "--stdin-filepath", "$FILENAME", "--plugin", vim.g.prettier_plugin_astro }
        elseif vim.endswith(ctx.filename, ".md") then
          return { "--stdin-filepath", "$FILENAME", "--tab-width", "4" }
        elseif vim.endswith(ctx.filename, ".jinja") then
          return { "--stdin-filepath", "$FILENAME", "--plugin", vim.g.prettier_plugin_jinja, "--print-width", "100" }
        end
        return { "--stdin-filepath", "$FILENAME" }
      end,
    },
    yamlfmt = {
      prepend_args = { "-formatter", "retain_line_breaks=true" },
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
    markdown = { "prettier" },
    -- mdx = { "prettierd", "prettier", stop_after_first = true },
    astro = { "prettier" },
    jinja = { "prettier" },
    javascript = { "prettierd", "prettier", stop_after_first = true },
    typescript = { "prettierd", "prettier", stop_after_first = true },
    typescriptreact = { "prettierd", "prettier", stop_after_first = true },
    html = { "prettierd", "prettier", stop_after_first = true },
    scss = { "prettierd", "prettier", stop_after_first = true },
    css = { "prettierd", "prettier", stop_after_first = true },
    toml = { "taplo" },
  },
  format_on_save = {
    lsp_format = "fallback",
    timeout_ms = 1500,
  },
})

----------------------------------------------------------------------
--                        LSP and Treesitter                        --
----------------------------------------------------------------------

-- show lsp diagnostics as virtual text at the end of the current line
vim.diagnostic.config({ virtual_text = { current_line = true }, underline = false })

-- show inlay hints (currently used by nixd for versions)
vim.lsp.inlay_hint.enable(true)

require("goto-preview").setup({
  width = 100,
  height = 12,
  border = { "↖", "─", "╮", "│", "╯", "─", "╰", "│" }, -- Border characters from lua/telescope/themes.lua
  focus_on_open = false,
  dismiss_on_move = true,
  vim_ui_input = true, -- pretty renaming window
  references = { telescope = telescope_cursor({ layout_config = { height = 20 } }) },
})
vim.keymap.set("n", "<F12>", require("goto-preview").goto_preview_definition, { desc = "Peek definition" })
vim.keymap.set("n", "<S-F12>", require("goto-preview").goto_preview_references, { desc = "Peek references" })

-- reference jumps
require("refjump").setup()

-- folds
require("ufo").setup()
vim.keymap.set("n", "z1", require("ufo").closeFoldsWith, { desc = "Fold level 1+" })
vim.keymap.set("n", "z2", function()
  require("ufo").closeFoldsWith(1)
end, { desc = "Fold level 2+" })

-- preview code actions
local preview_code_actions = require("actions-preview")
preview_code_actions.setup({
  diff = { ctxlen = 0 },
})
vim.keymap.set({ "n", "v" }, "gra", preview_code_actions.code_actions, { desc = "Preview available code actions" })

-- lsp
local capabilities = require("cmp_nvim_lsp").default_capabilities() -- from nvim-cmp
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.foldingRange = {
  dynamicRegistration = false,
  lineFoldingOnly = true,
}
vim.lsp.config("*", {
  capabilities = capabilities,
  root_markers = { "flake.nix", ".git" },
})

vim.lsp.config["astro-ls"] = {
  cmd = { "astro-ls", "--stdio" },
  filetypes = { "astro" },
  root_markers = { "package.json", "tsconfig.json", ".git" },
  init_options = { typescript = { tsdk = vim.g.tsdk } },
}
vim.lsp.config["lua-ls"] = {
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
vim.lsp.config["bash-ls"] = {
  cmd = { "bash-language-server", "start" },
  filetypes = { "sh", "bash" },
  settings = { bashIde = { globPattern = "*@(.sh|.inc|.bash|.command)" } },
}
vim.lsp.config["nixd"] = {
  cmd = { "nixd", "--inlay-hints=true" },
  filetypes = { "nix" },
  root_markers = { "flake.nix", ".git" },
  settings = { nixd = { nixpkgs = { expr = vim.g.nixpkgs_expr } } },
}
vim.lsp.config["ruff"] = {
  cmd = { "ruff", "server" },
  root_markers = { "pyproject.toml" },
  capabilities = {},
  init_options = {
    settings = {
      lineLength = 88,
      organizeImports = false, -- use isort
      configuration = {
        lint = {
          pycodestyle = { ["ignore-overlong-task-comments"] = true },
          pydocstyle = { convention = "numpy" },
        },
      },
      lint = {
        --  https://docs.astral.sh/ruff/rules
        select = {
          "ANN",
          "BLE",
          "A",
          "C4",
          "DTZ",
          "EXE",
          "FA",
          "ISC",
          "ICN",
          "PT",
          "SIM",
          "ARG",
          "PTH",
          "NPY",
          "N",
          "E",
          "W",
          "D",
          "DOC",
          "F",
          "PL",
          "UP",
          "RUF",
          "FIX",
        }, -- select rulesets, like "E", "F"
        ignore = {
          "ANN401", -- explicity Any
          "W293", -- blank line contains whitespace
          "W291", -- trailing whitespace
          "UP045", -- typing.Optional
          "D401", -- numpydoc "imperative mood"
          "D105", -- docstrings for dunder methods
          "PLC0415", -- import not at top level
          "RUF012", -- typing.ClassVar
        },
        future_annotations = true,
      },
      -- https://docs.astral.sh/ruff/editors/settings/#__tabbed_2_2
    },
  },
}

vim.lsp.config["basedpyright"] = {
  cmd = { "basedpyright-langserver", "--stdio" },
  filetypes = { "python" },
  root_markers = { "pyproject.toml", "setup.py", "requirements.txt" },
  on_init = function(client, _)
    -- disable things that ruff is doing
    -- keep completion, definition, documentHighlight, documentLink, documentSymbol, hover,  inlayHint, references, rename
    if client.server_capabilities then
      client.server_capabilities.codeActionProvider = false
      client.server_capabilities.diagnosticProvider = false
    end
  end,
  settings = {
    basedpyright = {
      disableOrganizeImports = true, -- using isort
      analysis = {
        ignore = { "*" },
        autoFormatStrings = true, -- template-string *should* do that
        inlayHints = { callArgumentNames = false, variableTypes = false },
      },
    },
    python = { pythonPath = vim.fn.exepath("python") }, -- needed for basedpyright, even when starting nvim in a conda env
  },
}
vim.lsp.config["css-ls"] = {
  filetypes = { "css", "scss" },
  cmd = { "vscode-css-language-server", "--stdio" },
  settings = { css = { validate = true }, scss = { validate = true } },
}
vim.lsp.config["ts-ls"] = {
  cmd = { "typescript-language-server", "--stdio" },
  filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
  init_options = { hostInfo = "neovim" },
  root_markers = { "package.json", "tsconfig.json", ".git" },
}
vim.lsp.config["mdx-ls"] = {
  cmd = { "mdx-language-server", "--stdio" },
  filetypes = { "mdx" },
  root_markers = { "package.json", ".git" },
  init_options = { typescript = { enabled = true, tsdk = vim.g.tsdk } },
}
vim.lsp.config["jinja-lsp"] = {
  filetypes = { "html.jinja", "python" },
  cmd = { "jinja-lsp" },
}
vim.lsp.config["gh-actions-ls"] = {
  cmd = { "gh-actions-language-server", "--stdio" },
  capabilities = { workspace = { didChangeWorkspaceFolders = { dynamicRegistration = true } } },
  filetypes = { "yaml.github" },
  init_options = {}, -- needs to be present https://github.com/neovim/nvim-lspconfig/pull/3713#issuecomment-2857394868
}

local function start_lsp()
  vim.lsp.enable({
    "lua-ls",
    "nixd",
    "basedpyright",
    "css-ls",
    "astro-ls",
    "ts-ls",
    "mdx-ls",
    "bash-ls",
    "ruff",
    "jinja-lsp",
    "gh-actions-ls",
  })
end
start_lsp()

vim.keymap.set({ "n" }, "grs", start_lsp, { desc = "Start LSP servers" })
vim.keymap.set({ "n" }, "gr", function()
  start_lsp()
  require("which-key").show({ keys = "gr" })
end, { desc = "Start LSP servers" })
vim.keymap.set("n", "grh", vim.lsp.buf.hover, { desc = "Show LSP hover information" })
vim.keymap.set("n", "grH", vim.diagnostic.open_float, { desc = "Show line diagnostic" })
vim.keymap.set("n", "grd", vim.diagnostic.setqflist, { desc = "Send diagnostics to QF" })
vim.keymap.set("n", "grtd", function()
  vim.diagnostic.setqflist({ open = false })
  telescope_builtins.quickfix()
end, { desc = "Send diagnostics to Telescope" })
vim.keymap.set("n", "<F2>", vim.lsp.buf.rename, { desc = "Rename symbol" })
vim.keymap.set({ "n", "i" }, "grD", "<cmd>Telescope lsp_definitions theme=cursor<cr>", { desc = "Jump to definition" })

-- Descriptions for defaults
vim.keymap.set("n", "gri", vim.lsp.buf.implementation, { desc = "Send implementations to QF" })
vim.keymap.set("n", "grr", vim.lsp.buf.references, { desc = "Send references to QF" })
vim.keymap.set("n", "grx", vim.lsp.codelens.run, { desc = "Run codelens" })
vim.keymap.del("n", "grt") -- jump to definition of type of current object
vim.keymap.del("n", "grn") -- rename
vim.keymap.del("n", "gO") -- list all symbols in document in the loc list
vim.keymap.del("n", "<C-w>d") -- open diagnostic in float
vim.keymap.del("n", "<C-w><C-d>") -- open diagnostic in float

-- if in certain buffer types, activate otter
autocmd("FileType", {
  pattern = { "markdown", "mdx", "just", "plaintex", "nix" },
  callback = require("otter").activate,
})

-- treesitter stuff
autocmd({ "BufEnter", "BufWinEnter" }, {
  callback = function()
    local ok, parsers = pcall(require, "nvim-treesitter.parsers")
    local ft_parts = vim.split(vim.bo.filetype, ".", { plain = true })
    local ts_filetype = ft_parts[#ft_parts] -- ft: html.jinja has ts parser 'jinja'
    if ok and parsers[ts_filetype] then
      -- vim.cmd("colorscheme miniautumn") -- for some reason the easiest way to tell if this works

      -- syntax highlighting
      vim.treesitter.start()
      if ts_filetype == "jinja" then
        vim.bo.syntax = "on" -- get both HTML (or other) AND jinja
      end

      -- folds are done with LSP and nvim-ufo

      -- indentation (from nvim-treesitter plugin)
      -- vim.bo.indentexpr = "v:lua.require('nvim-treesitter').indentexpr()"
      -- using `vim.o.smartindent = true` instead

      -- treesitter related plugins
      require("nvim-ts-autotag").setup({ aliases = { ["mdx"] = "html", ["jinja"] = "html" } })

      -- template/f-string conversion
      require("template-string").setup({
        filetypes = {
          "html",
          "typescript",
          "javascript",
          "typescriptreact",
          "javascriptreact",
          "python",
          "astro",
        },
        remove_template_string = true,
        restore_quotes = { normal = [["]] },
      })

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

-- https://github.com/danymat/neogen#default-cycling-support
require("neogen").setup({
  snippet_engine = "nvim",
  languages = { python = { template = { annotation_convention = "numpydoc" } } },
})
vim.keymap.set("n", "<leader>C", require("neogen").generate, { desc = "Generate docstring" })
