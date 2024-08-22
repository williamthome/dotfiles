return {
	{
		"nvim-neo-tree/neo-tree.nvim",
		dependencies = {
			{ "nvim-lua/plenary.nvim", lazy = true },
			{ "nvim-tree/nvim-web-devicons", lazy = true },
			{ "MunifTanjim/nui.nvim", lazy = true },
		},
		config = function()
			require("neo-tree").setup({
				window = {
					position = "float",
					width = 35,
				},
				filesystem = {
					filtered_items = {
						visible = true, -- when true, they will just be displayed differently than normal items
						hide_dotfiles = true,
						hide_hidden = true,
						hide_gitignored = true,
						always_show = { -- remains visible even if other settings would normally hide it
							".github",
						},
						never_show = {
							".git",
						},
					},
				},
			})
		end,
		vim.keymap.set("n", "<leader>ee", "<Cmd>Neotree toggle<CR>"),
	},
}
