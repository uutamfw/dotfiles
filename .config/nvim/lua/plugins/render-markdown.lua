return {
  'MeanderingProgrammer/render-markdown.nvim',
  dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.nvim' }, -- if you use the mini.nvim suite
  -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.icons' },        -- if you use standalone mini plugins
  -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
  ---@module 'render-markdown'
  ---@type render.md.UserConfig
  ft = { "markdown" },
  config = function()
    require('render-markdown').setup({
      -- @see: https://github.com/MeanderingProgrammer/render-markdown.nvim?tab=readme-ov-file#setup
      completions = { lsp = { enabled = true } },
      code = {
        border = "thick",
      },
    })
  end,
}
