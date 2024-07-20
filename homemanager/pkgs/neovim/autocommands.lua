if vim.g.did_load_autocommands_plugin then
  return
end
vim.g.did_load_autocommands_plugin = true

local create = vim.api.nvim_create_autocmd

create('VimEnter', {callback = function() vim.cmd("checkhealth") end})
create('VimEnter', { command = "Neotree" })
