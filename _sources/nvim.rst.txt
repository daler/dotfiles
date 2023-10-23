Nvim
====

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

