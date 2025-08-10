return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    -- bigfile = { enabled = true },
    dashboard = {
      enabled = true,
      preset = {
        header = [[
                     __              
                    |  \             
 __    __ __    __ _| ▓▓_    ______  
|  \  |  \  \  |  \   ▓▓ \  |      \ 
| ▓▓  | ▓▓ ▓▓  | ▓▓\▓▓▓▓▓▓   \▓▓▓▓▓▓\
| ▓▓  | ▓▓ ▓▓  | ▓▓ | ▓▓ __ /      ▓▓
| ▓▓__/ ▓▓ ▓▓__/ ▓▓ | ▓▓|  \  ▓▓▓▓▓▓▓
 \▓▓    ▓▓\▓▓    ▓▓  \▓▓  ▓▓\▓▓    ▓▓
  \▓▓▓▓▓▓  \▓▓▓▓▓▓    \▓▓▓▓  \▓▓▓▓▓▓▓



]],
      },
      sections = {
        { section = "header" },
        { section = "keys", gap = 1, padding = 1 },
        { section = "startup" },
      },
    },
    indent = { enabled = true },
    -- input = { enabled = true },
    -- notifier = {
    --     enabled = true,
    --     timeout = 3000,
    -- },
    -- quickfile = { enabled = true },
    -- scroll = { enabled = true },
    -- statuscolumn = { enabled = true },
    -- words = { enabled = true },
    -- styles = {
    --     notification = {
    --         -- wo = { wrap = true } -- Wrap notifications
    --     },
    -- },
  },
}
