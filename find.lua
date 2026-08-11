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

telescopeSelect = function(bufnr)
    actions.select_default(bufnr)

    vim.defer_fn(function()
        vim.cmd('bd')
        bufferInit()
        local key = vim.api.nvim_replace_termcodes("<C-\\><C-n>", true, false, true)
        vim.api.nvim_feedkeys(key, 'n', false)
    end, 50)
end

bufferInit = function()
    builtin.buffers {
        attach_mappings = function(prompt_bufnr, map)
            map('n', 'dd', function()
                telescopeSelect(prompt_bufnr)
            end)
            return true;
        end
    }
end

vim.keymap.set("n", "<leader>b", bufferInit, { desc = 'Telescope buffers' })

-- builtin.man_pages.options.sections = "ALL"
function none()
    goto continue
    ::continue::
end

vim.keymap.set("n", "<leader>m", builtin.man_pages, { desc = 'Telescope man' })
vim.keymap.set("n", "<leader>m<ESC>", none, { desc = 'Telescope man' })
vim.keymap.set("n", "<leader>mq", none, { desc = 'Telescope man' })
vim.keymap.set("n", "<leader>ma", builtin.man_pages, { desc = 'Telescope man' })

function man1()
    local opts = {
        sections = { "1" }
    }
    return builtin.man_pages(opts)
end

vim.keymap.set("n", "<leader>m1", man1, { desc = 'Telescope man' })
function man2()
    local opts = {
        sections = { "2" }
    }
    return builtin.man_pages(opts)
end

vim.keymap.set("n", "<leader>m2", man2, { desc = 'Telescope man' })
function man3()
    local opts = {
        sections = { "3" }
    }
    return builtin.man_pages(opts)
end

vim.keymap.set("n", "<leader>m3", man3, { desc = 'Telescope man' })
function man4()
    local opts = {
        sections = { "4" }
    }
    return builtin.man_pages(opts)
end

vim.keymap.set("n", "<leader>m4", man4, { desc = 'Telescope man' })
function man5()
    local opts = {
        sections = { "5" }
    }
    return builtin.man_pages(opts)
end

vim.keymap.set("n", "<leader>m5", man5, { desc = 'Telescope man' })
function man6()
    local opts = {
        sections = { "6" }
    }
    return builtin.man_pages(opts)
end

vim.keymap.set("n", "<leader>m6", man6, { desc = 'Telescope man' })
function man7()
    local opts = {
        sections = { "7" }
    }
    return builtin.man_pages(opts)
end

vim.keymap.set("n", "<leader>m7", man7, { desc = 'Telescope man' })
function man8()
    local opts = {
        sections = { "8" }
    }
    return builtin.man_pages(opts)
end

vim.keymap.set("n", "<leader>m8", man8, { desc = 'Telescope man' })
function man9()
    local opts = {
        sections = { "9" }
    }
    return builtin.man_pages(opts)
end

vim.keymap.set("n", "<leader>m9", man9, { desc = 'Telescope man' })

-- harpoon setup
local hui = require("harpoon.ui")
local hterm = require("harpoon.term")
vim.keymap.set("n", "<leader>a", require("harpoon.mark").add_file, { desc = 'Harpoon add' })
vim.keymap.set("n", "<leader>h", hui.toggle_quick_menu, { desc = 'Harpoon menu' })
vim.keymap.set("n", "<leader>j", hui.nav_prev, {});
vim.keymap.set("n", "<leader>k", hui.nav_next, {});

local function term1()
	hui.nav_file(1)
end
local function term2()
	hui.nav_file(2)
end
local function term3()
	hui.nav_file(3)
end
local function term4()
	hui.nav_file(4)
end
vim.keymap.set("n", "<leader>1", term1, {});
vim.keymap.set("n", "<leader>2", term2, {});
vim.keymap.set("n", "<leader>3", term3, {});
vim.keymap.set("n", "<leader>4", term4, {});
