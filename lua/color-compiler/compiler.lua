local M = {}

local function int_to_hex(color)
	return string.format("#%06x", color)
end

local hl_groups = vim.api.nvim_get_hl(0, {})
print(int_to_hex(hl_groups["Keyword"].fg))

M.compile = function()
	for group, hl in pairs(hl_groups) do
	end
end

return M
