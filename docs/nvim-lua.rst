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

- Open a file browser with :kbd:`<leader>fbo`, hit Enter to select, or :kbd:`-`
  to go up a level

- Open a Python file with lots of classes/functions, or a markdown or RMarkdown
  file. Use :kbd:`<leader>a` to open a panel for navigation within the file.


Don't like it? Do this to revert:

.. code-block::

  # aaaaah! revert! revert!
  mv ~/.config/nvim ~/.config/nvim-lua
  mv ~/.config/nvim-backup ~/.config/nvim
  rm ~/.vimrc
  mv ~/.vimrc-backup ~/.vimrc
  mv ~/.vim-backup ~/.vim

The rest of this page gives some more context so you can make your own changes.

Structure
---------

First, there's no more ``init.vim``. It's ``init.lua`` instead.

There is an additional :file:`lua/plugins/init.lua` which holds plugin configuration.

I had initially completely modularized things into separate settings,
autocommands, mappings, colorscheme, and plugins files. But after living with
that a bit, I decided to go back to a single main config with settings,
mappings, autocommands, and colorscheme, and only having a separate plugins
file.

Lua
---

Here's `nvim docs on Lua modules
<https://neovim.io/doc/user/lua-guide.html#lua-guide-modules>`_ for more info
on working with Lua.

But for a quick intro, here are some of my notes:

- Any vim commands can be trivially converted to Lua by wrapping them in
  ``vim.cmd()``. See the `nvim docs on running Vim commands with Lua
  <https://neovim.io/doc/user/lua-guide.html#lua-guide-vim-commands>`_ for more
  info.

- ``--`` indicates comments

- Lua makes extensive use of *tables*. A table is delimited by ``{}``. It's an
  associative array, sort of like like a Python dict, or an R named list, or
  a Perl hash.

  .. code-block:: lua

    -- a table
    { a = 1, b = "asdf" }

- Functions are defined with a ``function ... end`` block. Functions can be
  called multiple different ways. Function can be anonymous

  .. code-block:: lua

    function (arg1, arg2)
      return arg1 + arg2
    end

- Functions can be called in different ways. Parentheses are optional if the
  function has a single argument. Here are some examples from the `Lua docs on
  functions <https://www.lua.org/pil/5.html>`_:

  .. code-block::

    print "Hello World"     <-->     print("Hello World")
    dofile 'a.lua'          <-->     dofile ('a.lua')
    print [[a multi-line    <-->     print([[a multi-line
     message]]                        message]])
    f{x=10, y=20}           <-->     f({x=10, y=20})
    type{}                  <-->     type({})

- Import other Lua code with the ``require`` function. If ``init.lua`` is in
  a directory, requiring that directory will automatically use the ``init.lua``
  (it's like Python's ``__init__.py``). See the `nvim docs on lua modules
  <https://neovim.io/doc/user/lua-guide.html#lua-guide-modules>`_ for more.

lazy.vim for plugins
--------------------

This config uses `lazy.nvim <https://github.com/folke/lazy.nvim>`_ for managing
plugins. I like the design of how it encourages modular plugin configs. This
also encourages and supports keeping the plugin-specific keymappings with the
plugin itself. The interface is also quite nice (though you need a `patched Nerd
Font <https://www.nerdfonts.com/font-downloads>`_ for your font of interest, and
this font should be configured to be used by the terminal program you're using).

The lazy-loading aspect of it is a bonus.

Mappings
--------

For Lua, see the `nvim docs on creating mappings with Lua
<https://neovim.io/doc/user/lua-guide.html#lua-guide-mappings>`_ for more
details. This is for mappings created within :file:`init.lua`, for example.

.. code-block:: lua

    -- directly in Lua
    vim.keymap.set("n", "<leader>1", ":bfirst<CR>", { desc = "First buffer" })

For plugins managed by lazy.nvim, they are specified in the ``keys`` property
of the plugin's table:

.. code-block:: lua

    -- in a plugin
    {
      "plugin/name",
      keys = {
        { "<leader>1", ":bfirst<CR>", desc = "First buffer" },
      },
      -- possibly other stuff for plugin...
    }


In both cases, note the use of ``desc``. This description is picked up by the
which-key plugin to populate the menu. When setting in Lua directly, ``desc``
needs to be in a table. When setting in a plugin config, it's not in a table.

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
    keys = {
      -- ... see above for discussion of keys
    },
    cmd = {
      -- 
  }
