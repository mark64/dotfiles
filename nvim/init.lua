-- Enable the faster lua bytecode loader.
vim.loader.enable()
-- Key mapping.
--
-- Disable mouse support to make selecting text easier.
vim.opt.mouse = ''
-- Set the leader as <space>.
vim.g.mapleader = ' '
-- Remap common keys to save typing and shift keys.
vim.keymap.set('n', ";", ":", { noremap = true })
vim.keymap.set({ 'n', 'v' }, 'j', 'gj', { noremap = true })
vim.keymap.set({ 'n', 'v' }, 'k', 'gk', { noremap = true })
-- Remap jk -> Esc.
vim.keymap.set('i', 'jk', "<Esc>", { noremap = true })
-- Use Alt-hjkl to move between splits.
local movement_keys = { 'h', 'j', 'k', 'l' }
local mac_option_keys = { '˙', '∆', '˚', '¬' }
for key_index = 1, #movement_keys do
    vim.keymap.set(
        { "", 'i' },
        string.format("<M-%s>", movement_keys[key_index]),
        string.format("<Esc><C-w>%s", movement_keys[key_index]),
        { noremap = true }
    )
    vim.keymap.set(
        't',
        string.format("<M-%s>", movement_keys[key_index]),
        string.format("<C-\\><C-n><C-w>%s", movement_keys[key_index]),
        { noremap = true }
    )
    vim.keymap.set(
        { "", 'i' },
        mac_option_keys[key_index],
        string.format("<Esc><C-w>%s", movement_keys[key_index]),
        { noremap = true }
    )
    vim.keymap.set(
        't',
        mac_option_keys[key_index],
        string.format("<C-\\><C-n><C-w>%s", movement_keys[key_index]),
        { noremap = true }
    )
end

-- Remap `` so that it enters normal mode in neovim terminals.
vim.keymap.set('t', "``", "<C-\\><C-n>", { noremap = true })
-- Enter insert mode when entering a terminal window.
vim.api.nvim_create_autocmd({ 'BufEnter', 'TermOpen' }, {
    pattern = "term://*",
    command = 'startinsert'
})

-- Enable persistent undo tracking.
vim.opt.undodir = vim.fn.stdpath('data') .. '/undo'
vim.opt.undofile = true

-- Appearance
--
-- Enable nicer colors.
vim.opt.termguicolors = true
-- Enable the combined line number and sign column.
vim.opt.signcolumn = 'number'
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
vim.opt.switchbuf = { 'useopen', 'vsplit' }
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
-- Copy current indentation when making a new line.
vim.opt.copyindent = true
-- Perform smart indenting based on file language.
vim.opt.smartindent = true
-- Wrapped lines will be indented to match the original line.
vim.opt.breakindent = true
-- Set the correct tab behavior for non-default files.
vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'c', 'cpp', 'proto', },
    callback = function()
        vim.opt.tabstop = 2
        vim.opt.shiftwidth = 2
    end,
})
vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'make', },
    callback = function()
        vim.opt.tabstop = 4
        vim.opt.shiftwidth = 4
        vim.opt.expandtab = false
    end,
})

-- Searching
--
-- Enable highlighting text while searching.
vim.opt.hlsearch = true
vim.opt.incsearch = true
-- Press enter in normal mode to clear highlighted text.
vim.keymap.set('n', "<CR>", ":noh<CR>:<BS>", { noremap = true })
-- Do case-insensitive searches unless the search contains upper-case characters.
vim.opt.smartcase = true

-- Completion
--
-- Ignore case when completing filenames and directories.
vim.opt.wildignorecase = true
-- Infer case when doing completion in insert mode.
vim.opt.infercase = true

-- Enable spell checking
vim.opt.spell = true
vim.opt.spelllang = 'en_us'

-- Don't leak secrets in undofiles.
vim.api.nvim_create_autocmd({ 'BufEnter' }, {
    -- Files for password-store password manager and sudoedit files.
    pattern = { '/dev/shm/pass*', '/var/tmp/*' },
    callback = function()
        vim.opt_local.swapfile = false
        vim.opt_local.backup = false
        vim.opt_local.undofile = false
    end,
})

-- Setup plugin manager.
local lazypath = vim.fn.stdpath('data') .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        'git',
        'clone',
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- Autocommand group used by formatting plugins.
local formatting_augroup = vim.api.nvim_create_augroup('LspFormatting', {})

-- Setup plugins.
require('lazy').setup({
    -- Better Ctrl-R in shells, fuzzy search for files in vim.
    {
        'junegunn/fzf',
        build = function()
            os.execute('./install --all --xdg')
        end
    },
    -- Edit directories in a vim-like buffer e.g. rename by editing a line and
    -- saving.
    {
        'stevearc/oil.nvim',
        -- Don't lazy-load this plugin.
        lazy = false,
        opts = {},
        dependencies = { 'nvim-tree/nvim-web-devicons' }
    },
    -- Trim whitespace on save.
    { 'cappyzawa/trim.nvim',        opts = {} },
    -- Helpful icon support.
    { 'nvim-tree/nvim-web-devicons' },
    -- Improve the status line appearance.
    {
        'nvim-lualine/lualine.nvim',
        init = function()
            require('lualine').setup({
                sections = {
                    lualine_c = {
                        -- Use filename and parent directory for active buffers.
                        { 'filename', path = 4 },
                        -- Add LSP status.
                        require('lsp-progress').progress,
                    },
                },
                inactive_sections = {
                    lualine_c = {
                        -- Use relative path, not just filename, for inactive buffers.
                        { 'filename', path = 1 },
                    },
                },
            })
        end,
        dependencies = {
            'nvim-tree/nvim-web-devicons',
            "linrongbin16/lsp-progress.nvim",
        }
    },
    -- Lua utilities for plugins.
    { 'nvim-lua/plenary.nvim' },
    -- Tree-sitter: provide language-aware features like highlighting and searching.
    {
        'nvim-treesitter/nvim-treesitter',
        build = function()
            vim.cmd('TSInstall all')
            vim.cmd('TSUpdate')
        end,
        opts = {
            highlight = { enable = true },
        },
        init = function()
            -- Enable code folding.
            vim.opt.foldmethod = 'expr'
            vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
            vim.opt.foldenable = false
        end
    },
    -- Fuzzy file finding and live grep in neovim.
    {
        'nvim-telescope/telescope.nvim',
        branch = '0.1.x',
        dependencies = {
            'nvim-lua/plenary.nvim',
            'nvim-tree/nvim-web-devicons',
            'nvim-treesitter/nvim-treesitter',
            'nvim-telescope/telescope-ui-select.nvim',
        },
        opts = {
            defaults = {
                layout_config = {
                    horizontal = {
                        mirror = true,
                    },
                },
            },
        },
        init = function()
            -- Use the natively-compiled FZF searcher.
            require('telescope').load_extension('fzf')
            -- Use telelscope for vim selection.
            require('telescope').load_extension('ui-select')

            local builtin = require('telescope.builtin')
            vim.keymap.set('n', '<leader>f', builtin.find_files, {})
            vim.keymap.set('n', '<leader>g', builtin.live_grep, {})
            vim.keymap.set('n', '<leader>h', builtin.help_tags, {})
            -- Search just the open file.
            vim.keymap.set('n', '<leader>s', builtin.current_buffer_fuzzy_find, {})
        end,
    },
    -- Speed up fuzzy finding by using a native binary instead of lua.
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' },
    -- Restore the last cursor position when re-opening a file.
    { 'vladdoster/remember.nvim',                 opts = {} },
    -- When opening new files in nested terminals, replace the terminal buffer
    -- with a vim file buffer instead of making a nested neovim.
    {
        'willothy/flatten.nvim',
        opts = {
            window = {
                open = "split",
            },
        },
        -- Ensure that it runs first to minimize delay when opening file from terminal
        lazy = false,
        priority = 1001
    },
    -- A nice, dark colorscheme written in Lua with all the fancy neovim features
    -- (treesitter, LSP, etc.)
    {
        'bluz71/vim-moonfly-colors',
        name = 'moonfly',
        lazy = false,
        priority = 1000,
        init = function()
            vim.cmd('colorscheme moonfly')
        end
    },
    -- Markdown preview in a browser.
    {
        "iamcco/markdown-preview.nvim",
        cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
        ft = { 'markdown' },
        build = function() vim.fn["mkdp#util#install"]() end,
    },
    -- LSP (language-server-protocol) plugins. Mason manages installing third-party
    -- language servers.
    { 'neovim/nvim-lspconfig' },
    { "williamboman/mason.nvim",   opts = {} },
    { 'RubixDev/mason-update-all', opts = {} },
    {
        "williamboman/mason-lspconfig.nvim",
        opts = {
            ensure_installed = {
                'ansiblels',
                'asm_lsp',
                'bashls',
                'bufls',
                'bzl',
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
                'marksman',
                'pyright',
                'rust_analyzer@nightly',
                'sqlls',
                'taplo',
                'vimls',
                'yamlls',
            },
            automatic_installation = false,
        },
        init = function()
            require('mason-lspconfig').setup_handlers {
                -- The first entry (without a key) will be the default handler
                -- and will be called for each installed server that doesn't have
                -- a dedicated handler.
                function(server_name) -- default handler
                    require('lspconfig')[server_name].setup {}
                end,
                -- Override the rust_analyzer setup function.
                -- Per https://github.com/mrcjkb/rustaceanvim, we should not
                -- call the rust-analyzer setup, instead letting rustaceanvim
                -- handle that.
                ['rust_analyzer'] = function()
                    -- Do nothing.
                end,
                -- Pyright is incredibly slow on large repos.
                -- Have it just analyze open files.
                ['pyright'] = function()
                    require('lspconfig')['pyright'].setup {
                        settings = {
                            python = {
                                analysis = {
                                    -- Don't run against all files in the workspace,
                                    -- just the files that are open.
                                    diagnosticMode = 'openFilesOnly',
                                }
                            }
                        }
                    }
                end,
                ['clangd'] = function()
                    require('lspconfig')['clangd'].setup {
                        -- Remove proto from the list of supported files, it just causes errors.
                        filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda' },
                    }
                end
            }
        end
    },
    -- LSP linters and formatters.
    {
        'jay-babu/mason-null-ls.nvim',
        opts = {
            ensure_installed = {
                'asmfmt',
                'buildifier',
                'clang-format',
                'flake8',
                'jsonlint',
                'rustfmt',
                'yamllint',
                'yapf',
            },
            automatic_installation = false,
            handlers = {},
        }
    },
    {
        'nvimtools/none-ls.nvim',
        opts = {
            on_attach = function(client, bufnr)
                if client.supports_method('textDocument/formatting') then
                    vim.api.nvim_clear_autocmds({ group = formatting_augroup, buffer = bufnr })
                    vim.api.nvim_create_autocmd('BufWritePre', {
                        group = formatting_augroup,
                        buffer = bufnr,
                        callback = function()
                            vim.lsp.buf.format({ async = false })
                        end,
                    })
                end
            end,
        }
    },
    -- Additional Rust LSP tooling.
    { 'mrcjkb/rustaceanvim',                ft = { 'rust' } },
    -- Display inlay hints when LSPs provide it. Usually this comes in the form of type annotations
    -- on function parameters and return values.
    {
        'lvimuser/lsp-inlayhints.nvim',
        opts = {},
        init = function()
            vim.api.nvim_create_augroup('LspAttach_inlayhints', {})
            vim.api.nvim_create_autocmd('LspAttach', {
                group = 'LspAttach_inlayhints',
                callback = function(args)
                    if not (args.data and args.data.client_id) then
                        return
                    end

                    local bufnr = args.buf
                    local client = vim.lsp.get_client_by_id(args.data.client_id)
                    require('lsp-inlayhints').on_attach(client, bufnr)
                end,
            })
        end
    },
    -- Autocomplete plugins.
    { 'hrsh7th/cmp-nvim-lsp' },
    { 'hrsh7th/cmp-buffer' },
    { 'hrsh7th/cmp-path' },
    { 'hrsh7th/cmp-cmdline' },
    { 'hrsh7th/cmp-nvim-lsp-signature-help' },
    {
        'petertriho/cmp-git',
        dependencies = { 'nvim-lua/plenary.nvim' },
        -- For work github, I add the following to dotfiles/nvim/work.lua:
        -- require('cmp_git').setup({ github = { hosts = { "<GH enterprise hostname>" } } })
        opts = {},
    },
    {
        'hrsh7th/nvim-cmp',
        dependencies = { 'saadparwaiz1/cmp_luasnip', 'onsails/lspkind.nvim', },
        init = function()
            local cmp_buffer = require('cmp_buffer')
            local luasnip = require('luasnip')
            local lspkind = require('lspkind')
            local cmp = require('cmp')
            cmp.setup {
                experimental = {
                    ghost_text = true,
                },
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ['<C-u>'] = cmp.mapping.scroll_docs(-4), -- Up
                    ['<C-d>'] = cmp.mapping.scroll_docs(4),  -- Down
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
                    -- Add a mapping to trigger AI completion.
                    ['<C-x>'] = cmp.mapping(
                        cmp.mapping.complete({
                            config = {
                                sources = cmp.config.sources({
                                    { name = 'cmp_ai' },
                                }),
                            },
                        }),
                        { 'i' }
                    ),
                }),
                sources = {
                    -- Place AI completions first.
                    { name = 'cmp_ai' },
                    { name = 'nvim_lsp' },
                    { name = 'nvim_lsp_signature_help' },
                    { name = 'luasnip' },
                    -- Require at least the first character be typed before showing completion.
                    { name = 'buffer',                 keyword_length = 1 },
                    { name = 'path' },
                    { name = 'git' },
                    { name = 'nvim_lua' },
                },
                sorting = {
                    comparators = {
                        -- Prefer completion results for items that are physically close
                        -- to the cursor.
                        function(...) return cmp_buffer:compare_locality(...) end,
                    }
                },
                formatting = {
                    format = lspkind.cmp_format({
                        mode = 'symbol_text', -- show the symbol and the kind name.
                        maxwidth = 50,        -- limit output to 50 characters per line.
                        -- when popup menu exceed maxwidth, the truncated part would show
                        -- ellipsis_char instead (must define maxwidth first)
                        ellipsis_char = '...',
                        before = function(entry, vim_item)
                            -- Format completion entries from cmp_ai correctly, instead of just as "Text".
                            if entry.source.name == 'cmp_ai' then
                                local detail = (entry.completion_item.labelDetails or {}).detail
                                vim_item.kind = ''
                                if detail and detail:find('.*%%.*') then
                                    vim_item.kind = vim_item.kind .. ' ' .. detail
                                end

                                if (entry.completion_item.data or {}).multiline then
                                    vim_item.kind = vim_item.kind .. ' ' .. '[ML]'
                                end
                                -- Limit to 40 chars.
                                vim_item.abbr = string.sub(vim_item.abbr, 1, 40)
                            end
                            return vim_item
                        end
                    })
                },
            }
            -- Completion for / search.
            cmp.setup.cmdline('/', {
                mapping = cmp.mapping.preset.cmdline(),
                sources = {
                    { name = 'buffer' }
                }
            })
            -- `:` vim cmdline completion.
            cmp.setup.cmdline(':', {
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources({
                    { name = 'path' }
                }, {
                    {
                        name = 'cmdline',
                        option = {
                            ignore_cmds = { 'Man', '!' }
                        }
                    }
                })
            })
        end
    },
    { 'saadparwaiz1/cmp_luasnip' },
    {
        'L3MON4D3/LuaSnip',
        build = "make install_jsregexp",
        init = function()
            -- Ctrl-L will go to the next snippet item, like the next function arg.
            -- Ctrl-H will go to the previous item.
            local luasnip = require('luasnip')
            vim.keymap.set({ "i", "s" }, "<C-L>", function() luasnip.jump(1) end, { silent = true })
            vim.keymap.set({ "i", "s" }, "<C-H>", function() luasnip.jump(-1) end, { silent = true })
        end
    },
    -- Autocomplete for neovim Lua API.
    {
        'hrsh7th/cmp-nvim-lua',
    },
    -- Add a progress bar with LSP status to lualine.
    {
        'linrongbin16/lsp-progress.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = function()
            require('lsp-progress').setup()
        end,
        init = function()
            vim.api.nvim_create_augroup('lualine_augroup', { clear = true })
            vim.api.nvim_create_autocmd('User', {
                group = 'lualine_augroup',
                pattern = 'LspProgressStatusUpdated',
                callback = require('lualine').refresh,
            })
        end
    },
    -- Navigator provides super useful LSP functionality, like floating definition/declaration windows.
    {
        'ray-x/navigator.lua',
        dependencies = {
            {
                'ray-x/guihua.lua',
                build = function()
                    os.execute('cd lua/fzy && make')
                end
            },
            { 'neovim/nvim-lspconfig' },
            { 'nvim-treesitter/nvim-treesitter' },
        },
        opts = {
            mason = true,
            lsp = {
                disable_lsp = 'all',
            },
        },
        init = function()
            vim.api.nvim_create_augroup('LspAttach_navigator', {})
            vim.api.nvim_create_autocmd('LspAttach', {
                group = 'LspAttach_navigator',
                callback = function(args)
                    if not (args.data and args.data.client_id) then
                        return
                    end
                    local bufnr = args.buf
                    local client = vim.lsp.get_client_by_id(args.data.client_id)
                    require('navigator.lspclient.mapping').setup({ bufnr = bufnr, client = client })
                end,
            })
        end
    },
    -- Plugin to display what kind of item a completion represents (e.g. function, struct name, module, etc.).
    { 'onsails/lspkind.nvim' },
    -- Plugin for viewing git diffs.
    { 'sindrets/diffview.nvim' },
    -- Git integration.
    {
        'NeogitOrg/neogit',
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope.nvim",
            "sindrets/diffview.nvim",
        },
        cmd = {
            'Neogit',
            'NeogitResetState',
        },
        opts = {
            kind = 'tab',
            integrations = {
                telescope = true,
                diffview = true,
            },
        },
    },
    -- Github integration for reviews, branches, and issues.
    {
        'pwntester/octo.nvim',
        dependencies = {
            'nvim-lua/plenary.nvim',
            'nvim-telescope/telescope.nvim',
            'nvim-tree/nvim-web-devicons',
        },
        config = function()
            require('octo').setup()
        end,
        keys = {
            -- Show the list of requested reviews.
            { '<leader>r',
                function()
                    vim.cmd {
                        cmd = 'Octo',
                        args = { 'search', 'is:pr', 'review-requested:@me', 'is:open' }
                    }
                end }
        },
        cmd = { 'Octo' },
    },
    -- Add a tool to generate github links from nvim.
    { 'vincent178/nvim-github-linker', opts = {} },
    {
        'ruifm/gitlinker.nvim',
        dependencies = { 'nvim-lua/plenary.nvim' },
        opts = {},
    },
    -- Add a tool for search and replace across files.
    {
        'nvim-pack/nvim-spectre',
        opts = {},
        cmd = 'Spectre',
    },
    -- Plugin to enable transparent background.
    -- Doesn't work with all terminals though, but lets me easily enable a black background on those there it doesn't work.
    { 'xiyaowong/transparent.nvim' },
    -- This shows an interactive file browser tree on the left of the screen.
    { 'nvim-tree/nvim-tree.lua',       opts = { view = { width = 50 } }, },
    -- This is a plugin to do AI codegen on command with nvim.
    {
        'David-Kunz/gen.nvim',
        opts = {
            -- options:
            -- - dolphin2.2-mistral
            -- - dilphin-mixtral
            -- - codellama:13b-python
            -- - codellama:13b
            model = 'codellama:34b', -- The default model to use.
            show_prompt = true,      -- Shows the Prompt submitted to Ollama.
            show_model = true,       -- Displays which model you are using at the beginning of your chat session.
            no_auto_close = false,   -- Never closes the window automatically.
        }
    },
    -- This is a completion source that will pull completions from a self-hosted ollama server.
    {
        'tzachar/cmp-ai',
        dependencies = 'nvim-lua/plenary.nvim',
        init = function()
            local cmp_ai = require('cmp_ai.config')
            cmp_ai:setup({
                max_lines = 100,
                provider = 'Ollama',
                provider_options = {
                    model = 'codellama:13b-code',
                    options = {
                        temperature = 0.5,
                    },
                },
                notify = false,
                notify_callback = function(msg)
                    vim.notify(msg)
                end,
                run_on_every_keystroke = true,
                ignored_file_types = {
                    -- default is not to ignore
                    -- uncomment to ignore in lua:
                    -- lua = true
                },
            })
        end
    },
})

-- Source work-specific settings that I don't want public.
require('work')

-- XXX fix
-- prune down list of completion entries
-- https://github.com/mfussenegger/nvim-dap
-- https://github.com/rcarriga/nvim-dap-ui
