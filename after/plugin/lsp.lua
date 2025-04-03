-- NOTE: to make any of this work you need a language server.
-- If you don't know what that is, watch this 5 min video:
-- https://www.youtube.com/watch?v=LaS32vctfOY

-- Reserve a space in the gutter
vim.opt.signcolumn = 'yes'

-- Add cmp_nvim_lsp capabilities settings to lspconfig
-- This should be executed before you configure any language server
local lspconfig_defaults = require('lspconfig').util.default_config
lspconfig_defaults.capabilities = vim.tbl_deep_extend(
  'force',
  lspconfig_defaults.capabilities,
  require('cmp_nvim_lsp').default_capabilities()
)


-- This is where you enable features that only work
-- if there is a language server active in the file
vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'LSP actions',
  callback = function(event)
    local opts = {buffer = event.buf}

    vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
    vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
    vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
    vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
    vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
    vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
    vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
    vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
    vim.keymap.set({'n', 'x'}, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
    vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
  end,
})

-- You'll find a list of language servers here:
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
-- These are example language servers. 

-- clangd for c/c++
require('lspconfig').clangd.setup {
cmd = {"/home/mint/.espressif/tools/esp-clang/16.0.1-fe4f10a809/esp-clang/bin/clangd","--query-driver=/home/mint/.espressif/tools/riscv32-esp-elf/esp-13.2.0_20230928/riscv32-esp-elf/lib/gcc"}
}

-- pylsp for python
require'lspconfig'.pylsp.setup{
  settings = {
    pylsp = {
      plugins = {
          ruff = {
            select = {"I", "N", "E", "W", "F", "PL", "TRY", "TC", "A"},
            preview = true
        }
      }
    }
  }
}

--bashls for bash
--$ sudo npm i -g bash-language-server
--install the newer nodejs to prevent install error
--$ sudo dpkg --remove nodejs
--$ sudo dpkg --remove --force-remove-reinstreq libnode-dev
--$ sudo dpkg --remove --force-remove-reinstreq libnode72:amd64
--https://askubuntu.com/questions/426750/how-can-i-update-my-nodejs-to-the-latest-version/548776#548776
--# Using Ubuntu
--$ curl -sL https://deb.nodesource.com/setup_18.x | sudo -E bash -
--$ sudo apt-get install -y nodejs
-- setting : https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/configs/bashls.lua#L2
require'lspconfig'.bashls.setup{
    filetypes = { "bash", "sh" },
}


local cmp = require('cmp')

require('luasnip.loaders.from_vscode').lazy_load()

cmp.setup({
  sources = {
    {name = 'nvim_lsp'},
    {name = 'luasnip'},
  },
  snippet = {
    expand = function(args)
      -- You need Neovim v0.10 to use vim.snippet
      -- vim.snippet.expand(args.body)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
      -- use enter to confirm selection
      ['<CR>'] = cmp.mapping.confirm({select = true}), 

      -- Super tab
      ['<Tab>'] = cmp.mapping(function(fallback)
          local luasnip = require('luasnip')
          local col = vim.fn.col('.') - 1

          if cmp.visible() then
              cmp.select_next_item({behavior = 'select'})
          elseif luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
          elseif col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
              fallback()
          else
              cmp.complete()
          end
      end, {'i', 's'}),

      -- Super shift tab
      ['<S-Tab>'] = cmp.mapping(function(fallback)
          local luasnip = require('luasnip')

          if cmp.visible() then
              cmp.select_prev_item({behavior = 'select'})
          elseif luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
          else
              fallback()
          end
      end, {'i', 's'}),
  }),
})
