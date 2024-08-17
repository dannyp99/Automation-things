return {
    {
        "folke/which-key.nvim",
        config = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
            require("which-key").setup({})
        end
    },
    {
        "numToStr/Comment.nvim",
        config = function()
            require('Comment').setup({})
        end
    }
}
