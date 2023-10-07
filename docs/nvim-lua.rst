.. _nvim-lua:

Migrating to Neovim Lua config
==============================

Neovim has been supporting a lot of interesting new features. Historically,
in these dotfiles I've tried to largely maintain backward compatibility with vim
by keeping :file:`.config/nvim/init.vim` symlinked to :file:`.vimrc`. But I realized
that this was preventing me from using a lot of the new functionality.

One of the nice features of nvim is being able to configure with Lua. I've never
been able to get the hang of VimL (the internal vim language), but was able to
quickly pick up Lua since it has a lot of similarities with Python. It is very
empowering to have the full use of a language like Lua to use in configuration!

I finally decided to take the plunge and convert my vim+neovim config into
a full-fledged Lua nvim config. This forces a dichotomy between vim and nvim,
but realistically I only ever use nvim. Now there's only a barebones ``.vimrc``
for the rare occasions when I need to use :file:`/usr/bin/vim` for some reason.

This page is for those of you who have used these dotfiles before, and might
even have modified your own vim+nvim config...but now with with this newfangled
config you don't know what's going on!

**TL;DR: to try out the new version**

First, back up your existing config.

.. code-block:: bash

   # Back up old files
   mv ~/.config/nvim ~/.config/nvim-backup
   mv ~/.vimrc ~/.vimrc-backup
   mv ~/.vim ~/.vim-backup

Then manually copy the relevant files from this repo (that is, don't use the
``--dotfiles`` argument to :file:`setup.sh` since that will copy over more than
just these):

.. code-block:: bash

   # here we refer to the dotfiles repo dir;
   # modify accordingly for where you put it.
   cp -r dotfiles/.config/nvim ~/.config/nvim
   cp dotfiles/.vimrc ~/.vimrc

Then open up nvim, and wait for the installations to complete. You should be
good to go.

Here are some initial things to try:

- :kbd:`<leader>` (by default, :kbd:`,`) and then wait a second. You'll get
  a menu that pops up, showing you the currently-configured key mappings that
  follow <leader>. Hitting a listed key will execute the command. Sometimes
  you'll see ``-> +prefix`` in the menu, which means you can hit that key to see
  a menu of the things you can type after that. If you go too far, use
  :kbd:`<Backspace>` to go back a step.

  In fact, you can hit backspace a few times to get to the base vim commands. It
  can be helpful to look through to see if there's any you've forgotten about!

- which-key also pops up if you use :kbd:`'` (for marks), and helps you navigate
  between them.

- :kbd:`z=` over a word to get a pop-up for spelling suggestions

- Saner tab completion (hit tab until you like what you see). Snippets are
  enabled, so if you're in a Python file for example, type ``def`` and then hit
  :kbd:`<Tab>`. One of the options will be a snippet to create a Python
  function. There are also other "flavors" of snippets, for example whether you
  want to return from the function, o if you're writing method. Use
  :kbd:`<Tab>` to jump between the placeholders, and immediately start typing
  to replace them.

- :kbd:`KJ` (so, hold down shift and type ``kj``) to flash a beacon
  where the cursor is. This also works when jumping between search hits.

- :kbd:`<leader>ff` to open a file selector within this directory

- :kbd:`<leader>fg` to live-grep within the directory (hit enter on the search
  result to open the file at that location). Great for exploring new codebases.

- Open a file in a git repo with some changes. Then use :kbd:`]c` to go to the
  next change (hunk) and :kbd:`<leader>hp` to preview hunks.

Don't like it? Do this to revert:

.. code-block::

  # aaaaah! revert! revert!
  mv ~/.config/nvim ~/.config/nvim-lua
  mv ~/.config/nvim-backup ~/.config/nvim
  rm ~/.vimrc
  mv ~/.vimrc-backup ~/.vimrc
  mv ~/.vim-backup ~/.vim

The rest of this page gives some more context so you can make your own changes.

.config/nvim/init.vim -> .config/nvim/init.lua
----------------------------------------------

First, there's no more ``init.vim``. It's ``init.lua`` instead. When you open up
this file, there's very little to see. That's because the config has been
modularized into more pieces.

How Lua finds files
-------------------

When you say:

.. code-block:: lua

   require('settings')

Lua will look in the :file:`lua` directory for a file called
:file:`lua/settings.lua`, and run it. If there's a :file:`init.lua` file in
a directory, you can require that directory without needing to specify a file
name.

Here's `nvim docs on Lua modules
<https://neovim.io/doc/user/lua-guide.html#lua-guide-modules>`_ for more info.

lazy.vim for plugins
--------------------

This config uses `lazy.nvim <https://github.com/folke/lazy.nvim>`_ for managing
plugins. I like the design of how it encourages modular plugin configs. This
also encourages and supports keeping the plugin-specific keymappings with the
plugin itself. The interface is also quite nice (though you need a `patched Nerd
Font <https://www.nerdfonts.com/font-downloads>`_ for your font of interest, and
this font should be configured to be used by the terminal program you're using).

The lazy-loading aspect of it is a bonus.

The :file:`init.lua` file
-------------------------

- :file:`lua/settings.lua` has general vim settings
- :file:`lua/plugins/` directory has plugin configs, which are found by
  the ``lazy.nvim`` plugin manager. See :ref:`how-plugins-work` for details.
- :file:`lua/mappings.lua` has keymappings. Note that keymappings related to
  plugins are not configured here but instead in their respective plugin config.
- :file:`lua/autocommands.lua` has autocommands, which are things to run on
  particular triggers or particular kinds of buffers.

Read on for more on each file.

:file:`lua/settings.lua`
~~~~~~~~~~~~~~~~~~~~~~~~
:file:`lua/settings.lua`, is largely a direct translation of VimL to Lua. I just
wrapped the commands in ``vim.cmd()`` calls. Importantly, ``<leader>`` is set
here, which needs to be done before any plugins are loaded, which is why this
file is "require"d first in :file:`init.lua`. Here's `nvim docs on running Vim
commands with Lua
<https://neovim.io/doc/user/lua-guide.html#lua-guide-vim-commands>`_ for more
info.

:file:`lua/plugins/`
~~~~~~~~~~~~~~~~~~~~

:file:`init.lua` runs the ``lazy.nvim`` plugin manager, giving it ``"plugins"``
as its only parameter. This points lazy.nvim to the :file:`lua/plugins`
directory. This directory has :file:`lua/plugins/init.lua` which is run.
``lazy.nvim`` also scans the :file:`plugins` directory for other files, which
contain configuration for various plugins. See :ref:`how-plugins-work` for more
on this.

:file:`lua/mappings`
~~~~~~~~~~~~~~~~~~~~

:file:`lua/mappings.lua` has keymappings. Here, we use the ``vim.keymap.set``
command to set mappings. Importantly, we provide the ``desc`` argument to all of
the mappings. These descriptions are automatically discovered by the
``which-key`` plugin, which shows a pop-up menu after a second or so. It shows
the possible key combinations you can do.

:file:`lua/colorscheme`
~~~~~~~~~~~~~~~~~~~~~~~

I realized that the zenburn colorscheme I've been using for many years was
behaving a little differently due to the interaction of treesitter and the
zenburn.nvim colorscheme. So I made some tweaks. However, these tweaks only
work after the colorscheme has been set -- and since it's a plugin, it is
handled by :file:`lua/plugins.lua`. So this has to be done at the end -- hence,
a separate colorscheme file loaded at the end.

I'm sure there's a better way to do this, but it's the best I could come up
with that also allows others to swap out what they want to use.

.. _how-plugins-work:

How to add/configure plugins
----------------------------

Edit :file:`lua/plugins.lua`.

Follow the existing plugin files for a guide, but basically you're aiming for
something like this:

.. code-block:: lua

  return {
    "username/reponame",
    config = function()
      -- stuff here for setup. Might include keybindings or more complicated
      -- things.
    end,
  }
