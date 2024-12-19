local M = {}

local fmt = string.format
local hl_groups = vim.api.nvim_get_hl(0, {}) -- define all global highlight groups
local group_names = require("color-compiler.groups")
local terminal_colors = {
	terminal_color_0 = vim.g.terminal_color_0,
	terminal_color_1 = vim.g.terminal_color_1,
	terminal_color_2 = vim.g.terminal_color_2,
	terminal_color_3 = vim.g.terminal_color_3,
	terminal_color_4 = vim.g.terminal_color_4,
	terminal_color_5 = vim.g.terminal_color_5,
	terminal_color_6 = vim.g.terminal_color_6,
	terminal_color_7 = vim.g.terminal_color_7,
	terminal_color_8 = vim.g.terminal_color_8,
	terminal_color_9 = vim.g.terminal_color_9,
	terminal_color_10 = vim.g.terminal_color_10,
	terminal_color_11 = vim.g.terminal_color_11,
	terminal_color_12 = vim.g.terminal_color_12,
	terminal_color_13 = vim.g.terminal_color_13,
	terminal_color_14 = vim.g.terminal_color_14,
	terminal_color_15 = vim.g.terminal_color_15,
}
local used_groups = {}

-- converts interger color value to hex
--- @param color number
local function int_to_hex(color)
	return string.format("#%06x", color)
end

-- transfers a lua table to a string, similar to vim.inspect
--- @param t table
local function inspect(t)
	local list = {}
	for k, v in pairs(t) do
		local tv = type(v)
		if tv == "string" then
			table.insert(list, fmt([[%s = "%s"]], k, v))
		elseif tv == "table" then
			table.insert(list, fmt([[%s = %s]], k, inspect(v)))
		else
			table.insert(list, fmt([[%s = %s]], k, tostring(v)))
		end
	end
	return fmt([[{ %s }]], table.concat(list, ", "))
end

-- translates returned hl groups to lua code as a string, setting the colors
-- concats the result to a larger function which will be returned using string.dump
-- the result is then written to it's respective file
--- @param theme string
--- @param bg string
--- @param custom_groups? table
M.compile = function(theme, bg, custom_groups)
	vim.tbl_deep_extend("keep", group_names, custom_groups or {})
	local compile_path = vim.env.HOME .. "/.local/share/nvim/color-compiler/"
	local lines = {
		string.format(
			[[
return string.dump(function()
vim.o.termguicolors = true
if vim.g.colors_name then vim.cmd("hi clear") end
vim.o.background = "%s"
vim.g.colors_name = "%s"
]],
			bg,
			theme
		),
	}

	for k, v in pairs(terminal_colors) do
		table.insert(lines, fmt([[vim.g.%s = "%s"]], k, v))
	end

	for _, group in ipairs(group_names) do
		if not hl_groups[group] or used_groups[group] then
			goto continue
		end

		local hl = hl_groups[group]
		if hl.fg then
			hl.fg = int_to_hex(hl.fg)
		else
			hl.fg = "NONE"
		end
		if hl.bg then
			hl.bg = int_to_hex(hl.bg)
		else
			hl.bg = "NONE"
		end
		if hl.link then
			hl = { link = hl.link }
		end

		table.insert(used_groups, group)
		table.insert(lines, fmt([[vim.api.nvim_set_hl(0, "%s", %s)]], group, inspect(hl)))
		::continue::
	end
	table.insert(lines, "end, true)")

	if vim.fn.isdirectory(compile_path) == 0 then
		vim.fn.mkdir(compile_path, "p")
	end

	local f = loadstring(table.concat(lines, "\n"))
	if not f then
		local err_path = (os.getenv("TMP") or "/tmp") .. "/color-compiler_error.lua"

		print(fmt(
			[[
color-compiler (error): An Error occured during the compilation of the following theme: %s
For further debugging check %s
		  ]],
			theme,
			err_path
		))

		local err = io.open(err_path, "wb")
		if err then
			err:write(table.concat(lines, "\n"))
			err:close()
		end
		dofile(err_path)
		return
	end

	local debug_path = (os.getenv("TMP") or "/tmp") .. "/color-compiler_logs.lua"
	local debug = io.open(debug_path, "wb")
	if debug then
		debug:write(table.concat(lines, "\n"))
		debug:close()
	end

	local file = assert(
		io.open(compile_path .. theme, "wb"),
		"Permission denied while writing compiled file to " .. compile_path .. theme
	)
	file:write(f())
	file:close()
end

return M
