
-- lua/plugins/render-markdown.lua
local M = {}

function M.setup()
  vim.pack.add({
    { src = 'https://github.com/MeanderingProgrammer/render-markdown.nvim' },
  })
  require("render-markdown").setup({})
end

return M
