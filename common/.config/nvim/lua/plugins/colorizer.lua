return {
    "norcalli/nvim-colorizer.lua",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
        "*",
        user_default_options = {
            RGB = true,
            names = false,
            RRGGBB = true,
            RRGGBBAA = true,
            rgb_fn = true,
            hsl_fn = true,
            css = true,
            css_fn = true,
        },
    },
    config = function()
        vim.o.termguicolors = true
        require("colorizer").setup({
            "*",
            user_default_options = {
                names = false,
                mode = "foreground",
            },
        })
    end,
}
