-- return {
--   -- pyproject.tomlの設定が自動的に読み込まれる
--   settings = {
--     organizeImports = true,
--     fixAll = true
--   }
-- }
return {
  init_options = {
    -- the settings can be found here: https://docs.astral.sh/ruff/editors/settings/
    settings = {
      organizeImports = true,
    },
  },
}
