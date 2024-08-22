-- Check version
if vim.fn.has("nvim-0.9") == 0 then
	error("Need Neovim 0.9+ in order to use this config")
end

-- Check for required commands
local required_cmds = {
	"git",
	"lazygit",
	"npm",
	"node",
	"rg", -- ripgrep (required for telescope live_grep, grep_string and find_files)
}

for _, cmd in ipairs(required_cmds) do
	local name = type(cmd) == "string" and cmd or vim.inspect(cmd)
	local commands = type(cmd) == "string" and { cmd } or cmd
	---@cast commands string[]
	local found = false

	for _, c in ipairs(commands) do
		if vim.fn.executable(c) == 1 then
			name = c
			found = true
		end
	end

	if not found then
		error(("`%s` is not installed"):format(name))
	end
end

-- Setup
require("williamthome.core")
require("williamthome.lazy")
