local M = {}

M.config = {
	save_location = vim.fn.stdpath("cache") .. "/color-compiler",
}

M.setup = function(opts)
	M.config = vim.tbl_deep_extend("force", M.config, opts or {})
end

return M
