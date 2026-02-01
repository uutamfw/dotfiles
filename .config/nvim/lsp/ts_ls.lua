-- INFO: consider replacing with typescript-tools.nvim
-- https://github.com/pmizio/typescript-tools.nvim
-- https://zenn.dev/sirasagi62/articles/196e0f592a6177
return {
  cmd = { "typescript-language-server", "--stdio" },
  root_markers = { "package.json" },
  workspace_required = true,
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
  },
  init_options = {
    hostInfo = "neovim",
    preferences = {
      includeInlayParameterNameHints = "all",
      includeInlayParameterNameHintsWhenArgumentMatchesName = true,
      includeInlayVariableTypeHints = true,
      includeInlayFunctionParameterTypeHints = true,
      includeInlayPropertyDeclarationTypeHints = true,
      includeInlayFunctionLikeReturnTypeHints = true,
      includeInlayEnumMemberValueHints = true,
      importModuleSpecifierPreference = "non-relative",
    },
  },
}
