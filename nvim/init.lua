-- Key mapping.
--
-- Disable mouse support to make selecting text easier.
vim.opt.mouse = ''
-- Set the leader as <space>.
vim.g.mapleader = ' '
-- Remap common keys to save typing and shift keys.
vim.keymap.set("n", ";", ":", { noremap = true })
vim.keymap.set({"n", "v"}, "j", "gj", { noremap = true })
vim.keymap.set({"n", "v"}, "k", "gk", { noremap = true })
-- Remap jk -> Esc.
vim.keymap.set("i", "jk", "<Esc>", { noremap = true })
-- Use Alt-hjkl to move between splits.
local movement_keys = {"h", "j", "k", "l"}
for key_index = 1, #movement_keys do
    vim.keymap.set(
        {"", "i"},
        string.format("<M-%s>", movement_keys[key_index]),
        string.format("<Esc><C-w>%s", movement_keys[key_index]),
        { noremap = true }
    )
    vim.keymap.set(
        "t",
        string.format("<M-%s>", movement_keys[key_index]),
        string.format("<C-\\><C-n><C-w>%s", movement_keys[key_index]),
        { noremap = true }
    )
end
-- Remap `` so that it enters normal mode in neovim terminals.
vim.keymap.set("t", "``", "<C-\\><C-n>", { noremap = true })
-- Enter insert mode when entering a terminal window.
vim.api.nvim_create_autocmd({"BufEnter", "TermOpen"}, {pattern = "term://*",
command = "startinsert"})

-- Enable persistent undo tracking.
vim.opt.undodir = vim.fn.stdpath("data") .. 'undo'
vim.opt.undofile = true

-- Appearance
--
-- Enable nicer colors.
vim.opt.termguicolors = true
-- Enable the combined line number and sign column.
vim.opt.signcolumn = "number"
-- Show the line and column position at the bottom of the buffer.
vim.opt.ruler = true
-- Tell nvim that the background for the terminal is dark.
vim.opt.background = 'dark'
-- Use a visual bell instead of beeping.
vim.opt.visualbell = true
-- Show line numbers.
vim.opt.number = true

-- Windows and Splits
--
-- When switching to errors with quickfixes, consider open buffers, then
-- fallback to making
-- a vertical split.
vim.opt.switchbuf = {"useopen", "vsplit"}
-- Switch to the new split rather than staying in the existing buffer.
vim.opt.splitright = true
vim.opt.splitbelow = true
-- Do not make windows equal in size after a split, require a manual "Ctrl-W ="
-- to do so.
vim.opt.equalalways = false
-- Minimum number of lines above and below the cursor when scrolling.
vim.opt.scrolloff = 10

-- Spacing
--
-- Expand tab characters into spaces.
vim.opt.expandtab = true
-- Set the tab width to 4 characters by default.
vim.opt.tabstop = 4
vim.opt.softtabstop = 0
-- Number of spaces for each auto-indent.
vim.opt.shiftwidth = 4
-- Copy current indendation when making a new line.
vim.opt.copyindent = true
-- Perform smart indenting based on file language.
vim.opt.smartindent = true
-- Wrapped lines will be indented to match the original line.
vim.opt.breakindent = true

-- Searching
--
-- Enable highlighting text while searching.
vim.opt.hlsearch = true
vim.opt.incsearch = true
-- Press enter in normal mode to clear highlighted text.
vim.keymap.set("n", "<CR>", ":noh<CR>:<BS>", { noremap = true })
-- Do case-insenstive searches unless the search contains upper-case characters.
vim.opt.smartcase = true

-- Completion
--
-- Ignore case when completing filenames and directories.
vim.opt.wildignorecase = true
-- Infer case when doing completion in insert mode.
vim.opt.infercase = true

-- Setup plugin manager.
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Setup plugins.
require("lazy").setup({
    -- Better Ctrl-R in shells, fuzzy search for files in vim.
    {'junegunn/fzf', build = function()
        os.execute('./install --all --xdg')
      end
    },
    -- Dim inactive windows.
    {'sunjon/shade.nvim', config = {
      overlay_opacity = 66,
      opacity_step = 1,
      keys = {
        brightness_up    = '<C-Up>',
        brightness_down  = '<C-Down>',
        toggle           = '<Leader>s',
      }
    }},
    -- Edit directories in a vim-like buffer e.g. rename by editing a line and
    -- saving.
    {'stevearc/oil.nvim',
     -- Don't lazy-load this plugin.
     lazy = false,
     config = {},
     dependencies = { "nvim-tree/nvim-web-devicons" }},
    -- Trim whitespace on save.
    {'cappyzawa/trim.nvim', config = {}},
    -- Helpful icon support.
    {'nvim-tree/nvim-web-devicons'},
    -- Improve the status line appearance.
    {'nvim-lualine/lualine.nvim',
     config = {
         sections = {
            lualine_c = {
                -- Use filename and parent directory for active buffers.
                {'filename', path = 4},
                -- Add LSP status.
                -- XXX require('lsp-progress').progress,
            },
         },
         inactive_sections = {
            lualine_c = {
                -- Use relative path, not just filename, for inactive buffers.
                {'filename', path = 1},
            },
         },
     },
     dependencies = {
         "nvim-tree/nvim-web-devicons",
         "linrongbin16/lsp-progress.nvim",
     }
    },
    -- Lua utilities for plugins.
    {'nvim-lua/plenary.nvim'},
    -- Tree-sitter: provide language-aware features like highlighting and searching.
    {'nvim-treesitter/nvim-treesitter',
     build = function()
         vim.cmd('TSInstall all')
         vim.cmd('TSUpdate')
     end,
     config = {
         highlight = { enable = true },
     },
     init = function ()
         -- Enable code folding.
         vim.opt.foldmethod = 'expr'
         vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
         vim.opt.foldenable = false
         -- Save code fold state and restore when re-opening files.
         vim.api.nvim_create_autocmd('BufWinLeave', {pattern = '*', command = 'silent! mkview'})
         vim.api.nvim_create_autocmd('BufWinEnter', {pattern = '*', command = 'silent! loadview'})
     end
    },
    -- Fuzzy file finding and live grep in neovim.
    {'nvim-telescope/telescope.nvim', branch = '0.1.x',
      dependencies = {
          'nvim-lua/plenary.nvim',
          'nvim-tree/nvim-web-devicons',
          'nvim-treesitter/nvim-treesitter',
      },
      init = function()
          local builtin = require('telescope.builtin')
          vim.keymap.set('n', '<leader>f', builtin.find_files, {})
          vim.keymap.set('n', '<leader>g', builtin.live_grep, {})
          vim.keymap.set('n', '<leader>h', builtin.help_tags, {})
      end,
    },
    -- Restore the last cursor position when re-opening a file.
    {'vladdoster/remember.nvim', config = {}},
    -- When opening new files in nested terminals, replace the terminal buffer
    -- with a vim file buffer instead of making a nested neovim.
    {"willothy/flatten.nvim", config = {},
     -- Ensure that it runs first to minimize delay when opening file from terminal
     lazy = false,
     priority = 1001},
    -- A nice, dark colorscheme written in Lua with all the fancy neovim features
    -- (treesitter, LSP, etc.)
    {"bluz71/vim-moonfly-colors", name = "moonfly", lazy = false, priority = 1000,
     init = function()
         vim.cmd('colorscheme moonfly')
     end},
    -- Markdown preview in a browser.
    {"iamcco/markdown-preview.nvim",
     cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
     ft = { "markdown" },
     build = function() vim.fn["mkdp#util#install"]() end,
    },
    -- LSP (language-server-protocol) plugins. Mason manages installing third-party
    -- language servers.
    {"neovim/nvim-lspconfig"},
    {"williamboman/mason.nvim", config = {}},
    {"williamboman/mason-lspconfig.nvim",
     config = {
         ensure_installed = {
             'ansiblels',
             'asm_lsp',
             'bashls',
             'bufls',
             'clangd',
             'dockerls',
             'docker_compose_language_service',
             'flux_lsp',
             'golangci_lint_ls',
             'gopls',
             'html',
             'htmx',
             'jsonls',
             'ltex',
             'texlab',
             'lua_ls',
             'remark_ls',
             'jedi_language_server',
             'pyright',
             'pylsp',
             'rust_analyzer@nightly',
             'sqlls',
             'taplo',
             'vimls',
             'yamlls',
         },
         automatic_installation = true,
     },
     init = function()
        require('mason-lspconfig').setup_handlers {
            -- The first entry (without a key) will be the default handler
            -- and will be called for each installed server that doesn't have
            -- a dedicated handler.
            function (server_name) -- default handler (optional)
                require("lspconfig")[server_name].setup {}
            end,
            -- XXX vim global in init.lua
            -- Next, you can provide a dedicated handler for specific servers.
            -- For example, a handler override for the `rust_analyzer`:
            -- XXX ["rust_analyzer"] = function ()
            -- XXX     require("rust-tools").setup {}
            -- XXX end
        }
     end
    },
    -- Linting and autoformatting.
    -- TODO/XXX comments
    -- asmfmt
    -- clang-format
    -- yapf
    -- rustfmt
    -- flake8
    -- black for non-monorepo stuff
    -- yamllint
    -- jsonlint
    -- buildifier

    -- Autocomplete plugins.
    {'hrsh7th/cmp-nvim-lsp'},
    {'hrsh7th/cmp-buffer'},
    {'hrsh7th/cmp-path'},
    {'hrsh7th/cmp-cmdline'},
    {'hrsh7th/nvim-cmp'},
    {'saadparwaiz1/cmp_luasnip'},
    {'L3MON4D3/LuaSnip'},
    -- Autocomplete for neovim Lua API.
    {'hrsh7th/cmp-nvim-lua',
     init = function()
        require('cmp').setup {sources = {{name = 'nvim_lua'}}}
     end},
    -- Add a progress bar with LSP status to lualine.
    {'linrongbin16/lsp-progress.nvim',
     dependencies = { 'nvim-tree/nvim-web-devicons' },
     config = function()
         require('lsp-progress').setup()
     end},
    -- Plugin for viewing git diffs.
    {'sindrets/diffview.nvim'},
    -- Github integration for reviews, branches, and issues.
    {'NeogitOrg/neogit',
     dependencies = {
       "nvim-lua/plenary.nvim",
       "nvim-telescope/telescope.nvim",
       "sindrets/diffview.nvim",
     },
     config = {},
    },
})

-- XXX testing
-- Plug('emileferreira/nvim-strict')

-- XXX work with snippets
-- luasnip setup
local luasnip = require 'luasnip'

-- nvim-cmp setup
local cmp = require 'cmp'
cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-u>'] = cmp.mapping.scroll_docs(-4), -- Up
    ['<C-d>'] = cmp.mapping.scroll_docs(4), -- Down
    -- C-b (back) C-f (forward) for snippet placeholder navigation.
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  }),
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
}
