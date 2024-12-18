local M = {}

local path = vim.env.HOME .. "/.local/share/nvim/color-compiler/"

-- main function for loading the compled color scheme into neovim
--- @param theme string
M.load = function(theme)
	local compiled_path = path .. theme
	local f = loadfile(compiled_path)
	if not f then
		print(string.format(
			[[
	  color-compiler (error): Failed to load theme: %s from path %s
    Compile your current theme using the command `:ColorCompiler`
	    ]],
			theme,
			compiled_path
		))
		return
	end
	f(theme)
end

-- user command for compiling the current color scheme
vim.api.nvim_create_user_command("ColorCompiler", function(opts)
	local args = vim.split(opts.args, " ")
	local theme = args[1]
	local bg = args[2] or vim.o.background

	if not theme then
		print("color-compiler (error): Theme name is required.")
		return
	end

	require("color-compiler.compiler").compile(theme, bg)
	print("Successfully compiled theme: " .. theme .. " into " .. path .. theme)
end, {
	nargs = "*",
	desc = "Compile the current color scheme for later use",
})

return M
