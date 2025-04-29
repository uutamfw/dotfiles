return {
  -- @see: https://github.com/monaqa/dial.nvim/blob/master/README_ja.md
  "monaqa/dial.nvim",
  event = "VeryLazy",
  lazy = false,
  config = function()
    local augend = require("dial.augend")
    require("dial.config").augends:register_group {
      default = {
        augend.constant.new {
          elements = { "true", "false" },
          word = true,   -- if false, "sand" is incremented into "sor", "doctor" into "doctand", etc.
          cyclic = true, -- "or" is incremented into "and".
        },
        augend.constant.new {
          elements = { "and", "or" },
          word = true,   -- if false, "sand" is incremented into "sor", "doctor" into "doctand", etc.
          cyclic = true, -- "or" is incremented into "and".
        },
        augend.constant.new {
          elements = { "&&", "||" },
          word = false,
          cyclic = true,
        },
        augend.constant.new {
          elements = { "public", "private" },
          word = true,
          cyclic = true,
        },
        augend.constant.new {
          elements = { "str", "str | None" },
          word = true,
          cyclic = true,
        },
      },
    }
  end
}
