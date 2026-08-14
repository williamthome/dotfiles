return {
	"greggh/claude-code.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	cmd = {
		"ClaudeCode",
		"ClaudeCodeContinue",
		"ClaudeCodeResume",
		"ClaudeCodeVerbose",
	},
	keys = {
		{ "<leader>cc", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude Code" },
	},
	config = function()
		require("claude-code").setup()
	end,
}
