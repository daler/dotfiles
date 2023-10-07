-- Lua config for neovim.

vim.cmd("let mapleader=','") -- Re-map leader from default \ to , (comma)
vim.cmd("let maplocalleader = '\\'") -- Local leader becomes \.

require("lazy-bootstrap") -- Makes sure plugin manager is installed. See lua/lazy-bootstrap.lua
require("lazy").setup("plugins") -- Lazily-load plugins, see lua/plugins.lua
require("settings") -- See lua/settings.lua
require("mappings") -- See lua/mappings.lua
require("autocommands") -- See lua/autocommands.lua
require("colorscheme") -- See lua/colorscheme.lua
