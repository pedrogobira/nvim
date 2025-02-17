local telescope = require("telescope")

telescope.setup({
	defaults = {
		file_ignore_patterns = {
			"node_modules",
			"vendor",
			"venv",
      "deps",
      "__pycache__",
		},
	},
})

local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
vim.keymap.set("n", "<leader>pf", builtin.git_files, {})
vim.keymap.set("n", "<leader>fw", builtin.live_grep, {})
vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})
