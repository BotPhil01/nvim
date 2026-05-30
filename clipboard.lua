-- clipboard copy and paste is mapped to yank and paste in nvim
-- requires xclip on linux see https://github.com/astrand/xclip
vim.o.clipboard='unnamedplus'
vim.cmd('set clipboard+="unnamedplus"')

