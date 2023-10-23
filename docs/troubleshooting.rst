Troubleshooting
===============

Vim has light gray text, colorscheme looks broken
-------------------------------------------------

Are you using Mac's built-in Terminal app? Terminal.app does not support true
colors, so the true-color default zenburn colorscheme (or any true color
colorscheme) will not work.

Run this command to see if your terminal supports true color. If it shows up in
red, then it supports true color. If it just looks like regular black text,
your terminal does NOT support true color.

.. code-block:: bash

   printf "\x1b[38;2;255;100;0mTRUECOLOR\x1b[0m\n"

If you are unable to use a terminal emulator like iTerm2, alacritty, kitty,
etc, that supports 24-bit colors, then you can use a different color scheme.

You can find an excellent writeup of this at `docs for the onedark colorscheme
<https://github.com/joshdick/onedark.vim#troubleshooting>`_.

As a fallback, you can make the following changes in your
:file:`./config/nvim/init.lua` file. This will turn off termguicolors (the
setting in vim that supports true color) and set the colorscheme to onedark,
which supports 256- and 16-color-only terminals:

.. code-block:: lua

   -- vim.cmd("colorscheme zenburn")
   vim.cmd("colorscheme onedark")

   -- vim.cmd("set termguicolors")
   vim.cmd("set notermguicolors")



Comments don't show up as italic
--------------------------------

This is a bit of a rabbit hole, but it's due to an interaction between
terminals and tmux and nvim.

`This gist <https://gist.github.com/bbqtd/a4ac060d6f6b9ea6fe3aabe735aa9d95>`_
has a nice writeup and description of the fix.

For Alacritty, see `this gist
<https://gist.github.com/andersevenrud/015e61af2fd264371032763d4ed965b6>`_,
which also includes a setting you need in
:file:`.config/alacritty/alacritty.yml`.

Can't install conda packages from Bioconda
------------------------------------------
Bioconda does not yet build packages for Mac ARM chips (Mac M1 or M2). You can
install docker and use a container, or wait until Bioconda starts building
those packages.
