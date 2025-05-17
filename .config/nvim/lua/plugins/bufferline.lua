-- See the following for more information
-- @see https://github.com/akinsho/bufferline.nvim/blob/main/doc/bufferline.txt
return {
  "akinsho/bufferline.nvim",
  dependencies = "nvim-tree/nvim-web-devicons",
  config = function()
    require("bufferline").setup({
      options = {
        separator_style = "thick",
        diagnostics = "nvim_lsp",
        hover = { enabled = true, delay = 200, reveal = { "close" } },
      },
    })
  end,
}
