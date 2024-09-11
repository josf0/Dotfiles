vim.g.base46_cache = vim.fn.stdpath "data" .. "/nvchad/base46/"
vim.g.mapleader = " "

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end

vim.opt.rtp:prepend(lazypath)

local lazy_config = require "configs.lazy"

-- load plugins
require("lazy").setup({
  {
    "NvChad/NvChad",
    lazy = false,
    branch = "v2.5",
    import = "nvchad.plugins",
  },

  { import = "plugins" },
}, lazy_config)

-- load theme
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")

require "options"
require "nvchad.autocmds"

vim.schedule(function()
  require "mappings"
end)

-- Setting the filetype for Verilog
vim.api.nvim_create_autocmd(
  {"BufNewFile", "BufRead"}, {
    pattern = {"*.v"},
    command = "set filetype=verilog",
  }
)

-- Setting the filetype for SystemVerilog
vim.api.nvim_create_autocmd(
  {"BufNewFile", "BufRead"}, {
    pattern = {"*.sv"},
    command = "set filetype=systemverilog",
  }
)

-- -- Verilog Language Server
-- vim.api.nvim_create_autocmd('FileType', {
--   -- This handler will fire when the buffer's 'filetype' is "python"
--   pattern = {'verilog', 'systemverilog'},
--   callback = function()
--     vim.lsp.start({
--       name = 'verible',
--       cmd = {'verible-verilog-ls', '--rules_config_search'},
--     })
--   end,
-- })

-- Wilder minimal config 
local wilder = require('wilder')
wilder.setup({modes = {':', '/', '?'}})

-- Menu style
wilder.set_option('renderer', wilder.wildmenu_renderer(
  -- use wilder.wildmenu_lightline_theme() if using Lightline
  wilder.wildmenu_airline_theme({
    -- highlights can be overriden, see :h wilder#wildmenu_renderer()
    highlights = {default = 'StatusLine'},
    highlighter = wilder.basic_highlighter(),
    separator = ' · ',
  })
))

-- F5 to remove trailing whitespaces
vim.cmd[[ 
  "Remove all trailing whitespace by pressing F5
  nnoremap <F5> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar><CR>
]]

-- Setting tab spaces to 4 
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- vim.api.nvim_create_autocmd('ModeChanged', {
--   pattern = '*',
--   callback = function()
--     if ((vim.v.event.old_mode == 's' and vim.v.event.new_mode == 'n') or vim.v.event.old_mode == 'i')
--         and require('luasnip').session.current_nodes[vim.api.nvim_get_current_buf()]
--         and not require('luasnip').session.jump_active
--     then
--       require('luasnip').unlink_current()
--     end
--   end
-- })
