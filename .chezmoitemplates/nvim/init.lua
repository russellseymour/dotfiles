In_wsl = os.getenv("WSL_DISTRO_NAME") ~= nil

if In_wsl then
	vim.g.clipboard = {
		name = "wsl clipboard",
		copy = {
			["+"] = { "/mnt/c/Windows/system32/clip.exe" },
			["*"] = { "/mnt/c/Windows/system32/clip.exe" },
		},
		paste = {
			["+"] = { "/mnt/c/Program Files/Neovim/bin/win32yank.exe" },
			["*"] = { "/mnt/c/Program Files/Neovim/bin/win32yank.exe" },
		},
		cache_enabled = false,
	}
end

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end

vim.opt.rtp:prepend(lazypath)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({
	spec = {
		{ "LazyVim/LazyVim", import = "lazyvim.plugins" },
		{
			"nvim-lualine/lualine.nvim",
			dependencies = { "nvim-tree/nvim-web-devicons" },
		},
		{ "nvim-telescope/telescope.nvim", tag = "0.1.8" },
		{
			"nvim-neo-tree/neo-tree.nvim",
			branch = "v3.x",
			dependencies = {
				"nvim-lua/plenary.nvim",
				"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
				"MunifTanjim/nui.nvim",
			},
		},
		{
			"MeanderingProgrammer/render-markdown.nvim",
			opts = {},
			dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.icons" },
		},
		{
			"iamcco/markdown-preview.nvim",
			cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
			build = "cd app && yarn install",
			init = function()
				vim.g.mkdp_filetypes = { "markdown" }
			end,
			ft = { "markdown" },
		},
		{
			"ibhagwan/fzf-lua",
			-- optional for icon support
			dependencies = { "nvim-tree/nvim-web-devicons" },
			config = function()
				-- calling `setup` is optional for customization
				require("fzf-lua").setup({ "fzf-tmux", winopts = { preview = { default = "bat" } } })
			end,
		},
	},
	install = { colorscheme = { "tokyonight" } },
	checker = { enabled = true },
})

local custom_tokyonight = require("lualine.themes.tokyonight")
custom_tokyonight.normal.c.bg = "#1a1b26"

local noice = require("noice")
noice.setup({
	routes = {
		{
			view = "notify",
			filter = { event = "msg_showmode" },
		},
	},
})

-- format buffer on write
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	callback = function(args)
		require("conform").format({ bufnr = args.buf })
	end,
})

-- format buffer on demand
vim.api.nvim_create_user_command("Format", function(args)
	local range = nil
	if args.count ~= -1 then
		local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
		range = {
			start = { args.line1, 0 },
			["end"] = { args.line2, end_line:len() },
		}
	end
	require("conform").format({ async = true, lsp_format = "fallback", range = range })
end, { range = true })

-- configure status line
require("lualine").setup({
	options = {
		icons_enabled = true,
		theme = custom_tokyonight,
		component_separators = { left = "", right = "" },
		section_separators = { left = "", right = "" },
		disabled_filetypes = {
			statusline = {},
			winbar = {},
		},
		ignore_focus = {},
		always_divide_middle = true,
		globalstatus = false,
		refresh = {
			statusline = 1000,
			tabline = 1000,
			winbar = 1000,
		},
	},
	sections = {
		lualine_a = { { "mode", separator = { left = "", right = "" }, right_padding = 2 } },
		lualine_b = { "branch", "diff", "diagnostics" },
		lualine_c = { { "filename", separator = { right = "" }, color = { bg = "#292e42" } } },
		lualine_x = {
			{
				noice.api.status.mode.get,
				cond = noice.api.status.mode.has,
				separator = { left = "" },
				color = { bg = "#7dcfff", fg = "#1f2335" },
			},
			{ "encoding", separator = { left = "" }, color = { bg = "#bb9af7", fg = "#1f2335" } },
			{ "fileformat", separator = { left = "" }, color = { bg = "#9d7cd8", fg = "#1f2335" } },
			{ "filetype", separator = { left = "" }, color = { bg = "#414868", fg = "#ffffff" } },
		},
		lualine_y = { { "progress", color = { bg = "#c53b53", fg = "#ffffff" } } },
		lualine_z = {
			{
				"location",
				separator = { left = "", right = "" },
				color = { bg = "#ff007c", fg = "#ffffff" },
				left_padding = 2,
			},
		},
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = { "filename" },
		lualine_x = { "location" },
		lualine_y = {},
		lualine_z = {},
	},
	tabline = {},
	winbar = {},
	inactive_winbar = {},
	extensions = {},
})

-- colorscheme options
require("tokyonight").setup({
	style = "night",
	on_colors = function() end,
	on_highlights = function() end,
})

vim.cmd([[colorscheme tokyonight]])

-- Disable Mousevim.opt.mousescroll = "ver:0,hor:0"
vim.keymap.set("", "<up>", "<nop>", { noremap = true })
vim.keymap.set("", "<down>", "<nop>", { noremap = true })
vim.keymap.set("i", "<up>", "<nop>", { noremap = true })
vim.keymap.set("i", "<down>", "<nop>", { noremap = true })

-- create keybinding for neotree
vim.keymap.set("n", "<C-\\>", "<Cmd>Neotree toggle<CR>")

-- disable mouse
vim.opt.mouse = ""

-- disable relative line numbers
vim.opt.relativenumber = false

