local lsp_servers = {
    "html",
    "lua_ls",
    "ts_ls",
    "pyright",
    "ruff_lsp",
}
local capabilities = require("cmp_nvim_lsp").default_capabilities()

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
            "hrsh7th/cmp-nvim-lsp",
        },
        config = function()
            -- Mason-lspconfigの設定
            require("mason-lspconfig").setup({
                automatic_installation = true,
                ensure_installed = lsp_servers,
            })

            -- 補完の設定
            vim.cmd([[set completeopt+=menuone,noselect,popup]])

            -- 保存時に自動フォーマット（最適化版）
            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("lsp", { clear = true }),
                callback = function(args)
                    vim.api.nvim_create_autocmd("BufWritePre", {
                        buffer = args.buf,
                        callback = function()
                            -- フォーマット可能なLSPサーバーが存在するか確認
                            local clients = vim.lsp.get_clients({ bufnr = args.buf })
                            local formatting_client = nil
                            for _, client in ipairs(clients) do
                                if client.supports_method("textDocument/formatting") then
                                    formatting_client = client
                                    break
                                end
                            end
                            if formatting_client then
                                vim.lsp.buf.format {async = false, id = formatting_client.id}
                            end
                        end,
                    })
                end,
            })

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
                        capabilities = capabilities,
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
