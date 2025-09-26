vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true
vim.o.number = true
vim.o.relativenumber=true
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
  { src = 'https://github.com/stevearc/conform.nvim'},
  { src = 'https://github.com/saghen/blink.cmp' },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
  { src = 'https://github.com/folke/tokyonight.nvim' },
  { src = "https://github.com/neanias/everforest-nvim",version="main" },
	{ src = "https://github.com/stevearc/oil.nvim" },
{ src = "https://github.com/echasnovski/mini.pick" },
{src="https://github.com/folke/todo-comments.nvim.git"},
}

require("custom.plugins").setup()
require "mini.pick".setup()
require "oil".setup()

vim.keymap.set('n', '<leader>sf', ":Pick files<CR>")
vim.keymap.set('n', '<leader><leader>', ":Pick buffers<CR>")
vim.keymap.set('n', '<leader>sg', ":Pick grep_live<CR>")
vim.lsp.enable('clangd')
vim.lsp.enable('gopls')
vim.lsp.enable('lua_ls')

require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all" (the listed parsers MUST always be installed)
  ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline" },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = true,

  -- List of parsers to ignore installing (or "all")
  ignore_install = { "javascript","org" },

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
-- { -- Highlight, edit, and navigate code
-- require('nvim-treesitter/nvim-treesitter').setup({
--   build = ':TSUpdate',
--   main = 'nvim-treesitter.configs', -- Sets main module to use for opts
--   -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
--   opts = {
--     ensure_installed = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc' },
--     -- Autoinstall languages that are not installed
--     auto_install = true,
--     highlight = {
--       enable = true,
--       -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
--       --  If you are experiencing weird indenting issues, add the language to
--       --  the list of additional_vim_regex_highlighting and disabled languages for indent.
--       additional_vim_regex_highlighting = { 'ruby' },
--     },
--     indent = { enable = true, disable = { 'ruby' } },
--   },
--   -- There are additional nvim-treesitter modules that you can use to interact
--   -- with nvim-treesitter. You should go explore a few and see what interests you:
--   --
--   --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
--   --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
--   --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
-- }
--)

require('guess-indent').setup({
  auto_cmd = true,  -- Set to false to disable automatic execution
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
    cpp={"clang-format"},
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
-- { -- Autoformat
--   'stevearc/conform.nvim',
-- require('conform').setup({
--   event = { 'BufWritePre' },
--   cmd = { 'ConformInfo' },
--   keys = {
--     {
--       '<leader>f',
--       function()
--         require('conform').format { async = true, lsp_format = 'fallback' }
--       end,
--       mode = '',
--       desc = '[F]ormat buffer',
--     },
--   },
--   opts = {
--     notify_on_error = false,
--     format_on_save = function(bufnr)
--       -- Disable "format_on_save lsp_fallback" for languages that don't
--       -- have a well standardized coding style. You can add additional
--       -- languages here or re-enable it for the disabled ones.
--       local disable_filetypes = { c = true, cpp = true }
--       if disable_filetypes[vim.bo[bufnr].filetype] then
--         return nil
--       else
--         return {
--           timeout_ms = 500,
--           lsp_format = 'fallback',
--         }
--       end
--     end,
--     formatters_by_ft = {
--       lua = { 'stylua' },
--       -- Conform can also run multiple formatters sequentially
--       -- python = { "isort", "black" },
--       --
--       -- You can use 'stop_after_first' to run the first available formatter from the list
--       -- javascript = { "prettierd", "prettier", stop_after_first = true },
--     },
--   },
-- })
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
        --lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 },
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
-- { -- You can easily change to a different colorscheme.
--   -- Change the name of the colorscheme plugin below, and then
--   -- change the command in the config to whatever the name of that colorscheme is.
--   --
--   -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
-- require('tokyonight').setup({
--       styles = {
--         comments = { italic = false }, -- Disable italics in comments
--     }
--
--     -- Load the colorscheme here.
--     -- Like many other themes, this one has different styles, and you could load
--     -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
--  })

  --vim.cmd.colorscheme 'tokyonight-night'
  vim.cmd.colorscheme 'everforest'

-- Highlight todo, notes, etc in comments
 require( "todo-comments").setup({
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
  }
})

-- Here is a more advanced example where we pass configuration
-- options to `gitsigns.nvim`.
--
-- See `:help gitsigns` to understand what the configuration keys do
-- { -- Adds git related signs to the gutter, as well as utilities for managing changes
--   'lewis6991/gitsigns.nvim',
--   opts = {
--     signs = {
--       add = { text = '+' },
--       change = { text = '~' },
--       delete = { text = '_' },
--       topdelete = { text = '‾' },
--       changedelete = { text = '~' },
--     },
--   },
-- },

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

-- { -- Useful plugin to show you pending keybinds.
--   'folke/which-key.nvim',
--   event = 'VimEnter', -- Sets the loading event to 'VimEnter'
--   opts = {
--     -- delay between pressing a key and opening which-key (milliseconds)
--     -- this setting is independent of vim.o.timeoutlen
--     delay = 0,
--     icons = {
--       -- set icon mappings to true if you have a Nerd Font
--       mappings = vim.g.have_nerd_font,
--       -- If you are using a Nerd Font: set icons.keys to an empty table which will use the
--       -- default which-key.nvim defined Nerd Font icons, otherwise define a string table
--       keys = vim.g.have_nerd_font and {} or {
--         Up = '<Up> ',
--         Down = '<Down> ',
--         Left = '<Left> ',
--         Right = '<Right> ',
--         C = '<C-…> ',
--         M = '<M-…> ',
--         D = '<D-…> ',
--         S = '<S-…> ',
--         CR = '<CR> ',
--         Esc = '<Esc> ',
--         ScrollWheelDown = '<ScrollWheelDown> ',
--         ScrollWheelUp = '<ScrollWheelUp> ',
--         NL = '<NL> ',
--         BS = '<BS> ',
--         Space = '<Space> ',
--         Tab = '<Tab> ',
--         F1 = '<F1>',
--         F2 = '<F2>',
--         F3 = '<F3>',
--         F4 = '<F4>',
--         F5 = '<F5>',
--         F6 = '<F6>',
--         F7 = '<F7>',
--         F8 = '<F8>',
--         F9 = '<F9>',
--         F10 = '<F10>',
--         F11 = '<F11>',
--         F12 = '<F12>',
--       },
--     },
--
--     -- Document existing key chains
--     spec = {
--       { '<leader>s', group = '[S]earch' },
--       { '<leader>t', group = '[T]oggle' },
--       { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
--     },
--   },
-- },

-- NOTE: Plugins can specify dependencies.
--
-- The dependencies are proper plugin specifications as well - anything
-- you do for a plugin at the top level, you can do for a dependency.
--
-- Use the `dependencies` key to specify the dependencies of a particular plugin

-- { -- Fuzzy Finder (files, lsp, etc)
--   'nvim-telescope/telescope.nvim',
--   event = 'VimEnter',
--   dependencies = {
--     'nvim-lua/plenary.nvim',
--     { -- If encountering errors, see telescope-fzf-native README for installation instructions
--       'nvim-telescope/telescope-fzf-native.nvim',
--
--       -- `build` is used to run some command when the plugin is installed/updated.
--       -- This is only run then, not every time Neovim starts up.
--       build = 'make',
--
--       -- `cond` is a condition used to determine whether this plugin should be
--       -- installed and loaded.
--       cond = function()
--         return vim.fn.executable 'make' == 1
--       end,
--     },
--     { 'nvim-telescope/telescope-ui-select.nvim' },
--
--     -- Useful for getting pretty icons, but requires a Nerd Font.
--     { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
--   },
--   config = function()
--     -- Telescope is a fuzzy finder that comes with a lot of different things that
--     -- it can fuzzy find! It's more than just a "file finder", it can search
--     -- many different aspects of Neovim, your workspace, LSP, and more!
--     --
--     -- The easiest way to use Telescope, is to start by doing something like:
--     --  :Telescope help_tags
--     --
--     -- After running this command, a window will open up and you're able to
--     -- type in the prompt window. You'll see a list of `help_tags` options and
--     -- a corresponding preview of the help.
--     --
--     -- Two important keymaps to use while in Telescope are:
--     --  - Insert mode: <c-/>
--     --  - Normal mode: ?
--     --
--     -- This opens a window that shows you all of the keymaps for the current
--     -- Telescope picker. This is really useful to discover what Telescope can
--     -- do as well as how to actually do it!
--
--     -- [[ Configure Telescope ]]
--     -- See `:help telescope` and `:help telescope.setup()`
--     require('telescope').setup {
--       -- You can put your default mappings / updates / etc. in here
--       --  All the info you're looking for is in `:help telescope.setup()`
--       --
--       -- defaults = {
--       --   mappings = {
--       --     i = { ['<c-enter>'] = 'to_fuzzy_refine' },
--       --   },
--       -- },
--       -- pickers = {}
--       extensions = {
--         ['ui-select'] = {
--           require('telescope.themes').get_dropdown(),
--         },
--       },
--     }
--
--     -- Enable Telescope extensions if they are installed
--     pcall(require('telescope').load_extension, 'fzf')
--     pcall(require('telescope').load_extension, 'ui-select')
--
--     -- See `:help telescope.builtin`
--     local builtin = require 'telescope.builtin'
--     vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
--     vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
--     vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
--     vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
--     vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
--     vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
--     vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
--     vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
--     vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
--     vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })
--
--     -- Slightly advanced example of overriding default behavior and theme
--     vim.keymap.set('n', '<leader>/', function()
--       -- You can pass additional configuration to Telescope to change the theme, layout, etc.
--       builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
--         winblend = 10,
--         previewer = false,
--       })
--     end, { desc = '[/] Fuzzily search in current buffer' })
--
--     -- It's also possible to pass additional configuration options.
--     --  See `:help telescope.builtin.live_grep()` for information about particular keys
--     vim.keymap.set('n', '<leader>s/', function()
--       builtin.live_grep {
--         grep_open_files = true,
--         prompt_title = 'Live Grep in Open Files',
--       }
--     end, { desc = '[S]earch [/] in Open Files' })
--
--     -- Shortcut for searching your Neovim configuration files
--     vim.keymap.set('n', '<leader>sn', function()
--       builtin.find_files { cwd = vim.fn.stdpath 'config' }
--     end, { desc = '[S]earch [N]eovim files' })
--   end,
-- },

-- LSP Plugins
-- {
--   -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
--   -- used for completion, annotations and signatures of Neovim apis
--   'folke/lazydev.nvim',
--   ft = 'lua',
--   opts = {
--     library = {
--       -- Load luvit types when the `vim.uv` word is found
--       { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
--     },
--   },
-- },
-- {
-- Main LSP Configuration
--   'neovim/nvim-lspconfig',
--   dependencies = {
--     -- Automatically install LSPs and related tools to stdpath for Neovim
--     -- Mason must be loaded before its dependents so we need to set it up here.
--     -- NOTE: `opts = {}` is the same as calling `require('mason').setup({})`
--     { 'mason-org/mason.nvim', opts = {} },
--     'mason-org/mason-lspconfig.nvim',
--     'WhoIsSethDaniel/mason-tool-installer.nvim',
--
--     -- Useful status updates for LSP.
--     { 'j-hui/fidget.nvim', opts = {} },
--
--     -- Allows extra capabilities provided by blink.cmp
--     'saghen/blink.cmp',
--   },
--   config = function()
--     -- Brief aside: **What is LSP?**
--     --
--     -- LSP is an initialism you've probably heard, but might not understand what it is.
--     --
--     -- LSP stands for Language Server Protocol. It's a protocol that helps editors
--     -- and language tooling communicate in a standardized fashion.
--     --
--     -- In general, you have a "server" which is some tool built to understand a particular
--     -- language (such as `gopls`, `lua_ls`, `rust_analyzer`, etc.). These Language Servers
--     -- (sometimes called LSP servers, but that's kind of like ATM Machine) are standalone
--     -- processes that communicate with some "client" - in this case, Neovim!
--     --
--     -- LSP provides Neovim with features like:
--     --  - Go to definition
--     --  - Find references
--     --  - Autocompletion
--     --  - Symbol Search
--     --  - and more!
--     --
--     -- Thus, Language Servers are external tools that must be installed separately from
--     -- Neovim. This is where `mason` and related plugins come into play.
--     --
--     -- If you're wondering about lsp vs treesitter, you can check out the wonderfully
--     -- and elegantly composed help section, `:help lsp-vs-treesitter`
--
--     --  This function gets run when an LSP attaches to a particular buffer.
--     --    That is to say, every time a new file is opened that is associated with
--     --    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
--     --    function will be executed to configure the current buffer
--     vim.api.nvim_create_autocmd('LspAttach', {
--       group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
--       callback = function(event)
--         -- NOTE: Remember that Lua is a real programming language, and as such it is possible
--         -- to define small helper and utility functions so you don't have to repeat yourself.
--         --
--         -- In this case, we create a function that lets us more easily define mappings specific
--         -- for LSP related items. It sets the mode, buffer and description for us each time.
--         local map = function(keys, func, desc, mode)
--           mode = mode or 'n'
--           vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
--         end
--
--         -- Rename the variable under your cursor.
--         --  Most Language Servers support renaming across files, etc.
--         map('grn', vim.lsp.buf.rename, '[R]e[n]ame')
--
--         -- Execute a code action, usually your cursor needs to be on top of an error
--         -- or a suggestion from your LSP for this to activate.
--         map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })
--
--         -- Find references for the word under your cursor.
--         map('grr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
--
--         -- Jump to the implementation of the word under your cursor.
--         --  Useful when your language has ways of declaring types without an actual implementation.
--         map('gri', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
--
--         -- Jump to the definition of the word under your cursor.
--         --  This is where a variable was first declared, or where a function is defined, etc.
--         --  To jump back, press <C-t>.
--         map('grd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
--
--         -- WARN: This is not Goto Definition, this is Goto Declaration.
--         --  For example, in C this would take you to the header.
--         map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
--
--         -- Fuzzy find all the symbols in your current document.
--         --  Symbols are things like variables, functions, types, etc.
--         map('gO', require('telescope.builtin').lsp_document_symbols, 'Open Document Symbols')
--
--         -- Fuzzy find all the symbols in your current workspace.
--         --  Similar to document symbols, except searches over your entire project.
--         map('gW', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Open Workspace Symbols')
--
--         -- Jump to the type of the word under your cursor.
--         --  Useful when you're not sure what type a variable is and you want to see
--         --  the definition of its *type*, not where it was *defined*.
--         map('grt', require('telescope.builtin').lsp_type_definitions, '[G]oto [T]ype Definition')
--
--         -- This function resolves a difference between neovim nightly (version 0.11) and stable (version 0.10)
--         ---@param client vim.lsp.Client
--         ---@param method vim.lsp.protocol.Method
--         ---@param bufnr? integer some lsp support methods only in specific files
--         ---@return boolean
--         local function client_supports_method(client, method, bufnr)
--           if vim.fn.has 'nvim-0.11' == 1 then
--             return client:supports_method(method, bufnr)
--           else
--             return client.supports_method(method, { bufnr = bufnr })
--           end
--         end
--
--         -- The following two autocommands are used to highlight references of the
--         -- word under your cursor when your cursor rests there for a little while.
--         --    See `:help CursorHold` for information about when this is executed
--         --
--         -- When you move your cursor, the highlights will be cleared (the second autocommand).
--         local client = vim.lsp.get_client_by_id(event.data.client_id)
--         if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
--           local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
--           vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
--             buffer = event.buf,
--             group = highlight_augroup,
--             callback = vim.lsp.buf.document_highlight,
--           })
--
--           vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
--             buffer = event.buf,
--             group = highlight_augroup,
--             callback = vim.lsp.buf.clear_references,
--           })
--
--           vim.api.nvim_create_autocmd('LspDetach', {
--             group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
--             callback = function(event2)
--               vim.lsp.buf.clear_references()
--               vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
--             end,
--           })
--         end
--
--         -- The following code creates a keymap to toggle inlay hints in your
--         -- code, if the language server you are using supports them
--         --
--         -- This may be unwanted, since they displace some of your code
--         if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
--           map('<leader>th', function()
--             vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
--           end, '[T]oggle Inlay [H]ints')
--         end
--       end,
--     })
--
--     -- Diagnostic Config
--     -- See :help vim.diagnostic.Opts
--     vim.diagnostic.config {
--       severity_sort = true,
--       float = { border = 'rounded', source = 'if_many' },
--       underline = { severity = vim.diagnostic.severity.ERROR },
--       signs = vim.g.have_nerd_font and {
--         text = {
--           [vim.diagnostic.severity.ERROR] = '󰅚 ',
--           [vim.diagnostic.severity.WARN] = '󰀪 ',
--           [vim.diagnostic.severity.INFO] = '󰋽 ',
--           [vim.diagnostic.severity.HINT] = '󰌶 ',
--         },
--       } or {},
--       virtual_text = {
--         source = 'if_many',
--         spacing = 2,
--         format = function(diagnostic)
--           local diagnostic_message = {
--             [vim.diagnostic.severity.ERROR] = diagnostic.message,
--             [vim.diagnostic.severity.WARN] = diagnostic.message,
--             [vim.diagnostic.severity.INFO] = diagnostic.message,
--             [vim.diagnostic.severity.HINT] = diagnostic.message,
--           }
--           return diagnostic_message[diagnostic.severity]
--         end,
--       },
--     }
--
--     -- LSP servers and clients are able to communicate to each other what features they support.
--     --  By default, Neovim doesn't support everything that is in the LSP specification.
--     --  When you add blink.cmp, luasnip, etc. Neovim now has *more* capabilities.
--     --  So, we create new capabilities with blink.cmp, and then broadcast that to the servers.
--     local capabilities = require('blink.cmp').get_lsp_capabilities()
--
--     -- Enable the following language servers
--     --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--     --
--     --  Add any additional override configuration in the following tables. Available keys are:
--     --  - cmd (table): Override the default command used to start the server
--     --  - filetypes (table): Override the default list of associated filetypes for the server
--     --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
--     --  - settings (table): Override the default settings passed when initializing the server.
--     --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
--     local servers = {
--       -- clangd = {},
--       -- gopls = {},
--       -- pyright = {},
--       -- rust_analyzer = {},
--       -- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
--       --
--       -- Some languages (like typescript) have entire language plugins that can be useful:
--       --    https://github.com/pmizio/typescript-tools.nvim
--       --
--       -- But for many setups, the LSP (`ts_ls`) will work just fine
--       -- ts_ls = {},
--       --
--
--       lua_ls = {
--         -- cmd = { ... },
--         -- filetypes = { ... },
--         -- capabilities = {},
--         settings = {
--           Lua = {
--             completion = {
--               callSnippet = 'Replace',
--             },
--             -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
--             -- diagnostics = { disable = { 'missing-fields' } },
--           },
--         },
--       },
--     }
--
--     -- Ensure the servers and tools above are installed
--     --
--     -- To check the current status of installed tools and/or manually install
--     -- other tools, you can run
--     --    :Mason
--     --
--     -- You can press `g?` for help in this menu.
--     --
--     -- `mason` had to be setup earlier: to configure its options see the
--     -- `dependencies` table for `nvim-lspconfig` above.
--     --
--     -- You can add other tools here that you want Mason to install
--     -- for you, so that they are available from within Neovim.
--     local ensure_installed = vim.tbl_keys(servers or {})
--     vim.list_extend(ensure_installed, {
--       'stylua', -- Used to format Lua code
--     })
--     require('mason-tool-installer').setup { ensure_installed = ensure_installed }
--
--     require('mason-lspconfig').setup {
--       ensure_installed = {}, -- explicitly set to an empty table (Kickstart populates installs via mason-tool-installer)
--       automatic_installation = false,
--       handlers = {
--         function(server_name)
--           local server = servers[server_name] or {}
--           -- This handles overriding only values explicitly passed
--           -- by the server configuration above. Useful when disabling
--           -- certain features of an LSP (for example, turning off formatting for ts_ls)
--           server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
--           require('lspconfig')[server_name].setup(server)
--         end,
--       },
--     }
--   end,
-- },
--
-- { -- Autoformat
--   'stevearc/conform.nvim',
--   event = { 'BufWritePre' },
--   cmd = { 'ConformInfo' },
--   keys = {
--     {
--       '<leader>f',
--       function()
--         require('conform').format { async = true, lsp_format = 'fallback' }
--       end,
--       mode = '',
--       desc = '[F]ormat buffer',
--     },
--   },
--   opts = {
--     notify_on_error = false,
--     format_on_save = function(bufnr)
--       -- Disable "format_on_save lsp_fallback" for languages that don't
--       -- have a well standardized coding style. You can add additional
--       -- languages here or re-enable it for the disabled ones.
--       local disable_filetypes = { c = true, cpp = true }
--       if disable_filetypes[vim.bo[bufnr].filetype] then
--         return nil
--       else
--         return {
--           timeout_ms = 500,
--           lsp_format = 'fallback',
--         }
--       end
--     end,
--     formatters_by_ft = {
--       lua = { 'stylua' },
--       -- Conform can also run multiple formatters sequentially
--       -- python = { "isort", "black" },
--       --
--       -- You can use 'stop_after_first' to run the first available formatter from the list
--       -- javascript = { "prettierd", "prettier", stop_after_first = true },
--     },
--   },
-- },

-- { -- Autocompletion
--   'saghen/blink.cmp',
--   event = 'VimEnter',
--   version = '1.*',
--   dependencies = {
--     -- Snippet Engine
--     {
--       'L3MON4D3/LuaSnip',
--       version = '2.*',
--       build = (function()
--         -- Build Step is needed for regex support in snippets.
--         -- This step is not supported in many windows environments.
--         -- Remove the below condition to re-enable on windows.
--         if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
--           return
--         end
--         return 'make install_jsregexp'
--       end)(),
--       dependencies = {
--         -- `friendly-snippets` contains a variety of premade snippets.
--         --    See the README about individual language/framework/plugin snippets:
--         --    https://github.com/rafamadriz/friendly-snippets
--         -- {
--         --   'rafamadriz/friendly-snippets',
--         --   config = function()
--         --     require('luasnip.loaders.from_vscode').lazy_load()
--         --   end,
--         -- },
--       },
--       opts = {},
--     },
--     'folke/lazydev.nvim',
--   },
--   --- @module 'blink.cmp'
--   --- @type blink.cmp.Config
--   opts = {
--     keymap = {
--       -- 'default' (recommended) for mappings similar to built-in completions
--       --   <c-y> to accept ([y]es) the completion.
--       --    This will auto-import if your LSP supports it.
--       --    This will expand snippets if the LSP sent a snippet.
--       -- 'super-tab' for tab to accept
--       -- 'enter' for enter to accept
--       -- 'none' for no mappings
--       --
--       -- For an understanding of why the 'default' preset is recommended,
--       -- you will need to read `:help ins-completion`
--       --
--       -- No, but seriously. Please read `:help ins-completion`, it is really good!
--       --
--       -- All presets have the following mappings:
--       -- <tab>/<s-tab>: move to right/left of your snippet expansion
--       -- <c-space>: Open menu or open docs if already open
--       -- <c-n>/<c-p> or <up>/<down>: Select next/previous item
--       -- <c-e>: Hide menu
--       -- <c-k>: Toggle signature help
--       --
--       -- See :h blink-cmp-config-keymap for defining your own keymap
--       preset = 'default',
--
--       -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
--       --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
--     },
--
--     appearance = {
--       -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
--       -- Adjusts spacing to ensure icons are aligned
--       nerd_font_variant = 'mono',
--     },
--
--     completion = {
--       -- By default, you may press `<c-space>` to show the documentation.
--       -- Optionally, set `auto_show = true` to show the documentation after a delay.
--       documentation = { auto_show = false, auto_show_delay_ms = 500 },
--     },
--
--     sources = {
--       default = { 'lsp', 'path', 'snippets', 'lazydev' },
--       providers = {
--         lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 },
--       },
--     },
--
--     snippets = { preset = 'luasnip' },
--
--     -- Blink.cmp includes an optional, recommended rust fuzzy matcher,
--     -- which automatically downloads a prebuilt binary when enabled.
--     --
--     -- By default, we use the Lua implementation instead, but you may enable
--     -- the rust implementation via `'prefer_rust_with_warning'`
--     --
--     -- See :h blink-cmp-config-fuzzy for more information
--     fuzzy = { implementation = 'lua' },
--
--     -- Shows a signature help window while you type arguments for a function
--     signature = { enabled = true },
--   },
-- },

-- { -- You can easily change to a different colorscheme.
--   -- Change the name of the colorscheme plugin below, and then
--   -- change the command in the config to whatever the name of that colorscheme is.
--   --
--   -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
--   'folke/tokyonight.nvim',
--   priority = 1000, -- Make sure to load this before all the other start plugins.
--   config = function()
--     ---@diagnostic disable-next-line: missing-fields
--     require('tokyonight').setup {
--       styles = {
--         comments = { italic = false }, -- Disable italics in comments
--       },
--     }
--
--     -- Load the colorscheme here.
--     -- Like many other themes, this one has different styles, and you could load
--     -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
--     vim.cmd.colorscheme 'tokyonight-night'
--   end,
-- }ACK-- Highlight todo, notes, etc in comments
--{ 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },

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
-- { -- Highlight, edit, and navigate code
--   'nvim-treesitter/nvim-treesitter',
--   build = ':TSUpdate',
--   main = 'nvim-treesitter.configs', -- Sets main module to use for opts
--   -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
--   opts = {
--     ensure_installed = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc' },
--     -- Autoinstall languages that are not installed
--     auto_install = true,
--     highlight = {
--       enable = true,
--       -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
--       --  If you are experiencing weird indenting issues, add the language to
--       --  the list of additional_vim_regex_highlighting and disabled languages for indent.
--       additional_vim_regex_highlighting = { 'ruby' },
--     },
--     indent = { enable = true, disable = { 'ruby' } },
--   },
--   -- There are additional nvim-treesitter modules that you can use to interact
--   -- with nvim-treesitter. You should go explore a few and see what interests you:
--   --
--   --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
--   --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
--   --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
-- },

-- The following comments only work if you have downloaded the kickstart repo, not just copy pasted the
-- init.lua. If you want these files, they are in the repository, so you can just download them and
-- place them in the correct locations.

-- NOTE: Next step on your Neovim journey: Add/Configure additional plugins for Kickstart
--
--  Here are some example plugins that I've included in the Kickstart repository.
--  Uncomment any of the lines below to enable them (you will need to restart nvim).
--
-- require 'kickstart.plugins.debug',
-- require 'kickstart.plugins.indent_line',
-- require 'kickstart.plugins.lint',
-- require 'kickstart.plugins.autopairs',
-- require 'kickstart.plugins.neo-tree',
-- require 'kickstart.plugins.gitsigns', -- adds gitsigns recommend keymaps

-- NOTE: The import below can automatically add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
--    This is the easiest way to modularize your config.
--
--  Uncomment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
-- { import = 'custom.plugins' },
--
-- For additional information with loading, sourcing and examples see `:help lazy.nvim-🔌-plugin-spec`
-- Or use telescope!
-- In normal mode type `<space>sh` then write `lazy.nvim-plugin`
-- you can continue same window with `<space>sr` which resumes last telescope search
--},
--{
--   ui = {
--     -- If you are using a Nerd Font: set icons to an empty table which will use the
--     -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
--     icons = vim.g.have_nerd_font and {} or {
--       cmd = '⌘',
--       config = '🛠',
--       event = '📅',
--       ft = '📂',
--       init = '⚙',
--       keys = '🗝',
--       plugin = '🔌',
--       runtime = '💻',
--       require = '🌙',
--       source = '📄',
--       start = '🚀',
--       task = '📌',
--       lazy = '💤 ',
--     },
--   },
-- })

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
