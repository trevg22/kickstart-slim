vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true
vim.o.number = true
vim.o.relativenumber = true
vim.o.mouse = 'a'
vim.o.showmode = false
vim.schedule(function()
  vim.o.clipboard = 'unnamedplus'
end)
vim.o.breakindent = true

vim.o.undofile = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.signcolumn = 'yes'
vim.opt.termguicolors = true
vim.o.updatetime = 250
vim.o.timeoutlen = 300
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
vim.o.inccommand = 'split'
vim.o.cursorline = true
vim.o.scrolloff = 10
vim.o.confirm = true
vim.opt.swapfile = true
vim.o.exrc=true
vim.o.secure=false
vim.api.nvim_create_autocmd("SwapExists", {
  callback = function() vim.v.swapchoice = 'e' end,
})
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })
--
-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})


vim.pack.add {
  { src = 'https://github.com/lewis6991/gitsigns.nvim' },
  { src = 'https://github.com/NMAC427/guess-indent.nvim' },
  { src = 'https://github.com/folke/which-key.nvim' },
  { src = 'https://github.com/neovim/nvim-lspconfig' },
  { src = 'https://github.com/stevearc/conform.nvim' },
  { src = 'https://github.com/saghen/blink.cmp' },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
  { src = 'https://github.com/folke/tokyonight.nvim' },
  { src = "https://github.com/neanias/everforest-nvim",         version = "main" },
  { src = "https://github.com/stevearc/oil.nvim" },
  { src = "https://github.com/echasnovski/mini.pick" },
  { src = "https://github.com/echasnovski/mini.extra" },
  { src = "https://github.com/folke/todo-comments.nvim.git" },
  { src = "https://github.com/folke/lazydev.nvim.git" },
  { src = "https://github.com/folke/snacks.nvim" },
  { src = "https://github.com/MunifTanjim/nui.nvim" },
  { src = "https://github.com/harrisoncramer/gitlab.nvim" },
  { src = "https://github.com/nvim-lua/plenary.nvim" },
  { src = "https://github.com/sindrets/diffview.nvim" },
  { src = "https://github.com/stevearc/dressing.nvim" },
}


vim.cmd.colorscheme 'everforest'
require("custom.plugins").setup()
local choose_all = function()
  local mappings = MiniPick.get_picker_opts().mappings
  vim.api.nvim_input(mappings.mark_all .. mappings.choose_marked)
end
require('mini.pick').setup({
  mappings = {
    choose_all = { char = '<C-q>', func = choose_all },
  },
})
require "mini.extra".setup()
require "oil".setup()

vim.keymap.set('n', '<leader>sf', ":Pick files<CR>")
vim.keymap.set('n', '<leader><leader>', ":Pick buffers<CR>")
vim.keymap.set('n', '<leader>sg', ":Pick grep_live<CR>")
vim.keymap.set('n', '<leader>sr', ":Pick resume<CR>")
vim.keymap.set('n', '<leader>sk', ":Pick keymaps<CR>")
vim.keymap.set('n', '<leader>sd', ":Pick diagnostic<CR>")
vim.keymap.set('n', '<leader>sc', ":Pick commands<CR>")
vim.keymap.set('n', '<leader>d', ":lua vim.diagnostic.open_float()<CR>")
vim.keymap.set('n', '<leader>gB', ":lua Snacks.gitbrowse()<CR>")
vim.keymap.set('n', '<leader>gg', ":lua Snacks.lazygit()<CR>")

vim.lsp.config('rust_analyzer', {
  settings = {
    ['rust-analyzer'] = {
      cargo = {
        checkOnSave = {
          command = "clippy",          -- This is correct
          extraArgs = {"--all-targets","--all-features","--","-D","warnings"}
        },
      },
    },
  },
})
-- vim.lsp.config('clangd', {
--   cmd = { 'clangd','--background-index', '--clang-tidy' },
-- })

vim.lsp.enable('clangd')
vim.lsp.enable('gopls')
vim.lsp.enable('lua_ls')
vim.lsp.enable('rust_analyzer')

-- Set `:make` to run cargo clippy
vim.api.nvim_create_autocmd("FileType", {
  pattern = "rust",
  callback = function()
    -- Use cargo clippy
    vim.bo.makeprg = "cargo clippy --message-format=json --all-targets --all-features"
    -- Use errorformat for Clippy messages
    vim.bo.errorformat = "%f:%l:%c: %t%*[^:]: %m"
  end,
})
vim.keymap.set('n', 'grn', vim.lsp.buf.rename, { desc = '[R]e[n]ame' })
vim.keymap.set('n', 'gra', vim.lsp.buf.code_action, { desc = '[G]oto Code [A]ction' })
vim.keymap.set('n', 'grr', vim.lsp.buf.references, { desc = '[G]oto [R]eferences' })
vim.keymap.set('n', 'gri', vim.lsp.buf.implementation, { desc = '[G]oto [I]mplementation' })
vim.keymap.set('n', 'grd', vim.lsp.buf.definition, { desc = '[G]oto [D]efinition' })
vim.keymap.set('n', 'grD', vim.lsp.buf.declaration, { desc = '[G]oto [D]eclaration' })
vim.keymap.set('n', 'gO', vim.lsp.buf.document_symbol, { desc = 'Open Document Symbols' })
vim.keymap.set('n', 'gW', vim.lsp.buf.workspace_symbol, { desc = 'Open Workspace Symbols' })
-- vim.keymap.set('grt', require('telescope.builtin').lsp_type_definitions, '[G]oto [T]ype Definition')


require("plenary")
require("diffview").setup()
require("gitlab").setup()
require("dressing").setup()

require "snacks".setup {
  gitbrowse = {
    open = function(url)
      vim.ui.open(url)
    end,
  },
  ui = { enabled = true },
  input = { enabled = true },
  lazygit = { enabled = true },
  quickfile = { enabled = true },
  gh = {
  },
  picker = {
    sources = {
      gh_issue = {
      },
      gh_pr = {
      }
    }
  },
}
require 'nvim-treesitter'.setup {
  -- A list of parser names, or "all" (the listed parsers MUST always be installed)
  ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline" },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = true,

  -- List of parsers to ignore installing (or "all")
  ignore_install = { "javascript", "org" },

  ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
  -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

  highlight = {
    enable = true,

    -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
    -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
    -- the name of the parser)
    -- list of language that will be disabled
    --disable = { "c", "rust" },
    -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
    disable = function(lang, buf)
      local max_filesize = 100 * 1024 -- 100 KB
      local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
      if ok and stats and stats.size > max_filesize then
        return true
      end
    end,

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}

require('guess-indent').setup({
  auto_cmd = true, -- Set to false to disable automatic execution
  override_editorconfig = false,
})
require('gitsigns').setup {
  signs = {
    add = { text = '+' },
    change = { text = '~' },
    delete = { text = '_' },
    topdelete = { text = '‾' },
    changedelete = { text = '~' },
  },
}

require('which-key').setup {
  event = 'VimEnter', -- Sets the loading event to 'VimEnter'
  -- delay between pressing a key and opening which-key (milliseconds)
  -- this setting is independent of vim.o.timeoutlen
  delay = 0,
  icons = {
    -- set icon mappings to true if you have a Nerd Font
    mappings = vim.g.have_nerd_font,
    -- If you are using a Nerd Font: set icons.keys to an empty table which will use the
    -- default which-key.nvim defined Nerd Font icons, otherwise define a string table
    keys = vim.g.have_nerd_font and {} or {
      Up = '<Up> ',
      Down = '<Down> ',
      Left = '<Left> ',
      Right = '<Right> ',
      C = '<C-…> ',
      M = '<M-…> ',
      D = '<D-…> ',
      S = '<S-…> ',
      CR = '<CR> ',
      Esc = '<Esc> ',
      ScrollWheelDown = '<ScrollWheelDown> ',
      ScrollWheelUp = '<ScrollWheelUp> ',
      NL = '<NL> ',
      BS = '<BS> ',
      Space = '<Space> ',
      Tab = '<Tab> ',
      F1 = '<F1>',
      F2 = '<F2>',
      F3 = '<F3>',
      F4 = '<F4>',
      F5 = '<F5>',
      F6 = '<F6>',
      F7 = '<F7>',
      F8 = '<F8>',
      F9 = '<F9>',
      F10 = '<F10>',
      F11 = '<F11>',
      F12 = '<F12>',
    },
  },

  -- Document existing key chains
  spec = {
    { '<leader>s', group = '[S]earch' },
    { '<leader>t', group = '[T]oggle' },
    { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
  },
}
require("conform").setup({
  format_after_save = {
    lsp_format = "fallback",
  },
  formatters_by_ft = {
    lua = { "stylua" },
    cpp = { "clang-format" },
    -- Conform will run multiple formatters sequentially
    python = { "isort", "black" },
    -- You can customize some of the format options for the filetype (:help conform.format)
    rust = { "rustfmt", lsp_format = "fallback" },
    -- Conform will run the first available formatter
    javascript = { "prettierd", "prettier", stop_after_first = true },
  },
})

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function(args)
    require("conform").format({ bufnr = args.buf })
  end,
})
require("lazydev").setup({
  ft = "lua",
  opts = {
    library = {
      -- Load luvit types when the `vim.uv` word is found
      { path = "${3rd}/luv/library", words = { "vim%.uv" } },
    },
  },
})

--TODO: renable snippets
-- { -- Autocompletion
--   'saghen/blink.cmp',
require('blink.cmp').setup({
  --event = 'VimEnter',
  --version = '1.*',
  -- dependencies = {
  --   -- Snippet Engine
  --   {
  --   --   'L3MON4D3/LuaSnip',
  --   --   version = '2.*',
  --   --   build = (function()
  --   --     -- Build Step is needed for regex support in snippets.
  --   --     -- This step is not supported in many windows environments.
  --   --     -- Remove the below condition to re-enable on windows.
  --   --     if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
  --   --       return
  --   --     end
  --   --     return 'make install_jsregexp'
  --   --   end)(),
  --   --   dependencies = {
  --   --     -- `friendly-snippets` contains a variety of premade snippets.
  --   --     --    See the README about individual language/framework/plugin snippets:
  --   --     --    https://github.com/rafamadriz/friendly-snippets
  --   --     -- {
  --   --     --   'rafamadriz/friendly-snippets',
  --   --     --   config = function()
  --   --     --     require('luasnip.loaders.from_vscode').lazy_load()
  --   --     --   end,
  --   --     -- },
  --   --   },
  --   --   opts = {},
  --    },
  --    'folke/lazydev.nvim',
  -- },
  --- @module 'blink.cmp'
  --- @type blink.cmp.Config
  keymap = {
    -- 'default' (recommended) for mappings similar to built-in completions
    --   <c-y> to accept ([y]es) the completion.
    --    This will auto-import if your LSP supports it.
    --    This will expand snippets if the LSP sent a snippet.
    -- 'super-tab' for tab to accept
    -- 'enter' for enter to accept
    -- 'none' for no mappings
    --
    -- For an understanding of why the 'default' preset is recommended,
    -- you will need to read `:help ins-completion`
    --
    -- No, but seriously. Please read `:help ins-completion`, it is really good!
    --
    -- All presets have the following mappings:
    -- <tab>/<s-tab>: move to right/left of your snippet expansion
    -- <c-space>: Open menu or open docs if already open
    -- <c-n>/<c-p> or <up>/<down>: Select next/previous item
    -- <c-e>: Hide menu
    -- <c-k>: Toggle signature help
    --
    -- See :h blink-cmp-config-keymap for defining your own keymap
    preset = 'default',

    -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
    --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
  },

  appearance = {
    -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
    -- Adjusts spacing to ensure icons are aligned
    nerd_font_variant = 'mono',
  },

  completion = {
    -- By default, you may press `<c-space>` to show the documentation.
    -- Optionally, set `auto_show = true` to show the documentation after a delay.
    documentation = { auto_show = false, auto_show_delay_ms = 500 },
  },

  sources = {
    default = { 'lsp', 'path', 'snippets' },
    providers = {
      lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 },
    },
  },

  --snippets = { preset = 'luasnip' },


  -- Blink.cmp includes an optional, recommended rust fuzzy matcher,
  -- which automatically downloads a prebuilt binary when enabled.
  --
  -- By default, we use the Lua implementation instead, but you may enable
  -- the rust implementation via `'prefer_rust_with_warning'`
  --
  -- See :h blink-cmp-config-fuzzy for more information
  fuzzy = {
    -- Controls which implementation to use for the fuzzy matcher.
    --
    -- 'prefer_rust_with_warning' (Recommended) If available, use the Rust implementation, automatically downloading prebuilt binaries on supported systems. Fallback to the Lua implementation when not available, emitting a warning message.
    -- 'prefer_rust' If available, use the Rust implementation, automatically downloading prebuilt binaries on supported systems. Fallback to the Lua implementation when not available.
    -- 'rust' Always use the Rust implementation, automatically downloading prebuilt binaries on supported systems. Error if not available.
    -- 'lua' Always use the Lua implementation, doesn't download any prebuilt binaries
    --
    -- See the prebuilt_binaries section for controlling the download behavior
    implementation = 'prefer_rust_with_warning',

    -- Allows for a number of typos relative to the length of the query
    -- Set this to 0 to match the behavior of fzf
    -- Note, this does not apply when using the Lua implementation.
    max_typos = function(keyword) return math.floor(#keyword / 4) end,

    -- Frecency tracks the most recently/frequently used items and boosts the score of the item
    -- Note, this does not apply when using the Lua implementation.
    --

    -- Proximity bonus boosts the score of items matching nearby words
    -- Note, this does not apply when using the Lua implementation.
    use_proximity = true,

    -- UNSAFE!! When enabled, disables the lock and fsync when writing to the frecency database. This should only be used on unsupported platforms (i.e. alpine termux)
    -- Note, this does not apply when using the Lua implementation.
    --use_unsafe_no_lock = false,

    -- Controls which sorts to use and in which order, falling back to the next sort if the first one returns nil
    -- You may pass a function instead of a string to customize the sorting
    sorts = {
      -- (optionally) always prioritize exact matches
      -- 'exact',

      -- pass a function for custom behavior
      -- function(item_a, item_b)
      --   return item_a.score > item_b.score
      -- end,

      'score',
      'sort_text',
    },

    prebuilt_binaries = {
      -- Whether or not to automatically download a prebuilt binary from github. If this is set to `false`,
      -- you will need to manually build the fuzzy binary dependencies by running `cargo build --release`
      -- Disabled by default when `fuzzy.implementation = 'lua'`
      download = true,

      -- Ignores mismatched version between the built binary and the current git sha, when building locally
      ignore_version_mismatch = false,

      -- When downloading a prebuilt binary, force the downloader to resolve this version. If this is unset
      -- then the downloader will attempt to infer the version from the checked out git tag (if any).
      --
      -- Beware that if the fuzzy matcher changes while tracking main then this may result in blink breaking.
      force_version = nil,

      -- When downloading a prebuilt binary, force the downloader to use this system triple. If this is unset
      -- then the downloader will attempt to infer the system triple from `jit.os` and `jit.arch`.
      -- Check the latest release for all available system triples
      --
      -- Beware that if the fuzzy matcher changes while tracking main then this may result in blink breaking.
      force_system_triple = nil,

      -- Extra arguments that will be passed to curl like { 'curl', ..extra_curl_args, ..built_in_args }
      extra_curl_args = {},

      proxy = {
        -- When downloading a prebuilt binary, use the HTTPS_PROXY environment variable
        from_env = true,

        -- When downloading a prebuilt binary, use this proxy URL. This will ignore the HTTPS_PROXY environment variable
        url = nil,
      },
    },
  },

  -- Shows a signature help window while you type arguments for a function
  signature = { enabled = true },
}
)

-- Highlight todo, notes, etc in comments
require("todo-comments").setup({
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
  }
})

-- NOTE: Plugins can also be configured to run Lua code when they are loaded.
--
-- This is often very useful to both group configuration, as well as handle
-- lazy loading plugins that don't need to be loaded immediately at startup.
--
-- For example, in the following configuration, we use:
--  event = 'VimEnter'
--
-- which loads which-key before all the UI elements are loaded. Events can be
-- normal autocommands events (`:help autocmd-events`).
--
-- Then, because we use the `opts` key (recommended), the configuration runs
-- after the plugin has been loaded as `require(MODULE).setup(opts)`.

--TODO: enable min or treesitter textobjects
-- { -- Collection of various small independent plugins/modules
--   'echasnovski/mini.nvim',
--   config = function()
--     -- Better Around/Inside textobjects
--     --
--     -- Examples:
--     --  - va)  - [V]isually select [A]round [)]paren
--     --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
--     --  - ci'  - [C]hange [I]nside [']quote
--     require('mini.ai').setup { n_lines = 500 }
--
--     -- Add/delete/replace surroundings (brackets, quotes, etc.)
--     --
--     -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
--     -- - sd'   - [S]urround [D]elete [']quotes
--     -- - sr)'  - [S]urround [R]eplace [)] [']
--     require('mini.surround').setup()
--
--     -- Simple and easy statusline.
--     --  You could remove this setup call if you don't like it,
--     --  and try some other statusline plugin
--     local statusline = require 'mini.statusline'
--     -- set use_icons to true if you have a Nerd Font
--     statusline.setup { use_icons = vim.g.have_nerd_font }
--
--     -- You can configure sections in the statusline by overriding their
--     -- default behavior. For example, here we set the section for
--     -- cursor location to LINE:COLUMN
--     ---@diagnostic disable-next-line: duplicate-set-field
--     statusline.section_location = function()
--       return '%2l:%-2v'
--     end
--
--     -- ... and there is more!
--     --  Check out: https://github.com/echasnovski/mini.nvim
--   end,
-- },
