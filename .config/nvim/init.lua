-- Lua config for neovim. Coming from Vim lanuage? See
-- https://neovim.io/doc/user/lua.html for the basics.

-- leader must be set before plugins are set up.
vim.cmd("let mapleader=','") -- Re-map leader from default \ to , (comma)
vim.cmd("let maplocalleader = '\\'") -- Local leader becomes \.

-- This allows nvim-tree to be used when opening a directory in nvim.
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.cmd("set termguicolors") -- use full color in colorschemes

require("config.lazy")
require("config.options")

-- Colorscheme.
-- Add your favorite colorscheme to lua/plugins/colorscheme.lua (which will be
-- loaded with `config.lazy` above), and then use it here.
vim.cmd("colorscheme zenburn")

-- Uncomment these lines if you use a terminal that does not support true color:
-- vim.cmd("colorscheme onedark")
-- vim.cmd("set notermguicolors")

require("config.keymaps")
require("config.autocmds")

-- vim: nowrap
