Plugins are managed and maintained with lazy.nvim.

lazy.nvim is bootstrapped and loaded by ~/.config/nvim/init.lua, which loads ~/.config/nvim/lua/lazy-bootstrap.lua.

By default, it will look for all lua files found in this directory and
incorporate them into the table used to manage plugins.

This directory contains 1) an init.lua listing plugins requiring no additional
config, and 2) lua files, one per plugin, with configuration for those that
need it.
