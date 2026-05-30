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

-- require'nvim-treesitter'.install { "lua", "vim", "vimdoc", "c", "cpp", "javascript", "typescript", "java", "python", "markdown", "markdown_inline" }
-- vim.api.nvim_create_autocmd('FileType', {
--     pattern = { "lua", "vim", "vimdoc", "c", "cpp", "javascript", "typescript", "java", "python", "markdown", "markdown_inline" },
--     callback = function()
--         -- syntax highlighting, provided by Neovim
--         vim.treesitter.start()
--         -- folds, provided by Neovim
--         -- vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
--         -- vim.wo.foldmethod = 'indent'
--         -- indentation, provided by nvim-treesitter
--         -- vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
--     end,
-- })

-- harpoon setup
vim.keymap.set("n", "<leader>a", require("harpoon.mark").add_file, { desc = 'Harpoon add' })
vim.keymap.set("n", "<leader>h", require("harpoon.ui").toggle_quick_menu, { desc = 'Harpoon menu' })
