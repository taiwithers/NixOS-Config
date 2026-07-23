local M = {}

----------------------------------------------------------------------
--                         Git Repositories                         --
----------------------------------------------------------------------

function M.is_git_repo()
  vim.fn.system("git rev-parse --is-inside-work-tree")
  return vim.v.shell_error == 0
end

function M.get_git_root()
  local dot_git_path = vim.fn.finddir(".git", ".;")
  return vim.fn.fnamemodify(dot_git_path, ":h")
end

function M.get_spellfile()
  local spellfile_name = ".nvim-spellfile.utf-8.add"

  local cwd_spellfile = vim.fs.joinpath(vim.uv.cwd(), spellfile_name)
  if vim.uv.fs_stat(cwd_spellfile) then
    return vim.fs.abspath(cwd_spellfile)
  elseif u.is_git_repo() then
    local git_spellfile = vim.fs.joinpath(u.get_git_root(), spellfile_name)
    local git_parent_spellfile = vim.fs.joinpath(vim.fs.dirname(u.get_git_root()), spellfile_name)
    if vim.uv.fs_stat(git_parent_spellfile) then
      return git_parent_spellfile
    elseif vim.uv.fs_stat(git_spellfile) then
      return git_spellfile
    end
  end
end

----------------------------------------------------------------------
--                         Complex keymaps                          --
----------------------------------------------------------------------

function M.duplicate_and_comment_visual_lines()
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

function M.toggle_qf_window()
  -- stolen from lazyvim (config/keymaps.lua)
  local success, err = pcall(vim.fn.getqflist({ winid = 0 }).winid ~= 0 and vim.cmd.cclose or vim.cmd.copen)
  if not success and err then
    vim.notify(err, vim.log.levels.ERROR)
  end
end

function M.diagnostic_jump(count_multiplier)
  vim.diagnostic.jump({
    wrap = true,
    count = count_multiplier * vim.v.count1,
    on_jump = function(diagnostic, bufnr)
      if diagnostic == nil then
        return
      end
      vim.diagnostic.open_float({ bufnr = bufnr, scope = "line" })
    end,
  })
end

----------------------------------------------------------------------
--                         Lualine helpers                          --
----------------------------------------------------------------------

function M.visually_selected_line_count()
  local starts = vim.fn.line("v")
  local ends = vim.fn.line(".")
  local count = starts <= ends and ends - starts + 1 or starts - ends + 1
  return count .. "V"
end
function M.in_visual_mode()
  return vim.fn.mode():find("[Vv]") ~= nil
end

----------------------------------------------------------------------
--                       Local snippet engine                       --
----------------------------------------------------------------------

-- https://www.reddit.com/r/neovim/comments/1cxfhom/builtin_snippets_so_good_i_removed_luasnip/
local function get_buf_snips(global_snippets, ft_snippets)
  local ft = vim.bo.filetype
  local snips = vim.list_slice(global_snippets)
  for _, snippet in ipairs(ft_snippets) do
    if ft and vim.list_contains(snippet.ft, ft) then
      vim.list_extend(snips, { snippet })
    end
  end
  return snips
end
function M.custom_cmp_snippets(global_snippets, ft_snippets)
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
      end, get_buf_snips(global_snippets, ft_snippets))
      cache[bufnr] = completion_items
    end
    callback(cache[bufnr])
  end
  return cmp_source
end
return M
