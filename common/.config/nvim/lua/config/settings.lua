vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.keymap.set("n","<leader>wv", "<cmd>vsplit<CR>")
vim.keymap.set("n","<leader>ws", "<cmd>split<CR>")
vim.keymap.set("n","<leader>wq", "<cmd>close<CR>")

vim.scrolloff = 10

vim.opt.mouse = 'a'

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true


vim.opt.breakindent = true

vim.opt.showmode = false

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true
vim.opt.number = false

vim.opt.confirm = true

vim.opt.undofile = true

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.signcolumn = 'yes'

vim.opt.updatetime = 250

vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.list = true

-- Preview substitutions live, as you type!
vim.o.inccommand = 'split'

vim.o.cursorline = true
