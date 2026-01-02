return {
  "obsidian-nvim/obsidian.nvim",
  version = "*", -- use latest release, remove to use latest commit
  ft = "markdown",
  opts = {
    workspaces = {
      {
        name = "personal",
        path = "~/uuta",
      },
    },
    legacy_commands = false,
  },
}
