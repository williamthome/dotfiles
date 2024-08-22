return {
	"rmagatti/auto-session",
	config = function()
		local auto_session = require("auto-session")

		auto_session.setup({
			auto_restore_enabled = false,
			auto_session_suppress_dirs = { "~/", "~/Downloads", "~/Documents", "~/Desktop/" },
			pre_save_cmds = { "Neotree close" },
			post_restore_cmds = { "Neotree filesystem show" },
		})

		vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

		local keymap = vim.keymap

		keymap.set("n", "<leader>wr", "<cmd>SessionRestore<CR>", { desc = "Restore session for cwd" }) -- restore last workspace session for current directory
		keymap.set("n", "<leader>ws", "<cmd>SessionSave<CR>", { desc = "Save session for auto session root dir" }) -- save workspace session for current working directory
		keymap.set(
			"n",
			"<leader>wf",
			require("auto-session.session-lens").search_session,
			{ desc = "Search for sessions" }
		) -- open a dialog to search for sessions
	end,
}
