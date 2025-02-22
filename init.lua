vim.cmd("set expandtab")
vim.cmd("set tabstop=4")
vim.cmd("set softtabstop=4")
vim.cmd("set shiftwidth=4")
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
        {'neovim/nvim-lspconfig'},
        {'hrsh7th/cmp-nvim-lsp'},
        {'hrsh7th/nvim-cmp'},
        {'ThePrimeagen/harpoon',
        dependencies = { 'nvim-lua/plenary.nvim' }},
        {'mbbill/undotree'},
    }

local opts = {}
require("lazy").setup(plugins, opts)

local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>f", builtin.find_files, { desc = 'Telescope find' })
vim.keymap.set("n", "<leader>g", builtin.live_grep, { desc = 'Telescope grep' })

local config = require("nvim-treesitter.configs")
config.setup {
  ensure_installed = { "lua","vim", "vimdoc", "c", "cpp", "javascript", "typescript", "java", "python", "markdown", "markdown_inline" },
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

-- setup for undotree
vim.keymap.set('n', '<leader><F5>', vim.cmd.UndotreeToggle)
