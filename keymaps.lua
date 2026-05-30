vim.g.mapleader= " "

-- file explorer
vim.keymap.set('n', '<leader>e', '<cmd>lua vim.cmd("Ex")<CR>' , {noremap = true})
-- terminal exit
vim.keymap.set('t', '<A-q>', '<C-\\><C-n>', {noremap = true})
-- case insensitive find
vim.keymap.set('', '/', '/<Bslash>c', {noremap = true})
vim.keymap.set('', '<leader>/', '/', {noremap = true})
vim.keymap.set('', '?', '?<Bslash>c', {noremap = true})
vim.keymap.set('', '<leader>?', '?', {noremap = true})

-- no copy on delete
vim.keymap.set('', 'd', 'd', {noremap = true});
vim.keymap.set('n', '>dd', 'dd', {noremap = true});
vim.keymap.set('v', 'd', 'd', {noremap = true});

vim.keymap.set('', '<leader>d', '"_d', {noremap = true});
vim.keymap.set('n', '<leader>dd', '"_dd', {noremap = true});
vim.keymap.set('v', '<leader>d', '"_d', {noremap = true});

vim.keymap.set('', 'x', '"_x', {noremap = true})
vim.keymap.set('', 'X', '"_X', {noremap = true})

vim.keymap.set('v', 'p', '"_dP', {noremap = true})
vim.keymap.set('v', 'P', '"_dP', {noremap = true})
vim.keymap.set('n', '<leader>r', '<cmd>lua vim.diagnostic.open_float()<CR>', {noremap = true})
