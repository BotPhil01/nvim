vim.cmd("set expandtab")
vim.cmd("set tabstop=4")
vim.cmd("set softtabstop=4")
vim.cmd("set shiftwidth=4")
vim.cmd('set foldmethod=indent')
vim.cmd("set nu")
vim.cmd("set relativenumber")
vim.cmd("set nowrap")
vim.cmd("set nohlsearch")
vim.cmd("set incsearch")
vim.cmd("set termguicolors")
vim.cmd("set scrolloff=8")
vim.cmd("set signcolumn=yes")
vim.opt.isfname:append("@-@")

vim.g.mapleader= " "

vim.keymap.set("n", "<leader>e", vim.cmd.Ex)
vim.cmd("map <leader>( vi(");
vim.cmd("map <leader>) vi)");
vim.cmd("map <leader>{ vi{");
vim.cmd("map <leader>} vi}");
vim.cmd("map <leader>[ vi[");
vim.cmd("map <leader>] vi]");
vim.cmd("map <leader>' vi'");
vim.cmd('map <leader>" vi"');
vim.cmd('tnoremap <Esc> <C-\\><C-n>');
vim.cmd('noremap / /<Bslash>c')
vim.cmd('noremap <leader>/ /')

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
    { "EdenEast/nightfox.nvim", name = "nightfox", priority = 1000 },
    -- init.lua:
    {
        'nvim-telescope/telescope.nvim', tag = '0.1.8',
        dependencies = {
            'nvim-lua/plenary.nvim'}
    },
    {'ThePrimeagen/harpoon',
        dependencies = { 'nvim-lua/plenary.nvim' }},
    {'nvim-treesitter/nvim-treesitter'},
    {'VonHeikemen/lsp-zero.nvim'},
    {'neovim/nvim-lspconfig'},
    {'hrsh7th/cmp-nvim-lsp'},
    {'hrsh7th/nvim-cmp'},
    {"williamboman/mason.nvim"},
    {"williamboman/mason-lspconfig.nvim"},
    {'numToStr/Comment.nvim',
        opts = {
       }
    }
}

local opts = {}
require("lazy").setup(plugins, opts)

-- telescope config
local builtin = require("telescope.builtin")
local telescopeConfig = require('telescope.config')
local vimgrep_args = { unpack(telescopeConfig.values.vimgrep_arguments) }

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
    }
})

vim.keymap.set("n", "<leader>f", builtin.find_files, { desc = 'Telescope find' })
vim.keymap.set("n", "<leader>g", builtin.live_grep, { desc = 'Telescope grep' })

local config = require("nvim-treesitter.configs")
config.setup {
    ensure_installed = { "lua", "vim", "vimdoc", "c", "cpp", "javascript", "typescript", "java", "python", "markdown", "markdown_inline" },
    auto_install = false,
    highlight = { enable = true },
    indent = { enable = true },
}

-- harpoon setup
vim.keymap.set("n", "<leader>a", require("harpoon.mark").add_file, { desc = 'Harpoon add' })
vim.keymap.set("n", "<leader>h", require("harpoon.ui").toggle_quick_menu, { desc = 'Harpoon menu' })

-- setup for nightfox
require("nightfox").setup()
vim.cmd("colorscheme nightfox")

-- setup for mason
require('mason').setup()

require('mason-lspconfig').setup({
    ensure_installed = { 'lua_ls' },
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
        extra = {
            above = 'gck',
            below = 'gcj',
        }
    }
)
