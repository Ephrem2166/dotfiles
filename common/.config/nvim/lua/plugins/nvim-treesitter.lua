return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    opts ={
	indent = {
	enable = true
	},
	highlight = {
	enable = true,
	additional_vim_regex_highlighting = { "markdown" },
	},
	folds = {
	enable = true
	},
	ensure_installed = {
    "bash",
      "c",
      "css",
      "cpp",
      "diff",
      "go",
      "html",
      "java",
      "javascript",
      "jsdoc",
      "json",
      "jsonc",
      "lua",
      "luadoc",
      "luap",
      "markdown",
      "markdown_inline",
      "printf",
      "python",
      "query",
      "regex",
      "rust",
      "toml",
      "tsx",
      "typescript",
      "vim",
      "vimdoc",
      "xml",
      "yaml",
	},
    },
    sync_install = false,
    auto_install = true,
}
