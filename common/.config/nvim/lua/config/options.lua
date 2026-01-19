vim.g.gui_font_default_size = 16
vim.g.gui_font_size = vim.g.gui_font_default_size
vim.g.gui_font_face = "Berkeley Nerd Font"

vim.opt.guicursor = ""

vim.opt.autoindent = true
vim.opt.copyindent = true

vim.opt.ignorecase = true

vim.opt.number = true
vim.opt.numberwidth = 4
vim.opt.relativenumber = true

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
