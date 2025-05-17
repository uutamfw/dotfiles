local lsp_servers = {
  "html",
  "lua_ls",
  "ts_ls",
  "pyright",
  "ruff",
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

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("lsp", { clear = true }),
        callback = function(args)
          vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = args.buf,
            callback = function()
              -- フォーマット可能なLSPサーバーが存在するか確認
              local clients = vim.lsp.get_clients({ bufnr = args.buf })
              for _, client in ipairs(clients) do
                if client.supports_method("textDocument/formatting") then
                  vim.lsp.buf.format { async = false, id = client.id }
                  break
                end
              end
            end,
          })
        end,
      })

      -- LSPサーバーの設定
      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(ev)
          local client = vim.lsp.get_client_by_id(ev.data.client_id)
          if client:supports_method('textDocument/completion') then
            vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
          end
        end,
      })
      -- LSPサーバーの有効化
      vim.lsp.enable(lsp_servers)
    end,
  },
}
