.. _vim:

Vim (neovim) configuration
==========================

See :ref:`why` for why nvim (short for `Neovim <https://neovim.io/>`__)
instead of vim.

The nvim community moves quickly, and this config and these accompanying docs
change more often than any other configs in this repo.

**You can take these new changes for a test drive** by running

.. code-block:: bash

   ./setup.sh --nvim-test-drive

This will move existing nvim config and plugins to backup directories. This
does not affect any other config (like bash). You can always roll back to what
you had before. The commands to roll back are printed at the end of the
command.

Config file location
--------------------

The nvim configuration is split over multiple files.

This makes it easier to see what changed, and decide if you want those changes
or not. It also enables us to import the config files into this documentation
to easily view them (look for the "**Config:**" dropdowns).

This is just a starting point, **you should adjust the config to
your liking!**

Here is a description of the different pieces of the nvim config. Paths are
relative to :file:`~/.config/nvim`:

.. details:: init.lua

  The file :file:`.config/nvim/init.lua` is the entry point of the nvim config.
  This in turn loads files in the :file:`lua` subdirectory. For example, the
  syntax ``require("config.lazy")`` will load
  :file:`.config/nvim/lua/config/lazy.lua`.

  .. literalinclude:: ../.config/nvim/init.lua
    :language: lua

.. details:: lua/config/lazy.lua

  :file:`.config/nvim/lua/config/lazy.lua` loads the `lazy.nvim
  <https://github.com/folke/lazy.nvim>`__ plugin manager. The plugins in the
  :file:`.config/nvim/lua/plugins` directory are loaded here.

  .. literalinclude:: ../.config/nvim/lua/config/lazy.lua
    :language: lua

.. details:: lua/config/options.lua

  :file:`.config/nvim/lua/config/options.lua` sets global options.

  .. literalinclude:: ../.config/nvim/lua/config/options.lua
    :language: lua

.. details:: lua/config/autocmds.lua

  :file:`.config/nvim/lua/config/autocmds.lua` configures autocommands --
  settings that are specific to a filetype or that should be triggered on
  certain events.

  .. literalinclude:: ../.config/nvim/lua/config/autocmds.lua
    :language: lua

.. details:: lua/config/keymaps.lua

  :file:`.config/nvim/lua/config/keymaps.lua` configures keymappings that are
  not otherwise configured in the individual plugin configs.


  .. literalinclude:: ../.config/nvim/lua/config/keymaps.lua
    :language: lua

.. details:: lua/plugins/

  Each plugin is described in more detail below in its own section. Each has
  its own file in the :file:`.config/nvim/lua/plugins` directory.


Leader key
----------

The leader key is remapped to :kbd:`,`. This is configured in :file:`.config/nvim/init.lua`.

.. list-table::
    :header-rows: 1
    :align: left

    * - command
      - description

    * - :kbd:`,`
      - Remapped leader. Below, when you see :kbd:`<leader>` it means :kbd:`,`.

.. _buffers:


Opening multiple files
----------------------

.. list-table::
   :header-rows: 1
   :align: left

   * - command
     - description

   * - :kbd:`:e` <filename>
     - Open filename in new buffer

   * - :kbd:`<leader>ff`
     - Search for file in directory to open in new buffer (Telescope)

   * - :kbd:`<leader>fb`
     - Toggle file browser, hit Enter on file


Switching between open files
----------------------------

.. list-table::
   :header-rows: 1
   :align: left

   * - command
     - description
     - configured in

   * - :kbd:`[b`, :kbd:`]b`
     - Prev and next buffers
     - :file:`lua/config/keymaps.lua`

   * - :kbd:`H`, :kbd:`L`
     - Prev buffer, next buffer
     - :file:`lua/config/keymaps.lua`

   * - :kbd:`<leader>1`, :kbd:`<leader>2`
     - First buffer, last buffer
     - :file:`lua/config/keymaps.lua`

   * - :kbd:`<leader>b` then type highlighted letter in tab
     - Switch buffer
     - :file:`lua/plugins/bufferline.lua`

.. details:: Don't like this?

   See the config for the :ref:`bufferline_ref` plugin to change; the
   bufferline is additionally styled using the colorscheme.

.. details:: Screencast of switching buffers

  This example uses an older version of the bufferline plugin and so the
  styling is a little different, but the shortcuts demonstrated are the same. 

  .. image:: gifs/buffers_annotated.gif


Shortcuts
---------

Here are the shortcuts configured in the main config. See :ref:`plugins` for
all the plugin-specific shortcuts.

You can browse around to see if there's anything you think might be useful, but
there's no need for you to know all these! I happen to use them, and since I've
included them in this config you get them for free.

The :ref:`whichkey_ref` plugin will pop up a window showing what keys you can
press, so you can use that for exploration as well.


.. list-table::
    :header-rows: 1
    :align: left

    * - command
      - description
      - configured in

    * - :kbd:`<leader>H`
      - Toggle highlighted search. Sometimes it's distracting to have all the
        highlights stick around.
      - :file:`lua/config/keymaps.lua`

    * - :kbd:`<leader>W`
      - Remove all trailing spaces in the file. Useful when cleaning up code to
        commit.
      - :file:`lua/config/keymaps.lua`

    * - :kbd:`<leader>R`
      - Refresh syntax highlighting. Useful when syntax highlighting gets wonky.
      - :file:`lua/config/keymaps.lua`

    * - :kbd:`@l`
      - Macro to surround the line with quotes and add a trailing comma. Useful
        for making Python or R lists out of pasted text
      - :file:`lua/config/keymaps.lua`

    * - :kbd:`<leader>-`
      - Fills in the rest of the line with "-", out to column 80. Useful for
        making section separators.
      - :file:`lua/config/keymaps.lua`

    * - :kbd:`<leader><TAB>`
      - Useful for working with TSVs. Starts the command ``:set nowrap
        tabstop=`` but then leaves the cursor at the vim command bar so you can
        fill in a reasonble tabstop for the file you're looking at.
      - :file:`lua/config/keymaps.lua`

    * - :kbd:`<leader>\``
      - (that's a backtick) Adds a new RMarkdown chunk and places the cursor
        inside it
      - :file:`lua/config/autocmds.lua`

    * - :kbd:`<leader>d`
      - Insert the current date as a ReST or Markdown-formatted title,
        depending on the file type. Useful when writing logs.
      - :file:`lua/config/autocmds.lua`

    * - :kbd:`<leader>p`
      - Paste the contents of the OS clipboard into a formatted link as
        appropriate for the file type (ReST and Markdown currently supported)
        and puts the cursor in the link description. Note that this will *not*
        work to paste to vim on a remote server, unless you do tricky things
        with X forwarding, so consider it local-only.
      - :file:`lua/config/autocmds.lua`

    * - :kbd:`<leader>cp`
      - Toggle a sort of "copy mode". Turns off line numbers, the vertical
        indentation lines from indent-blankline, any sign columns, and
        render-markdown (if enabled) so you can more easily copy text into
        another app.
      - :file:`lua/config/keymaps.lua`

    * - :kbd:`<leader>ts`
      - Insert a timestamp of the form ``YYYY-MM-DD HH:MM``
      - :file:`lua/config/keymaps.lua`

.. versionchanged:: 2024-01-21

  Added :kbd:`<leader>p` for pasting formatted Markdown/ReST links

.. versionchanged:: 2024-03-31

   Added :kbd:`<leader>cp` for a convenient "copy mode"

.. versionchanged:: 2024-09-01

   :kbd:`<leader>cp` is more complete (toggles render-markdown and sign columns, too)

Other behaviors
---------------

Here are some other behaviors that are configured in :file:`.config/nvim/lua/config/options.lua`; expand for details.

.. details:: Non-printing characters

  <TAB> characters look like ``>••••``. Trailing spaces show up as dots like
  ``∙∙∙∙∙``. Differentiating between tabs and spaces is extremely helpful in
  tricky debugging situations.

  :file:`~/.config/nvim/lua/config/autocmds.lua` has these lines:

  .. code-block:: lua

      vim.cmd(":autocmd InsertEnter * set listchars=tab:>•")
      vim.cmd(":autocmd InsertLeave * set listchars=tab:>•,trail:∙,nbsp:•,extends:⟩,precedes:⟨")

  The autocmds here mean that we only show the trailing spaces when we're outside
  of insert mode, so that every space typed doesn't show up as trailing. When
  wrap is off, the characters for "extends" and "precedes" indicate that there's
  text offscreen.


.. details:: Formatting text

  The following options change the behavior of various formatting; see ``:h formatoptions``:

  .. code-block:: lua

      vim.opt.formatoptions = "qrn1coj"

  Explanation of these options:

  - q: gq also formats comments
  - r: insert comment leader after <Enter> in insert mode
  - n: recognize numbered lists
  - 1: don't break a line after a 1-letter word
  - c: autoformat comments
  - o: automatically insert comment leader afer 'o' or 'O' in Normal mode.
  -    Use Ctrl-u to quickly delete it if you didn't want it.
  - j: where it makes sense, remove a comment leader when joining lines

.. details:: Spell check

  In case you're not aware, vim has built-in spellcheck.

  .. list-table::
      :header-rows: 1
      :align: left

      * - command
        - description

      * - ``:set spell``
        - Enable spell check

      * - :kbd:`]s`
        - Next spelling error

      * - :kbd:`[s`
        - Previous spelling error

      * - :kbd:`z=`
        - Show spelling suggestions

.. details:: Line coloring and cursor

   See :file:`.config/nvim/lua/config/options.lua` for the ``set cul`` and ``set nocul`` options and set to your liking

Plugin documentation
--------------------

See the separate section :ref:`plugins` for documentation.
