return {
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" }, -- グローバル変数の警告を無視
      },
      -- 細かい挙動は下記で設定している
      -- @see: https://github.com/CppCXY/EmmyLuaCodeStyle/blob/master/lua.template.editorconfig
      format = {
        enable = true,
      },
    },
  },
}
