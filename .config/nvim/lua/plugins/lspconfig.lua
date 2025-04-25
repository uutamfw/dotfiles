local lsp_servers = {
    "html",
    "lua_ls",
    "ts_ls",
    "pyright",
    "ruff_lsp",
}

return {
    {
        "williamboman/mason.nvim",
        build = ":MasonUpdate",
        config = function()
            require("mason").setup()
        end,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = {
            "williamboman/mason.nvim",
            "neovim/nvim-lspconfig",
        },
        config = function()
            -- Mason-lspconfigの設定
            require("mason-lspconfig").setup({
                automatic_installation = true,
                ensure_installed = lsp_servers,
                init_options = {
                    preferences = {
                        importModuleSpecifierEnding = "minimal",
                        importModuleSpecifierPreference = "non-relative",
                        includeCompletionsForImportStatements = true,
                        includeCompletionsForModuleExports = true,
                    },
                },
            })

            -- 補完の設定
            vim.cmd([[set completeopt+=menuone,noselect,popup]])

            -- LSPサーバーの設定
            vim.lsp.config("lua_ls", {
                settings = {
                    Lua = {
                        diagnostics = {
                            globals = { "vim", "lua" },
                        },
                        format = {
                            enable = true,
                            defaultConfig = {
                                indent_style = "space",
                                indent_size = "2",
                            },
                        },
                    },
                },
            })

            vim.lsp.config("ruff_lsp", {
                -- pyproject.tomlの設定が自動的に読み込まれる
            })

            vim.lsp.config("pyright", {
                settings = {
                    pyright = {
                        disableOrganizeImports = false,
                    },
                    python = {
                        analysis = {
                            ignore = { "*" }, -- Ruffにlintを任せる場合
                        },
                    },
                },
            })

            -- LSPサーバーの有効化
            vim.lsp.enable(lsp_servers)
        end,
    },
}
