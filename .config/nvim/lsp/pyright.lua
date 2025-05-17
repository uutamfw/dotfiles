return {
  settings = {
    pyright = {
      disableLanguageServices = false,
      disableOrganizeImports = false,
      disableTaggedHints = true
    },
    python = {
      analysis = {
        autoImportCompletions = true,
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
      },
    }
  },
}
