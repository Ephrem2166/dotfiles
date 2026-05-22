vim.g.gui_font_default_size = 16
vim.g.gui_font_size = vim.g.gui_font_default_size
vim.g.gui_font_face = "Berkeley Nerd Font"

-- Fix markdown indentation settings
vim.g.markdown_recommend_style = 0

vim.opt.guicursor = ""

vim.opt.autoindent = true
vim.opt.copyindent = true
vim.opt.confirm = true

vim.opt.foldlevel = 99
vim.opt.foldmethod = "indent"
vim.opt.foldtext = ""

vim.opt.ignorecase = true

vim.opt.mouse = "a"

vim.opt.number = true
vim.opt.numberwidth = 4
vim.opt.relativenumber = false

vim.opt.ruler = false

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = true
vim.opt.linebreak = true

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true

vim.opt.hlsearch = true
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
--vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.opt.splitkeep = "screen"
vim.opt.cursorline = true
--vim.opt.colorcolumn = "80"
--
vim.opt.clipboard = "unnamedplus"

vim.opt.fillchars = {
	horiz = "━",
	horizup = "┻",
	horizdown = "┳",
	vert = "┃",
	vertleft = "┨",
	vertright = "┣",
	verthoriz = "╋",
	fold = "⠀",
	eob = " ",
	diff = "┃",
	msgsep = "‾",
	foldsep = "│",
	foldclose = "▶",
	foldopen = "▼",
}

vim.opt.filetype = on

vim.opt.pumheight = 10

vim.opt.winbar = "%=%m %f"

-- Netrw settings
vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3
vim.g.netrw_browse_split = 4
vim.g.netrw_winsize = 25
vim.g.netrw_altv = 1
