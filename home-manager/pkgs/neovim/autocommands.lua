if vim.g.did_load_autocommands_plugin then
	return
end
vim.g.did_load_autocommands_plugin = true

local create = vim.api.nvim_create_autocmd

-- create('VimEnter', {callback = function() vim.cmd("checkhealth") end})
-- create('VimEnter', { command = "NvimTreeOpen" })

-- open terminal in insert mode
create({ "TermOpen", "BufEnter" }, { pattern = "term://", command = "startinsert" })

-- set options for .nix files
vim.api.nvim_create_autocmd("FileType", {
	pattern = "nix",
	callback = function(opts)
		local bo = vim.bo[opts.buf]
		bo.tabstop = 2
		bo.shiftwidth = 2
		bo.softtabstop = 2
	end,
})

-- format .nix files on save
-- https://stackoverflow.com/questions/77466697/how-to-automatically-format-on-save
-- potentially a better way, or some way to merge with above
-- vim.api.nvim_create_autocmd("BufWritePre", {
--     callback = function()
--         local mode = vim.api.nvim_get_mode().mode
--         local filetype = vim.bo.filetype
--         if vim.bo.modified == true and mode == 'n' and filetype == "nix" then
--             vim.cmd('lua vim.lsp.buf.format()')
--         else
--         end
--     end
-- })
