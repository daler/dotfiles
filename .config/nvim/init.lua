-- Lua config for neovim. This is split into modules, which can be found in the
-- lua/ directory.

require("settings")               -- See lua/settings.lua
require("lazy-bootstrap")         -- See lua/lazy-bootstrap.lua
require("lazy").setup("plugins")  -- lazily-load plugins. See lua/plugins/init.lua
require("mappings")               -- See lua/mappings.lua
require("autocommands")           -- See lua/autocommands.lua
