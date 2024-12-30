local opts = { noremap = true, silent = true }
-- vim.api.nvim_set_keymap("n", "<Leader>nc", ":lua require('neogen').generate({ type = 'class' })<CR>", opts)
-- vim.api.nvim_set_keymap("n", "<Leader>nf", ":lua require('neogen').generate({ type = 'file' })<CR>", opts)
-- vim.api.nvim_set_keymap("n", "<Leader>nu", ":lua require('neogen').generate({ type = 'func' })<CR>", opts)
vim.api.nvim_set_keymap('n', '<Leader>nc', ":lua require('neogen').generate()<CR>", { noremap = true, silent = true })


local i = require("neogen.types.template").item

require('neogen').setup {
    enabled = true,
    input_after_comment = false,
    languages = {
        python = {
            template = {
                annotation_convention = "custom",
                custom = {
                    { nil, '"""', { no_results = true, type = { "class", "func" , "file"} } },
                    { nil, "@brief explain", {no_results = true,  type = { "class", "func", "file" } } },
                    { nil, '$1', { no_results = true, type = { "class", "func" } } },
                    { nil, '"""', { no_results = true, type = { "class", "func" } } },

                    { nil, "", { no_results = true, type = { "file" } } },
                    { nil, "@package neogen", {no_results = true,  type = { "file" } } },
                    { nil, "@author Your Name", {no_results = true, type = { "file" } } },
                    { nil, "@copyright Your Organization", {no_results = true, type = { "file" } } },
                    { nil, '$1', {no_results = true, type = { "file" } } },
                    { nil, '"""', { no_results = true, type = { "file" } } },
                    { nil, "", { no_results = true, type = { "file" } } },

                    { nil, "# $1", { no_results = true, type = { "type" } } },

                    { nil, '"""$1' },
                    { nil, "@brief explain"},
                    { nil, "" },
                    {
                        i.Parameter,
                        "@param %s: explain",
                    },
                    { i.ClassAttribute, "@param %s: $1" },
                    { i.Throw, "@raises %s: $1", { type = { "func" } } },
                    { i.Return, "@return: $1", { type = { "func" }, after_each = "@rtype: $1" } },
                    { i.ReturnTypeHint, "@return: $1", { type = { "func" } } },
                    { nil, '"""' },
                },
            },
        },
    },
}

