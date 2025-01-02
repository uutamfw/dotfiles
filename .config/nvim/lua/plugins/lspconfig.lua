local lsp_servers = {
    "html",
    "lua_ls",
    "ts_ls",
    -- "pyright",
}

return {
    "neovim/nvim-lspconfig",
    "williamboman/mason.nvim",
    {
        -- Mason
        "williamboman/mason-lspconfig.nvim",
        config = function()
            require("mason").setup()
            require("mason-lspconfig").setup_handlers({
                function(server)
                    require("lspconfig")[server].setup({
                        -- Let mason-lspconfig install the defined servers
                        ensure_installed = {
                            lsp_servers,
                        },
                        -- Language server
                        init_options = {
                            preferences = {
                                importModuleSpecifierEnding = "minimal",
                                importModuleSpecifierPreference = "non-relative",
                                includeCompletionsForImportStatements = true,
                                includeCompletionsForModuleExports = true,
                            },
                        },
                        on_attach = function(client)
                            -- Disable formatting
                            client.server_capabilities.documentFormattingProvider = false
                            client.server_capabilities.documentRangeFormattingProvider = false
                        end,
                        handlers = {
                            -- TODO: diagnostic configuration
                            -- https://neovim.io/doc/user/lsp.html#lsp-api
                            ["textDocument/publishDiagnostics"] = vim.lsp.with(
                                vim.lsp.diagnostic.on_publish_diagnostics,
                                {
                                    -- Disable virtual_text
                                    virtual_text = true,
                                    signs = true,
                                    update_in_insert = true,
                                    underline = true,
                                    open = false,
                                }
                            ),
                        },
                    })
                end,
            })
            require("lspconfig").dartls.setup({
                cmd = { "dart", "language-server", "--protocol=lsp" },
            })
            require("lspconfig").gopls.setup({
                cmd = { "gopls", "-rpc.trace", "--debug=localhost:6060" },
                settings = {
                    gopls = {
                        experimentalWorkspaceModule = true,
                    },
                },
                init_options = {
                    preferences = {
                        importModuleSpecifierEnding = "minimal",
                        importModuleSpecifierPreference = "non-relative",
                        includeCompletionsForImportStatements = true,
                        includeCompletionsForModuleExports = true,
                    },
                },
                on_attach = function(client, bufnr)
                    client.server_capabilities.documentFormattingProvider = false
                    client.server_capabilities.documentRangeFormattingProvider = false
                    client.server_capabilities.semanticTokensProvider = false
                end,
            })
            require("lspconfig").pyright.setup({
                settings = {
                    pyright = {
                        -- Using Ruff's import organizer
                        disableOrganizeImports = true,
                    },
                    python = {
                        analysis = {
                            -- Ignore all files for analysis to exclusively use Ruff for linting
                            ignore = { "*" },
                        },
                    },
                },
            })
            require("lspconfig").ruff.setup({
                init_options = {
                    preferences = {
                        importModuleSpecifierEnding = "minimal",
                        importModuleSpecifierPreference = "non-relative",
                        includeCompletionsForImportStatements = true,
                        includeCompletionsForModuleExports = true,
                    },
                },
                on_attach = function(client, bufnr)
                    -- 必要に応じて on_attach 関数を追加
                    print("Pyright attached to buffer " .. bufnr)
                end,
                handlers = {
                    ["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
                        virtual_text = true,
                        signs = true,
                        underline = true,
                    }),
                },
            })
            vim.opt.completeopt = "menu,menuone,noselect"
        end,
    },
    build = ":MasonUpdate",
}
