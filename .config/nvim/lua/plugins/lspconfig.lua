local lsp_servers = {
    "html",
    "lua_ls",
    "ts_ls",
    "pyright",
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
                        disableOrganizeImports = true,
                        disableTaggedHints = true,
                    },
                    python = {
                        analysis = {
                            autoSearchPaths = true,
                            diagnosticMode = "workspace",
                            typeCheckingMode = "standard",
                            useLibraryCodeForTypes = true,
                            -- we can this setting below to redefine some diagnostics
                            diagnosticSeverityOverrides = {
                                deprecateTypingAliases = false,
                            },
                            -- inlay hint settings are provided by pylance?
                            inlayHints = {
                                callArgumentNames = "partial",
                                functionReturnTypes = true,
                                pytestParameters = true,
                                variableTypes = true,
                            },
                        },
                    },
                },
            })
            require("lspconfig").ruff.setup({
                init_options = {
                    -- the settings can be found here: https://docs.astral.sh/ruff/editors/settings/
                    settings = {
                        organizeImports = true,
                    },
                    preferences = {
                        importModuleSpecifierEnding = "minimal",
                        importModuleSpecifierPreference = "non-relative",
                        includeCompletionsForImportStatements = true,
                        includeCompletionsForModuleExports = true,
                    },
                },
                -- on_attach = function(client, bufnr)
                --     if client.name == "ruff_lsp" then
                --         -- Disable hover in favor of Pyright
                --         client.server_capabilities.hoverProvider = false
                --     end
                -- end,
                -- handlers = {
                --     ["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
                --         virtual_text = true,
                --         signs = true,
                --         underline = true,
                --     }),
                -- },
            })
            vim.opt.completeopt = "menu,menuone,noselect"
        end,
    },
    build = ":MasonUpdate",
}
