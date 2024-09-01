require "core"

local custom_init_path = vim.api.nvim_get_runtime_file("lua/custom/init.lua", false)[1]

if custom_init_path then
  dofile(custom_init_path)
end

require("core.utils").load_mappings()

local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

-- bootstrap lazy.nvim!
if not vim.loop.fs_stat(lazypath) then
  require("core.bootstrap").gen_chadrc_template()
  require("core.bootstrap").lazy(lazypath)
end

dofile(vim.g.base46_cache .. "defaults")
vim.opt.rtp:prepend(lazypath)
require "plugins"

local wilder = require('wilder')
wilder.setup({modes = {':', '/', '?'}})
wilder.set_option('renderer', wilder.popupmenu_renderer({
  -- highlighter applies highlighting to the candidates
  highlighter = wilder.basic_highlighter(),
}))

vim.api.nvim_create_autocmd(
  {"BufNewFile", "BufRead"}, {
    pattern = {"*.v"},
    command = "set syntax=verilog",
  }
)

require('lspconfig').verible.setup{
  cmd = {'verible-verilog-ls', '--rules_config_search'},
}

-- Make sure you have 'nvim_lsp' setup and running for LSP
vim.api.nvim_create_autocmd({"BufWritePost","BufNewFile", "BufRead"}, {
  pattern = "*.v",
  callback = function()
    vim.lsp.buf.format({ async = false })
  end,
})
