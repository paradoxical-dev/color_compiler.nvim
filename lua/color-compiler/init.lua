local M = {}

local path = vim.env.HOME .. "/.local/share/nvim/color-compiler/"

M.config = {
	extenstions = {
		"lsp",
		"treesitter",
		"cmp",
	},
}

-- used to define desired plugins and load desired theme if it exists
--- @param opts table
M.setup = function(opts)
	M.config = vim.tbl_deep_extend("force", M.config, opts)

	-- validate config
	if M.config.extensions and type(M.config.extensions) == "table" then
		for _, ext in ipairs(M.config.extensions) do
			if type(ext) ~= "string" then
				vim.notify("[color-compiler] setup: 'extensions' must contain only strings", vim.log.levels.ERROR)
				return
			end
		end
	else
		vim.notify("[color-compiler] setup: 'extensions' must be a table of strings", vim.log.levels.ERROR)
		M.config.extensions = {}
	end

	if M.config.theme then
		M.load(M.config.theme)
	end
end

-- main function for loading the compled color scheme into neovim
--- @param theme string
M.load = function(theme)
	local compiled_path = path .. theme
	if not vim.loop.fs_stat(compiled_path) then
		print(string.format(
			[[
	  color-compiler (error): Failed to load theme: %s from path %s
	  Theme has not been compiled yet. Compile your current theme using the command `:ColorCompiler`
			]],
			theme,
			compiled_path
		))
		return
	end
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
	local custom_groups = {}
	if #args <= 3 then
		for i = 3, #args do
			table.insert(custom_groups, args[i])
		end
	end

	if not theme then
		print("color-compiler (error): Theme name is required.")
		return
	end

	require("color-compiler.compiler").compile(theme, bg, custom_groups)
	print("Successfully compiled theme: " .. theme .. " into " .. path .. theme)
end, {
	nargs = "*",
	desc = "Compile the current color scheme for later use",
})

return M
