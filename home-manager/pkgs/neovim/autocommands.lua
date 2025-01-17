if vim.g.did_load_autocommands_plugin then
  return
end
vim.g.did_load_autocommands_plugin = true

local create = vim.api.nvim_create_autocmd

-- create('VimEnter', {callback = function() vim.cmd("checkhealth") end})
-- create('VimEnter', { command = "NvimTreeOpen" })

-- open terminal in insert mode
create({ 'TermOpen', 'BufEnter' }, {pattern='term://', command='startinsert'})


-- set options for .nix files
vim.api.nvim_create_autocmd(
  "FileType",
  {
    pattern = "nix",
    callback = function(opts)
      local bo = vim.bo[opts.buf]
      bo.tabstop = 2
      bo.shiftwidth = 2
      bo.softtabstop = 2
    end
  }
)