-- zenburn is a colorscheme
-- Note that this is a fork, which allows more customization
return {
  {
    "daler/zenburn.nvim",

    -- lazy.nvim recommends using these settings for colorschemes so they load
    -- quickly
    lazy = false,
    priority = 1000,
  },
  -- gruvbox is an example of an alternative colorscheme, here disabled
  {
    "morhetz/gruvbox",
    enabled = false,
    lazy = false,
    priority = 1000,
  },

  -- onedark is another colorscheme, here enabled as a fallback for terminals
  -- with no true-color support like the macOS Terminal.app.
  {
    "joshdick/onedark.vim",
    lazy = false,
    priority = 1000,
  },
  { "daler/zenfade", dependencies = { "rktjmp/lush.nvim" }, lazy = false, priority = 1000 },
}
