require('nvim-treesitter').install {
  "c", "python", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline",
}

vim.api.nvim_create_autocmd('FileType', {
  callback = function()
    pcall(vim.treesitter.start)
  end,
})
