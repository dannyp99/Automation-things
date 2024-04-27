return {
    "freddiehaddad/feline.nvim",
    config = function()
        require('feline').setup()
        require('feline').statuscolumn.setup()
    end
}
