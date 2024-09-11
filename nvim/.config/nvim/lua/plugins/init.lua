return {
  {"gelguy/wilder.nvim", lazy=false},
  {"xiyaowong/transparent.nvim", lazy=false},
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.conform",
  },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    lazy=false,
    config = function()
      require "configs.lspconfig"
    end,
  },
}
