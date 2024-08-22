local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	root = vim.fn.stdpath("data") .. "/lazy", -- directory where plugins will be installed
	lockfile = vim.fn.stdpath("config") .. "/lazy-lock.json", -- lockfile generated after running update.
	state = vim.fn.stdpath("state") .. "/lazy/state.json", -- state
	spec = {
		{ import = "williamthome.plugins" },
		{ import = "williamthome.plugins.lsp" },
	},
	defaults = {
		lazy = false, -- should plugins be lazy-loaded?
		version = nil, -- when "*", try installing the latest stable versions of plugins
	},
	checker = {
		-- automatically check for plugin updates
		enabled = true,
		-- get a notification when new updates are found
		-- disable it as it's too annoying
		notify = false,
		-- check for updates every day
		frequency = 86400,
	},
	change_detection = {
		-- automatically check for config file changes and reload the ui
		enabled = true,
		-- get a notification when changes are found
		-- disable it as it's too annoying
		notify = false,
	},
	performance = {
		cache = {
			enabled = true,
		},
	},
})
