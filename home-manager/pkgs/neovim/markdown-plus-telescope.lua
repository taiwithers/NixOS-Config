local pickers = require("telescope.pickers") -- creating pickers
local finders = require("telescope.finders") -- fill picker with stuff
local conf = require("telescope.config").values
local actions = require("telescope.actions") -- define action when item is chosen
local action_state = require("telescope.actions.state") -- utilities

local M = {}

function M.table_commands(opts)
  opts = opts or {}
  pickers
    .new(opts, {
      prompt_title = "MD+ table commands",

      finder = finders.new_table({
        results = {
          -- name, command
          { "Create table", "lua require('markdown-plus.table.creator').create_table_interactive()" },
          { "Format table", "lua require('markdown-plus.table.format').format_table()" },
          { "Insert row below", "lua require('markdown-plus.table.manipulation').insert_row(false)" },
          { "Insert column left", "lua require('markdown-plus.table.manipulation').insert_column(true)" },
          { "Insert column right", "lua require('markdown-plus.table.manipulation').insert_column(false)" },
          { "Delete column", "lua require('markdown-plus.table.manipulation').delete_column(false)" },
          { "Duplicate column", "lua require('markdown-plus.table.manipulation').duplicate_column(false)" },
          { "Move column left", "lua require('markdown-plus.table.manipulation').move_column_left()" },
          { "Move column right", "lua require('markdown-plus.table.manipulation').move_column_right()" },
          { "Clear cell", "lua require('markdown-plus.table.manipulation').clear_cell()" },
          { "Sort by column", "lua require('markdown-plus.table.calculator').sort_by_column()" },
          { "Sort by column (descending)", "lua require('markdown-plus.table.calculator').sort_by_column(false)" },
        },
        entry_maker = function(entry)
          return {
            value = entry, -- always leave `value = entry`
            display = entry[1], -- displayed in picker
            ordinal = entry[1], -- used for sorting
          }
        end,
      }),

      sorter = conf.generic_sorter(opts),

      attach_mappings = function(prompt_bufnr, _)
        actions.select_default:replace(function() -- change what happens when you select something
          actions.close(prompt_bufnr)
          local selection = action_state.get_selected_entry()
          local command = selection.value[2]
          -- print(command)
          vim.cmd(command)
        end)
        return true
      end,
    })
    :find()
end

-- colors(require("telescope.themes").get_dropdown())
return M
