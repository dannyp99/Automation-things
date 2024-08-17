require("danny.remap")
require("danny.set")
require("danny.lazy_init")
vim.cmd([[
    augroup RestoreCursorShapeOnExit
        autocmd!
        autocmd VimLeave * set guicursor=a:hor1
    augroup END
]])
