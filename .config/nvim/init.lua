-- Lua config for neovim.
--
-- This is split into modules, which can be found in the lua/ directory.
--
-- Plugins are configured in the lua/plugins directory, see
-- lua/plugins/init.lua as the entrypoint.

-- Re-map leader from default \ to , (comma). This needs to be done before any
-- plugins are loaded.
vim.cmd("let mapleader=','")

-- Local leader becomes \.
vim.cmd("let maplocalleader = '\\'")

require("lazy-bootstrap") -- Makes sure plugin manager is installed. See lua/lazy-bootstrap.lua
require("lazy").setup("plugins") -- Lazily-load plugins. See lua/plugins/init.lua
require("settings") -- See lua/settings.lua
require("mappings") -- See lua/mappings.lua
require("autocommands") -- See lua/autocommands.lua
require("colorscheme") -- See lua/colorscheme.lua
