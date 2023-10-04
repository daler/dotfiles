Nvim
====

This page describes the Neovim-specific configuration. Nvim has added a lot of
features compared to Vim, including Lua support, language server protocol
support, and more.

Some of this is easy to configure and you'll get it for free just by using the
dotfiles. But for all of it to work, you'll need to install a couple more
things.

WhichKey
--------

This plugin pops up a temporary window with key bindings. It will pop up after
1 second of not typing, but you can configure this by adjusting
``vim.o.timeout``.


indent-blankline
----------------

Adds guidelines showing where the indentation levels are.

If you have treesitter installed and set up, this will highlight in slightly
brighter color the current context (the function, method, for-loop, etc) you're
in.

Setting up for language servers
-------------------------------

This is probably the biggest lift in terms of extra setup.

Language servers parse the code you're working on and highlight potential
errors. They also support linting code to make sure it meets style standards.

.. code-block:: bash

  ./setup.py --install-npm
  ./setup.py --install-base-r

This makes npm (NodeJS package manager) available on the path, by installing it
into a conda env. This is needed in order to install language parsers.

Start nvim.

Run ``:Mason``. This will pull up a menu with a LOT of possible language
servers. You'll install some in a moment, but keep in mind that you'll get
a log that shows up at the top. ``gg`` to get to the top. ``Enter`` shows more
information. ``i`` installs.

If you've installed npm, try installing the pyright language server. Search for
it, ``i`` to install, and ``gg`` to watch the installation log.

You can do the same thing for ``marksman`` and ``lua-language-server``.

If you want it for R, you'll need to first activate an environment with R in it.


nvim-cmp
--------
`nvim-cmp <https://github.com/hrsh7th/nvim-cmp>`_ provides tab-completion.

By default, this would show a tab completion window on every keypress, which to
me is annoying and distracting. So this is configured to only show up when
I hit TAB.

Hit tab to initiate. Hit tab until you like what you see, and then keep typing.
Arrow keys work to scroll as well. Then keep typing, no need to hit Enter.

If you're running an LSP in the buffer, it will tab-complete methods,
attributes, etc. Use the arrows and mouse wheel to read through help.

beacon
------
`beacon <https://github.com/DanilaMihailov/beacon.nvim>`_ helps you find the
cursor. Use :keyboard:`Shift-kj` to flash a "beacon" -- an animated stripe that
shows you where the cursor is. This is configured to only show when you ask for
it, or when you search for something and jump to the next or previous hit.

