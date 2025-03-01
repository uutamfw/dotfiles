local log = require("core.log")
local util = require("lspconfig.util")

local lsp_servers = {
    "html",
    "lua_ls",
    "ts_ls",
    "pyright",
    "pylsp",
    "python-lsp-server",
}

local function is_installed(bin)
    local result = vim.fn.executable(bin) == 1
    log.dlog("[DEBUG] Checking executable: " .. bin .. " -> " .. tostring(result))
    return result
end

is_installed("pylsp")
is_installed("python-lsp-server")

local function get_python_path(workspace)
    if vim.env.VIRTUAL_ENV then
        return vim.env.VIRTUAL_ENV .. "/bin/python"
    end
    -- workspace内に.venvまたはvenvがあるかチェック
    for _, pattern in ipairs({ ".venv", "venv" }) do
        local venv_path = util.path.join(workspace, pattern)
        if util.path.exists(venv_path) then
            return venv_path .. "/bin/python"
        end
    end
    -- なければシステムのpythonをフォールバック
    return "python"
end

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
                            -- https://chat.deepseek.com/a/chat/s/eb212534-64c8-4907-afe5-4d22a51543a3
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
            require("lspconfig").pylsp.setup({
                on_new_config = function(new_config, workspace)
                    log.dlog("[DEBUG] workspace" .. tostring(workspace))
                    log.dlog("[DEBUG] get_python_path" .. tostring(get_python_path(workspace)))
                    new_config.cmd = {
                        "/Users/yutaaoki/gg-newsletter-for-biz-packages/packages/core-api/.venv/bin/python",
                        "-m",
                        "pylsp",
                    }
                end,
                on_attach = function(client)
                    -- Disable formatting
                    client.server_capabilities.documentFormattingProvider = false
                    client.server_capabilities.documentRangeFormattingProvider = false
                end,
                root_dir = util.root_pattern(".git", ".venv", "setup.py", "pyproject.toml"),
                init_options = {
                    preferences = {
                        importModuleSpecifierEnding = "minimal",
                        importModuleSpecifierPreference = "non-relative",
                        includeCompletionsForImportStatements = true,
                        includeCompletionsForModuleExports = true,
                    },
                },
                handlers = {
                    ["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
                        virtual_text = true,
                        signs = true,
                        update_in_insert = true,
                        underline = true,
                        open = false,
                    }),
                },
                settings = {
                    pylsp = {
                        plugins = {
                            ruff = { enabled = true },
                            black = { enabled = false },
                            autopep8 = { enabled = false },
                            mccabe = { enabled = false },
                            yapf = { enabled = false },
                            pycodestyle = { enabled = false },
                            pylint = { enabled = false },
                            pyflakes = { enabled = false },
                            pylsp_mypy = {
                                enabled = true,
                                live_mode = false,
                                -- overrides = {
                                --     "--python-executable",
                                --     "/Users/yutaaoki/gg-newsletter-for-biz-packages/packages/core-api/.venv/bin/python",
                                --     "--config-file",
                                --     "/Users/yutaaoki/gg-newsletter-for-biz-packages/packages/core-api/mypy.ini",
                                --     vim.fn.getcwd(),
                                -- },
                            },
                        },
                        -- disableOrganizeImports = true,
                        -- disableTaggedHints = true,
                    },
                    python = {
                        analysis = {
                            autoSearchPaths = true,
                            diagnosticMode = "workspace",
                            typeCheckingMode = "standard",
                            useLibraryCodeForTypes = true,
                            -- we can this setting below to redefine some diagnostics
                            diagnosticSeverityOverrides = {
                                deprecateTypingAliases = true,
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
            vim.opt.completeopt = "menu,menuone,noselect"
        end,
    },
    build = ":MasonUpdate",
}
