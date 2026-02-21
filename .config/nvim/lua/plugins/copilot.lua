return {
  "zbirenbaum/copilot.lua",
  equires = {
    "copilotlsp-nvim/copilot-lsp",
    init = function()
      vim.g.copilot_nes_debounce = 500
    end,
  },
  cmd = "Copilot",
  lazy = true,             -- 遅延読み込みを有効化
  event = "InsertEnter",   -- Insertモードに入ったときに読み込む
  config = function()
    require("copilot").setup({
      panel = {
        enabled = true,
        auto_refresh = false,
        keymap = {
          jump_prev = "[[",
          jump_next = "]]",
          accept = "<CR>",
          refresh = "gr",
          open = "<C-b>",
        },
        layout = {
          position = "bottom",   -- | top | left | right | horizontal | vertical
          ratio = 0.4,
        },
      },
      suggestion = {
        auto_trigger = true,
        keymap = {
          accept = "<C-l>",    -- 補完を受け入れるキー
          next = "<C-j>",      -- 次の候補に移動
          prev = "<C-k>",      -- 前の候補に移動
          dismiss = "<C-h>",   -- 補完を閉じる
        },
      },
    })
  end,
}
