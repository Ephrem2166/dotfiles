return {
    "stevearc/oil.nvim",
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {},
    -- Optional dependencies
    dependencies = { { "nvim-mini/mini.icons", opts = {} } },
    -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
    -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
    lazy = false,
    config = function()
        require("oil").setup({
            -- check :help oil-columns
            default_file_explorer = true,
            columns = {
                "icon",
                "permissions",
                "size",
                -- "mtime",
            },
            delete_to_trash = true,
            watch_for_changes = true,
            view_options = {
                show_hidden = true,
                is_hidden_file = function(name, bufnr)
                    return false
                end,
                is_always_hidden = function(name, bufnr)
                    return false
                end,
            },
        })
    end,
    keys = {
        {
            "<leader>ed",
            "<cmd>Oil<CR>",
            desc = "Oil File Manager",
        },
    },
}
