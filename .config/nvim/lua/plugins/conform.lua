return {
  "stevearc/conform.nvim",
  config = function()
    require("conform").setup({
      formatters_by_ft = {
        python = { "ruff_organize_imports", "ruff_fix" },
        rust = { "rustfmt" },
        go = { "goimports", "gofmt" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        javascriptreact = { "prettier" },
        typescriptreact = { "prettier" },
      },
      format_on_save = {
        timeout_ms = 1500,
        lsp_format = "fallback",
      },
    })
  end,
}
