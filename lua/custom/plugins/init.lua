-- lua/plugins/render-markdown.lua
local M = {}

function M.setup()
  vim.pack.add({
    { src = 'https://github.com/MeanderingProgrammer/render-markdown.nvim' },
    { src = 'https://github.com/nvim-orgmode/orgmode.git',                 version = "0.7.2" },
    { src = 'https://github.com/chipsenkbeil/org-roam.nvim.git',           version = "0.2.0" },
  })

  require("render-markdown").setup({})

  require('orgmode').setup({
    -- Setup orgmode
    org_agenda_files = '~/Documents/vault-org/**/*',
    org_default_notes_file = '~/Documents/vault-org/refile.org',
  })

  require("org-roam").setup({
    directory = "~/Documents/vault-org/roam/",
  })
end

return M
