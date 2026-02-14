return {
  'lewis6991/gitsigns.nvim',
  config = function()
    require('gitsigns').setup({
      numhl     = true,           -- Color the line number when there is a git change
      linehl    = false,          -- Color the whole line when there is a git change.
      word_diff = true            -- Highlight the word that has changed when there is a git change.
    })
  end,
}
