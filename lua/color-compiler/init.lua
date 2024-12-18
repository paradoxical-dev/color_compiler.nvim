local M = {}

-- main function for loading the compled color scheme into neovim
--- @param theme string
M.load = function(theme)
	local compiled_path = vim.fn.stdpath("cache") .. "color-compiler/" .. theme
	local f = loadfile(compile_path)
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
vim.api.nvim_create_user_command("ColorCompiler", function(theme, bg)
	require("color-compiler.compiler").compile(theme, bg)
end, {
	nargs = 2,
	desc = "Compile the current color scheme for later use",
})

return M
