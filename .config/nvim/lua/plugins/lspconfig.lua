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

is_installed("pyright-langserver")
is_installed("mypy")
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
                root_dir = util.root_pattern(".git", ".venv", "setup.py", "pyproject.toml"),
                init_options = {
                    preferences = {
                        importModuleSpecifierEnding = "minimal",
                        importModuleSpecifierPreference = "non-relative",
                        includeCompletionsForImportStatements = true,
                        includeCompletionsForModuleExports = true,
                    },
                },
                settings = {
                    pylsp = {
                        plugins = {
                            ruff = {
                                enabled = true,
                            },
                            pylsp_mypy = { enabled = true },
                            pylsp_black = { enabled = true },
                        },
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
            vim.opt.completeopt = "menu,menuone,noselect"
        end,
    },
    build = ":MasonUpdate",
}
