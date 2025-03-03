--- Trouble (show error messages at the bottom of the screen)
--- https://github.com/folke/trouble.nvim
return {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
        -- your configuration comes here
        auto_open = true,
        auto_close = true,
        auto_preview = true,
        -- 必須フィールドを追加
        debug = false,
        auto_refresh = true,
        auto_jump = false,
        focus = false,
        restore = true,
        follow = true,
        indent_guides = true,
        max_items = 200,
        multiline = true,
        pinned = false,
        warn_no_results = true,
        open_no_results = false,
        win = {},
        preview = {
            type = "main",
            scratch = true,
        },
        throttle = {
            refresh = 20,
            update = 10,
            render = 10,
            follow = 100,
            preview = { ms = 100, debounce = true },
        },
        keys = {
            ["?"] = "help",
            r = "refresh",
            R = "toggle_refresh",
            q = "close",
            o = "jump_close",
            ["<esc>"] = "cancel",
            ["<cr>"] = "jump",
        },
        modes = {},
        icons = {
            indent = {
                top = "│ ",
                middle = "├╴",
                last = "└╴",
                fold_open = " ",
                fold_closed = " ",
                ws = "  ",
            },
        },
    },
}
