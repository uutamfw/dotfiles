return {
  init_options = {
    provideFormatter = true,
  },
  settings = {
    json = {
      -- schemas = require("schemastore").json.schemas(),
      format = {
        enable = true,
        options = {
          tabSize = 2,
          insertSpaces = true,
        },
      },
    },
  },
}
