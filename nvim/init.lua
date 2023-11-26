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
-- Enable a nice cursor and nicer colors.
vim.opt.guicursor =
"n-v-c:block-Cursor/lCursor-blinkon0,i-ci:ver25-Cursor/lCursor,r-cr:hor20-Cursor/lCursor"
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

-- XXX file types:
-- - bazel BUILD
-- - python
-- - C
-- - C++
-- - Make
-- - Rust
-- - Latex
-- - Markdown
-- - golang
-- - prototxt
-- - lua
-- - vim files

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
    {'vim-airline/vim-airline'},
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
    --
    {"willothy/flatten.nvim", config = {},
     -- Ensure that it runs first to minimize delay when opening file from terminal
     lazy = false,
     priority = 1001},
})
-- XXX a font

-- XXX testing
-- Plug('emileferreira/nvim-strict')
-- XXX test out at home Plug('iamcco/markdown-preview.nvim')

-- vim-airline.
vim.g['airline#extensions#tabline#enabled'] = 1

-- XXX testing
-- require('strict').setup()
-- vim.fn["mkdp#util#install"]()
