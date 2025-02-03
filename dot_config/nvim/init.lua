vim.keymap.set('n', '<c-Up>', ':wincmd <Up><CR>')
vim.keymap.set('n', '<c-Down>', ':wincmd <Down><CR>')
vim.keymap.set('n', '<c-Left>', ':wincmd <Left><CR>')
vim.keymap.set('n', '<c-Right>', ':wincmd <Right><CR>')

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath
  })
end
vim.opt.rtp:prepend(lazypath)

require("vim-options")
require("lazy").setup("plugins")

