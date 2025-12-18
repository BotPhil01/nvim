-- tab options
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4

-- folding 
vim.opt.foldmethod = 'indent'
-- line options
vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.wrap = false
-- searching options
vim.opt.hlsearch = false
vim.opt.incsearch = true
-- gui stuff
vim.opt.termguicolors = true
vim.opt.scrolloff = 10
vim.opt.signcolumn = 'yes'
vim.opt.isfname:append("@-@")
-- for use with lspzero 
vim.opt.smartindent = false
-- clipboard copy and paste is mapped to yank and paste in nvim
-- requires xclip on linux see https://github.com/astrand/xclip
vim.o.clipboard='unnamedplus'
vim.cmd('set clipboard+="unnamedplus"')

vim.g.mapleader= " "

-- file explorer
vim.keymap.set('n', '<leader>e', '<cmd>lua vim.cmd("Ex .")<CR>' , {noremap = true})
-- terminal exit
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', {noremap = true})
-- case insensitive find
vim.keymap.set('', '/', '/<Bslash>c', {noremap = true})
vim.keymap.set('', '<leader>/', '/', {noremap = true})
vim.keymap.set('', '?', '?<Bslash>c', {noremap = true})
vim.keymap.set('', '<leader>?', '?', {noremap = true})

-- no copy on delete
vim.keymap.set('', '<leader>d', 'd', {noremap = true});
vim.keymap.set('n', '<leader>dd', 'dd', {noremap = true});
vim.keymap.set('v', '<leader>d', 'd', {noremap = true});

vim.keymap.set('', 'd', '"_d', {noremap = true});
vim.keymap.set('n', 'dd', '"_dd', {noremap = true});
vim.keymap.set('v', 'd', '"_d', {noremap = true});

vim.keymap.set('', 'x', '"_x', {noremap = true})
vim.keymap.set('', 'X', '"_X', {noremap = true})

vim.keymap.set('v', 'p', '"_dP', {noremap = true})
vim.keymap.set('v', 'P', '"_dP', {noremap = true})

vim.keymap.set('', '<leader>/' ,'/', {noremap = true})
vim.keymap.set('n', '<leader>r', '<cmd>lua vim.diagnostic.open_float()<CR>', {noremap = true})


local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out, "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)
local plugins = {
    -- init.lua:
    {'rebelot/kanagawa.nvim', name = 'colorscheme'},
    {'BurntSushi/ripgrep', name = "ripgrep", priority = 900 },
    {
        'nvim-telescope/telescope.nvim', tag = '0.1.8',
        dependencies = {
            'nvim-lua/plenary.nvim'
        }
    },
    {
        'ThePrimeagen/harpoon',
        dependencies = { 'nvim-lua/plenary.nvim' }
    },
    {'nvim-treesitter/nvim-treesitter'},
    {'VonHeikemen/lsp-zero.nvim'},
    {'neovim/nvim-lspconfig'},
    {'hrsh7th/cmp-nvim-lsp'},
    {'hrsh7th/nvim-cmp'},
    {"williamboman/mason.nvim"},
    {"williamboman/mason-lspconfig.nvim"},
    {"neovim/nvim-lspconfig"},
    {'numToStr/Comment.nvim'},
    {'lambdalisue/vim-suda'},
    {
        'Aasim-A/scrollEOF.nvim',
        event = { 'CursorMoved', 'WinScrolled' },
        opts = {},
    },
}

-- required for setting up lazy
local opts = {}
require("lazy").setup(plugins, opts)

-- suda operations
vim.keymap.set('n', '<leader>sw', '<cmd>SudaWrite<CR>', {noremap = true})
vim.keymap.set('n', '<leader>sr', '<cmd>SudaRead<CR>', {noremap = true})



-- telescope config
local builtin = require("telescope.builtin")
local telescopeConfig = require('telescope.config')
table.unpack = unpack or table.unpack -- compatibility
local vimgrep_args = { table.unpack(telescopeConfig.values.vimgrep_arguments) }

table.insert(vimgrep_args, '--hidden')
table.insert(vimgrep_args, '--glob')
table.insert(vimgrep_args, '!**/.git/*')
require('telescope').setup({
    defaults = {
        vimgrep_arguments = vimgrep_args
    },
    pickers = {
        find_files = {
            find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },

        },
        man_pages = {
            sections = { "ALL" },
        },
    }
})

vim.keymap.set("n", "<leader>f", builtin.find_files, { desc = 'Telescope find' })
vim.keymap.set("n", "<leader>g", builtin.live_grep, { desc = 'Telescope grep' })

local actions = require('telescope.actions')

local bufferInit, telescopeSelect

telescopeSelect = function (bufnr)
    actions.select_default(bufnr)

    vim.defer_fn(function ()
        vim.cmd('bd')
        bufferInit()
        local key = vim.api.nvim_replace_termcodes("<C-\\><C-n>", true, false, true)
        vim.api.nvim_feedkeys(key, 'n', false)
    end, 50)
end

bufferInit = function ()
    builtin.buffers{
        attach_mappings = function(prompt_bufnr, map)
            map('n', 'dd', function ()
                telescopeSelect(prompt_bufnr)
            end)
            return true;
        end
    }
end

vim.keymap.set("n", "<leader>b", bufferInit, {desc = 'Telescope buffers' })

-- builtin.man_pages.options.sections = "ALL"
vim.keymap.set("n", "<leader>m", builtin.man_pages , {desc = 'Telescope man' })


local config = require("nvim-treesitter.configs")
config.setup {
    ensure_installed = { "lua", "vim", "vimdoc", "c", "cpp", "javascript", "typescript", "java", "python", "markdown", "markdown_inline" },
    auto_install = false,
    highlight = { enable = true },
    indent = { enable = false },
}

-- harpoon setup
vim.keymap.set("n", "<leader>a", require("harpoon.mark").add_file, { desc = 'Harpoon add' })
vim.keymap.set("n", "<leader>h", require("harpoon.ui").toggle_quick_menu, { desc = 'Harpoon menu' })

-- colorscheme
vim.cmd("colorscheme kanagawa-wave")

-- setup for mason
require('mason').setup()

require('mason-lspconfig').setup({
    ensure_installed = { 'lua_ls', 'bashls', 'pylsp', 'clangd' },
    handlers = {
        function(server_name)
            require('lspconfig')[server_name].setup({
                settings = {
                    Lua = {
                        diagnostics = {
                            globals = { 'vim' },
                        }
                    }
                }
            })
        end,
    },
})

-- setup for zerolsp
local lspconfig_defaults = require('lspconfig').util.default_config
lspconfig_defaults.capabilities = vim.tbl_deep_extend(
    'force',
    lspconfig_defaults.capabilities,
    require('cmp_nvim_lsp').default_capabilities()
)

vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'LSP actions',
  callback = function(event)
    opts = {buffer = event.buf}
        vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
        vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
        vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
        vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
        vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
        vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
        vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
        vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
        vim.keymap.set({'n', 'x'}, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
        vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
    end,
})

-- setup for autocomplete
local cmp = require('cmp')

cmp.setup({
  sources = {
    {name = 'nvim_lsp'},
    {
        name = 'buffer',
        option =
                {
                    keyword_length = 1,
                }
    },
  },
  snippet = {
    expand = function(args)
      -- You need Neovim v0.10 to use vim.snippet
      vim.snippet.expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({}),
})

require('Comment').setup(
    {
        ignore = '^$',
        extra = {
            above = 'gck',
            below = 'gcj',
        }
    }
)

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics,
    {
        virtual_text = true,
        signs = true,
        update_in_insert = false,
        underline = true,
        float = true,
    }
)

-- setup for scrolleeof
require('scrollEOF').setup({
  -- The pattern used for the internal autocmd to determine
  -- where to run scrollEOF. See https://neovim.io/doc/user/autocmd.html#autocmd-pattern
  pattern = '*',
  -- Whether or not scrollEOF should be enabled in insert mode
  insert_mode = true,
  -- Whether or not scrollEOF should be enabled in floating windows
  floating = true,
  -- List of filetypes to disable scrollEOF for.
  disabled_filetypes = {},
  -- List of modes to disable scrollEOF for. see https://neovim.io/doc/user/builtin.html#mode()
  disabled_modes = {},
})
