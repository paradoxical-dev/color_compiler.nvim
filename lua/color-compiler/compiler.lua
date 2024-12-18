local M = {}

local fmt = string.format
local hl_groups = vim.api.nvim_get_hl(0, {}) -- define all global highlight groups

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
M.compile = function(theme, bg)
	local compile_path = vim.env.HOME .. "/.local/share/nvim/color-compiler/"
	local lines = {
		string.format(
			[[
return string.dump(function()
print('we in here')
vim.o.termguicolors = true
if vim.g.colors_name then print('clearing highlights') vim.cmd("hi clear") end
vim.o.background = "%s"
print("setting name to " .. "%s")
vim.g.colors_name = "%s"
]],
			bg,
			theme,
			theme
		),
	}

	for group, hl in pairs(hl_groups) do
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
		-- if hl.ctermfg then
		-- 	hl.ctermfg = int_to_hex(hl.ctermfg)
		-- end
		-- if hl.ctermbg then
		-- 	hl.ctermbg = int_to_hex(hl.ctermbg)
		-- end
		table.insert(lines, fmt([[vim.api.nvim_set_hl(0, "%s", %s)]], group, inspect(hl)))
	end
	table.insert(lines, "end, true)")

	if vim.fn.isdirectory(compile_path) == 0 then
		vim.fn.mkdir(compile_path, "p")
	end

	local f = loadstring(table.concat(lines, "\n"))
	if not f then
		local err_path = (os.getenv("TMP") or "/tmp") .. "/color-compile_error.lua"

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

	local file = assert(
		io.open(compile_path .. theme, "wb"),
		"Permission denied while writing compiled file to " .. compile_path .. theme
	)
	file:write(f())
	file:close()
end

return M
