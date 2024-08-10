.. _vim:

Neovim configuration
====================


Files
-----

The file :file:`.config/nvim/init.lua` is the entry point of the nvim config.
Unless otherwise specified, paths on this page are relative to
:file:`~/.config/nvim`.


- :file:`~/.config/nvim/init.lua` has general settings.
- :file:`~/.config/nvim/lua/plugins.lua` has plugin settings.

The :file:`.vimrc` file has only basic setup for vim, in case you need to use
:file:`/usr/bin/vim`.

.. note::

    See :ref:`nvim-lua` and :ref:`Why Lua <why-lua>` if you're coming here from using older
    versions of these dotfiles.

Screencasts
-----------

.. versionadded:: 2024-03-31

Sometimes it's much easier to see what's going on than to read about it...

.. details:: screencast of lazy.nvim setting up plugins

   See :ref:`plugins_` for more details.

  .. image:: gifs/lazy_annotated.gif

.. details:: screencast of switching buffers

   See :ref:`buffers` for more; this uses :ref:`bufferline` for the tabs,
   :ref:`nvimtree` for the file tree, and :ref:`telescope_ref` for the
   fuzzy-finder.

  .. image:: gifs/buffers_annotated.gif

Using the mouse
---------------

In addition to allowing clicking and scrolling, ``set mouse=a`` also:

- Supports mouse-enabled motions. To try this, left-click to place the cursor.
  Type :kbd:`y` then left-click to yank from current cursor to where you next
  clicked.
- Drag the status-line or vertical separator to resize
- Double-click to select word; triple-click for line

Non-printing characters
-----------------------
Non-printing characters (tab characters and trailing spaces) are displayed.
Differentiating between tabs and spaces is extremely helpful in tricky
debugging situations.

:file:`~/.config/nvim/init.lua` has these lines:

.. code-block:: lua

    vim.cmd(":autocmd InsertEnter * set listchars=tab:>•")
    vim.cmd(":autocmd InsertLeave * set listchars=tab:>•,trail:∙,nbsp:•,extends:⟩,precedes:⟨")

With these settings <TAB> characters look like ``>••••``. Trailing spaces show up
as dots like ``∙∙∙∙∙``.

The autocmds here mean that we only show the trailing spaces when we're outside
of insert mode, so that every space typed doesn't show up as trailing. When
wrap is off, the characters for "extends" and "precedes" indicate that there's
text offscreen.

.. _buffers:

Switching buffers
-----------------

.. versionadded:: 2023-11-01
   :kbd:`<leader>b` using bufferline plugin

Three main ways of **opening** file in a new buffer:

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
     - Toggle file browser, hit Enter on file (nvim-tree)

See :ref:`nvimtree` for more on navigating the file tree shown by :kbd:`<leader>fb`.

Once you have multiple buffers, you can **switch** between them in these ways:

.. list-table::
   :header-rows: 1
   :align: left

   * - command
     - description

   * - :kbd:`[b`, :kbd:`]b`
     - Prev and next buffers

   * - :kbd:`H`, :kbd:`L`
     - Prev buffer, next buffer

   * - :kbd:`<leader>1`, :kbd:`<leader>2`
     - First buffer, last buffer

   * - :kbd:`<leader>b` then type highlighted letter in tab
     - Switch buffer

The display of the bufferline is configured in :file:`lua/plugins.lua`, as part
of the bufferline plugin. It is additionally styled using the
:ref:`zenburn` plugin/colorscheme.

Format options explanation
--------------------------

The following options change the behavior of various formatting; see ``:h formatoptions``:

.. code-block:: lua

    vim.cmd("set formatoptions=qrn1coj")

Explanation of these options:

- q: gq also formats comments
- r: insert comment leader after <Enter> in insert mode
- n: recognize numbered lists
- 1: don't break a line after a 1-letter word
- c: autoformat comments
- o: automatically insert comment leader afer 'o' or 'O' in Normal mode.
-    Use Ctrl-u to quickly delete it if you didn't want it.
- j: where it makes sense, remove a comment leader when joining lines

Spell check
-----------

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


Shortcuts
---------

.. versionchanged:: 2024-01-21

  Added :kbd:`<leader>p` for pasting formatted Markdown/ReST links

.. versionchanged:: 2024-03-31

   Added :kbd:`<leader>cp` for a convenient "copy mode"


Here are some general shortcuts that are defined in the included config. With
the ``which-key`` plugin, many of these are also discoverable by hitting the
first key and then waiting a second for the menu to pop up.

.. note::

  **Mappings that use a plugin** are configured in the :file:`lua/plugins.lua`
  file and are described below under the respective plugin's section.

If you're definign your own keymappings, add a ``desc`` argument so that
which-key will provide a description for it.

.. list-table::
    :header-rows: 1
    :align: left

    * - command
      - description

    * - :kbd:`,`
      - Remapped leader. Below, when you see :kbd:`<leader>` it means :kbd:`,`.

    * - :kbd:`<leader>r`
      - Toggle relative line numbering (makes it easier to jump around lines
        with motion operators).

    * - :kbd:`<leader>H`
      - Toggle highlighted search. Sometimes it's distracting to have all the
        highlights stick around.

    * - :kbd:`<leader>W`
      - Remove all trailing spaces in the file. Useful when cleaning up code to
        commit.

    * - :kbd:`<leader>R`
      - Refresh syntax highlighting. Useful when syntax highlighting gets wonky.

    * - :kbd:`@l`
      - Macro to surround the line with quotes and add a trailing comma. Useful
        for making Python or R lists out of pasted text

    * - :kbd:`<leader>-`
      - Fills in the rest of the line with "-", out to column 80. Useful for
        making section separators.

    * - :kbd:`<leader><TAB>`
      - Useful for working with TSVs. Starts the command ``:set nowrap
        tabstop=`` but then leaves the cursor at the vim command bar so you can
        fill in a reasonble tabstop for the file you're looking at.

    * - :kbd:`<leader>\``
      - (that's a backtick) Adds a new RMarkdown chunk and places the cursor
        inside it

    * - :kbd:`<leader>ry`
      - Used for RMarkdown; writes commonly-used YAML front matter (mnemonic:
        rmarkdown yaml)

    * - :kbd:`<leader>ko`
      - Used for RMarkdown; writes an RMarkdown chunk with commonly-used knitr
        global options (mnemonic: knitr options)

    * - :kbd:`<leader>d`
      - Insert the current date as a ReST or Markdown-formatted title,
        depending on the file type. Useful when writing logs.

    * - :kbd:`<leader>p`
      - Paste the contents of the OS clipboard into a formatted link as
        appropriate for the file type (ReST and Markdown currently supported)
        and puts the cursor in the link description. Note that this will *not*
        work to paste to vim on a remote server, unless you do tricky things
        with X forwarding, so consider it local-only.

    * - :kbd:`<leader>cp`
      - Toggle a sort of "copy mode". Turns off line numbers and the vertical
        indentation lines from indent-blankline, so you can more easily copy
        text into another app.

.. _plugins_:

Plugins
-------

The plugins configured in :file:`lua/plugins.lua` have lots and lots of
options. Here I’m only highlighting the options I use the most, but definitely
check out each homepage to see all the other weird and wonderful ways they can
be used.

**Plugins are now configured using** `lazy.nvim
<https://github.com/folke/lazy.nvim>`_. This supports lazy-loading of plugins
to keep a snappy startup time, and only load plugins when they're needed. See
:ref:`nvim-lua` for my rationale on that.



Each plugin spec in :file:`lua/plugins.lua` is a table. The first property is
the name of the plugin. Other properties:

* ``lazy``: only load when requested by something else. Saves on initial load
  time, but use this with care since it can get confusing.

* ``ft``: only load the plugin when editing this filetype. Implies lazy=true.

* ``cmd``: only load the plugin when first running this command. Implies lazy=true.

* ``keys``: only load the plugin when using these keymappings. Implies lazy=true.

* ``config``: run this stuff after the plugin loads. If config = true, just run
  the default setup for the plugin.

* ``init``: similar to config, but used for pure-vim plugins

If keys are specified, this is the only place they need to be mapped, and they
will make their way into the which-key menu even if they trigger a lazy-loaded
plugin. Use the ``desc`` argument to give which-key a description to use.

Here, plugins are sorted roughly so that the ones that provide additional
commands come first.

.. note::

    Don't like a plugin? Find it in :file:`lua/plugins.lua` and add ``enabled
    = false`` next to where the plugin is named. For example:

    .. code-block:: lua

      -- ... other stuff
      { "user/plugin-name", enabled = false },
      -- ... more stuff

    Or delete it, or comment it out.


The vim config has changed over the years. Depending on when you last updated,
there may be plugins added or removed or changed in some way. This table keeps
track of what has changed recently.

.. list-table::
   :header-rows: 1
   :align: left

   * - plugin
     - date added
     - date changed

   * - :ref:`vimtmuxclipboard`
     - 2016
     -

   * - :ref:`vimpythonpep8indent`
     - 2017
     -

   * - :ref:`vimfugitive`
     - 2018-09-26
     -

   * - :ref:`vimdiffenhanced`
     - 2019-02-27
     -

   * - :ref:`vimtablemode`
     - 2019-03-27
     -

   * - :ref:`vis_ref`
     - 2019-09-30
     -

   * - :ref:`vimgv`
     - 2021-02-14
     -

   * - :ref:`vimmergetool`
     - 2021-02-14
     -

   * - :ref:`toggleterm_ref`
     - 2022-12-27
     - 2024-03-31

   * - :ref:`vimsurround`
     - 2022-12-27
     -

   * - :ref:`nvimtree`
     - 2023-10-10
     -

   * - :ref:`diffview`
     - 2023-10-11
     -

   * - :ref:`acceleratedjk`
     - 2023-10-15
     -

   * - :ref:`beacon_ref`
     - 2023-10-15
     - 2023-11-07

   * - :ref:`gitsigns_ref`
     - 2023-10-15
     -

   * - :ref:`indentblankline`
     - 2023-10-15
     -

   * - :ref:`nvimcmp`
     - 2023-10-15
     -

   * - :ref:`telescope_ref`
     - 2023-10-15
     -

   * - :ref:`vimcommentary`
     - 2023-10-15
     -

   * - :ref:`whichkey`
     - 2023-10-15
     -

   * - :ref:`aerial_ref`
     - 2023-10-15
     -

   * - :ref:`treesitter`
     - 2023-10-15
     -

   * - :ref:`bufferline`
     - 2023-11-01
     -

   * - :ref:`lualine_ref`
     - 2023-11-01
     -

   * - :ref:`mason`
     - 2023-11-01
     -

   * - :ref:`nvimlspconfig`
     - 2023-11-01
     - 2024-03-31

   * - :ref:`trouble`
     - 2023-11-01
     -

   * - :ref:`zenburn`
     - 2023-11-01
     -

   * - :ref:`conform`
     - 2024-03-31
     -

   * - :ref:`flash`
     - 2024-03-31
     -

   * - :ref:`lspprogress`
     - 2024-04-27
     -

   * - :ref:`stickybuf_ref`
     - 2024-04-27
     -

   * - :ref:`obsidian`
     - 2024-07-10
     - 


Sometimes there are better plugins for a particular functionality. I've kept
the documentation, but noted when they've been deprecated here and in the
linked description.

.. list-table::
   :header-rows: 1
   :align: left

   * - plugin
     - date added
     - deprecated

   * - :ref:`leap`
     - 2022-12-27
     - deprecated 2024-03-31 in favor of :ref:`flash`

   * - :ref:`vimrmarkdown`
     - 2019-02-27
     - deprecated 2023-11-14 in favor of treesitter

   * - :ref:`vimpandoc`
     - 2019-02-2
     - deprecated 2023-11-14 in favor of treesitter

   * - :ref:`vimpandocsyntax`
     - 2019-02-27
     - deprecated 2023-11-14 in favor of treesitter

.. _vimcommentary:

``vim-commentary``
~~~~~~~~~~~~~~~~~~

.. versionadded:: 2023-10-15

`vim-commentary <https://github.com/tpope/vim-commentary>`_ lets you easily
toggle comments on lines or blocks of code.

.. list-table::
    :header-rows: 1
    :align: left

    * - command
      - description

    * - :kbd:`gc` on a visual selection
      - toggle comment

    * - :kbd:`gcc` on a single line
      - toggle comment

.. _beacon_ref:

``beacon``
~~~~~~~~~~

.. versionadded:: 2023-10-15

.. versionchanged:: 2023-11-07

   Only commands below will trigger the beacon

`Beacon <https://github.com/danilamihailov/beacon.nvim>`_ provides an animated
marker to show where the cursor is.

.. list-table::
    :header-rows: 1
    :align: left

    * - command
      - description

    * - :kbd:`KJ` (hold shift and tap kj)
      - Flash beacon

    * - :kbd:`n` or :kbd:`N` after search
      - Flash beacon at search hit


.. _telescope_ref:

``telescope``
~~~~~~~~~~~~~

.. versionadded:: 2023-10-15

`Telescope <https://github.com/nvim-telescope/telescope.nvim>`_ opens
a floating window with fuzzy-search selection.

Type in the text box to filter the list. Hit enter to select (and open the
selected file in a new buffer). Hit Esc twice to exit.

.. list-table::
    :header-rows: 1
    :align: left

    * - command
      - description

    * - :kbd:`<leader>ff`
      - Find files under this directory. Handy alternative to ``:e``

    * - :kbd:`<leader>fg`
      - Search directory for string. This is like using ripgrep, but in vim.
        Selecting entry takes you right to the line.

    * - :kbd:`<leader>/`
      - Fuzzy find within buffer

    * - :kbd:`<leader>fc`
      - Find code object

    * - :kbd:`<leader>fo`
      - Find recently-opened files


Other useful things you can do with Telescope:

- ``:Telescope highlights`` to see the currently set highlights for the
  colorscheme.

- ``:Telescope builtin`` to see a picker of all the built-in pickers.
  Selecting one opens that picker. Very meta. But also very interesting for
  poking around to see what's configured.

- ``:Telescope planets`` to use a telescope

- ``:Telescope autocommands``, ``:Telescope commands``, ``:Telescope
  vim_options``, ``:Telescope man_pages`` are some other built-in pickers that
  are interesting to browse through.


.. _nvimtree:

``nvim-tree``
~~~~~~~~~~~~~

.. versionadded:: 2023-10-10

`nvim-tree <https://github.com/nvim-tree/nvim-tree.lua>`_ is a file browser.

.. list-table::
    :header-rows: 1

    * - command
      - description

    * - :kbd:`<leader>fb`
      - Toggle file browser

    * - :kbd:`-` (within browser)
      - Go up a directory

    * - :kbd:`Enter` (within browser)
      - Open file or directory, or close directory

The window-switching shortcuts :kbd:`<leader>w` and :kbd:`<leader>q` (move to
windows left and right respectively) also work

.. _whichkey:

``which-key``
~~~~~~~~~~~~~

.. versionadded:: 2023-10-15

`which-key <https://github.com/folke/which-key.nvim>`_ displays a popup with
possible key bindings of the command you started typing. This is wonderful for
discovering commands you didn't know about, or have forgotten.

The window will appear 1 second after pressing a key (this is configured with
``vim.o.timeoutlen``, e.g. ``vim.o.timeoutlen=500`` for half a sectond). There
is no timeout though for registers (``"``) or marks (``'``) or spelling (``z=``
over a word).

You can hit a displayed key to execute the command, or if it's a multi-key
command (typically indicated with a ``+prefix`` to show there's more), then
that will take you to the next menu.

Use :kbd:`<Backspace>` to back out a menu. In fact, pressing any key, waiting
for the menu, and then hitting backspace will give a list of all the default
mapped keys in vim.

There is currently no extra configuration. Instead, when a key is mapped
(either in :file:`lua/mappings.lua` or :file:`lua/plugins.lua`), an
additional parameter ``desc = "description of mapping"`` is included. This
allows which-key to show a description. Mappings with no descriptions will
still be shown.

.. code-block:: lua

   -- example mapping using vim.keymap.set, with description
   vim.keymap.set('n', '<leader>1', ':bfirst<CR>',
     { desc = "First buffer" })

   -- example mapping when inside a plugin spec
   { "plugin/plugin-name",
     keys = {
       { "<leader>1", ":bfirst<CR>", desc = "First buffer" },
     }
   }

.. list-table::
   :header-rows: 1
   :align: left

   * - command
     - description

   * - any
     - after 1 second, shows a popup menu

   * - :kbd:`<Backspace>`
     - Goes back a menu

   * - :kbd:`z=` (over a word)
     - Show popup with spelling suggestions, use indicated character to select

   * - :kbd:`'`
     - Show popup with list of marks

   * - :kbd:`"`
     - Show popup with list of registers

.. _acceleratedjk:

``accelerated-jk``
~~~~~~~~~~~~~~~~~~

.. versionadded:: 2023-10-15

`accelerated-jk <https://github.com/rhysd/accelerated-jk>`_ speeds up j and
k movements: longer presses will jump more and more lines.

Configured in :file:`lua/plugins.lua`. In particular, you might want to tune
the acceleration curve depending on your system's keyboard repeat rate settings
-- see that file for an explanation of how to tweak.

.. list-table::
    :header-rows: 1
    :align: left

    * - command
      - description

    * - :kbd:`j`, :kbd:`k`
      - Keep holding for increasing vertical scroll speed

.. _nvimcmp:

``nvim-cmp``
~~~~~~~~~~~~

.. versionadded:: 2023-10-15

`nvim-cmp <https://github.com/hrsh7th/nvim-cmp>`_ provides tab-completion.

By default, this would show a tab completion window on every keypress, which to
me is annoying and distracting. So this is configured to only show up when
I hit :kbd:`<Tab>`.

Hit :kbd:`<Tab>` to initiate. Hit :kbd:`<Tab>` until you like what you see.
Then hit Enter. Arrow keys work to select, too.

Snippets are configured as well. If you hit Enter to complete a snippet, you
can then use :kbd:`<Tab>` and :kbd:`<S-Tab>` to move between the placeholders
to fill them in.

.. list-table::
    :header-rows: 1
    :align: left

    * - command
      - description

    * - :kbd:`<Tab>`
      - Tab completion

.. _aerial_ref:

``aerial``
~~~~~~~~~~

.. versionadded:: 2023-10-15

`aerial <https://github.com/stevearc/aerial.nvim>`_ provides a navigation
sidebar for quickly moving around code (for example, jumping to functions or
classes or methods). For markdown or ReStructured Text, it acts like a table of
contents.

.. list-table::
    :header-rows: 1
    :align: left

    * - command
      - description

    * - :kbd:`<leader>a`
      - Toggle aerial sidebar

    * - :kbd:`{` and :kbd:`}`
      - Jump to prev or next item (function, snakemake rule, markdown section)

For navigating complex codebases, there are other keys that are automatically
mapped, which you can read about in the `README for aerial
<https://github.com/stevearc/aerial.nvim>`_.


.. _treesitter:

``treesitter``
~~~~~~~~~~~~~~

.. versionadded:: 2023-10-15

`treesitter <https://github.com/nvim-treesitter/nvim-treesitter>`__ is a parsing
library. You install a parser for a language, and it figures out which tokens
are functions, classes, variables, modules, etc. Then it's up to other plugins
to do something with that. For example, colorschemes can use that information,
or you can select text based on its semantic meaning within the programming
language.

In :file:`~/.config/lua/plugins.lua`, treesitter is configured to ensure the
listed parsers are installed. These will be attempted to be installed
automatically, but they do require a C compiler to be installed.


- On a Mac, this may need XCode Command Line Tools to be installed.
- A fresh Ubuntu installation will need ``sudo apt install build-essential``
- RHEL/Fedora will need ``sudo dnf install 'Development Tools'`` (and may need
  the `EPEL repo <https://docs.fedoraproject.org/en-US/epel/>`__ enabled).
- Alternatively, if you don't have root access, you can install `compiler
  packages via conda
  <https://docs.conda.io/projects/conda-build/en/stable/resources/compiler-tools.html>`_,

Alternatively, comment out the entire ``ensure_installed`` block in
:file:`~/.config/lua/plugins.lua`; this means you will not have
treesitter-enabled syntax highlighting though.


.. list-table::
    :header-rows: 1
    :align: left

    * - command
      - description

    * - :kbd:`<leader>cs`
      - Start incremental selection

    * - :kbd:`<Tab>` (in incremental selection)
      - Increase selection by node

    * - :kbd:`<S-Tab>` (in incremental selection)
      - Decrease selection by node

.. _nvimlspconfig:

``nvim-lspconfig``
~~~~~~~~~~~~~~~~~~

.. versionadded:: 2023-11-01

.. versionchanged:: 2024-03-31

   Changed next diagnostic to :kbd:`]d` rather than :kbd:`]e` for better
   mnemonic (and similar for :kbd:`[d`)



`nvim-lspconfig <https://github.com/neovim/nvim-lspconfig>`_ provides access to
nvim's Language Server Protocol (LSP). You install an LSP server for each
language you want to use it with (see :ref:`mason` for installing these).
Then you enable the LSP server for a buffer, and you get code-aware hints,
warnings, etc.

Not all features are implemented in every LSP server. For example, the Python
LSP is quite feature-rich. In contrast, the R LSP is a bit weak. Install them
with :ref:`mason`.

The Python LSP may be quite verbose if you enable it on existing code, though
in my experience addressing everything it's complaining about will improve your
code. You may find you need to add type annotations in some cases.

Because the experience can be hit-or-miss depending on the language you're
using, LSP is disabled by default. The current exception is for Lua, but you
can configure this behavior in :file:`lua/plugins.lua`. Use :kbd:`<leader>cl`
to start the LSP for a buffer. See :ref:`trouble` for easily viewing all the
diagnostics.

.. note::

   You'll need to install NodeJS

  .. code-block:: bash

     ./setup.sh --install-npm  # install nodejs into conda env



.. list-table::
    :header-rows: 1
    :align: left

    * - command
      - description
    * - :kbd:`<leader>cl`
      - Start the LSP server for this buffer
    * - :kbd:`<leader>ce`
      - Open diagnostic details
    * - :kbd:`[d`
      - Prev diagnostic
    * - :kbd:`]d`
      - Next diagnostic
    * - :kbd:`<leader>cgd`
      - Goto definition (e.g., when cursor is over a function)
    * - :kbd:`<leader>cK`
      - Hover help
    * - :kbd:`<leader>crn`
      - Rename all instances of this symbol
    * - :kbd:`<leader>cr`
      - Goto references
    * - :kbd:`<leader>ca`
      - Code action (opens a menu if implemented)

.. _mason:

``mason.nvim``
~~~~~~~~~~~~~~

.. versionadded:: 2023-11-01

`mason.nvim <https://github.com/williamboman/mason.nvim>`_ easily installs
Language Server Protocols, debuggers, linters, and formatters. Use ``:Mason``
to open the interface, and hit :kbd:`i` on what you want to install, or
:kbd:`g?` for more help.

.. note::

  Many language servers use the npm (javascript package manager) to install.
  This is the case for ``pyright``, for example. You can use ``./setup.sh
  --install-npm`` to easily create a conda env with npm and add its bin dir to
  your ``$PATH``.

For Python, install ``pyright``.

For Lua (working on your nvim configs), use ``lua-language-server``
(nvim-lspconfig calls this ``lua-ls``).

For R, you can try ``r-languageserver``, but this needs to be installed within
the environment you're using R (and R itself must be available). It's not
that useful if you want to use it in multiple conda environments. It doesn't
have that many features yet, either.

.. list-table::
    :header-rows: 1
    :align: left

    * - command
      - description
    * - ``:Mason``
      - Open the mason interface

.. _trouble:

``trouble.nvim``
~~~~~~~~~~~~~~~~

.. versionadded:: 2023-11-01


`trouble.nvim <https://github.com/folke/trouble.nvim>`_ organizes all the LSP
diagnostics into a single window. You can use that to navigate the issues found
in your code.

.. list-table::
    :header-rows: 1
    :align: left

    * - command
      - description
    * - :kbd:`<leader>ct`
      - Toggle trouble.nvim window


.. _gitsigns_ref:

``gitsigns``
~~~~~~~~~~~~

.. versionadded:: 2023-10-15

`gitsigns <https://github.com/lewis6991/gitsigns.nvim>`_ shows a "gutter" along
the left side of the line numbers, indicating where there were changes in
a file. Only works in git repos.

This plugin is in a way redundant with vim-fugitive. Fugitive is more useful
when making commits across multiple files; gitsigns is more useful when making
commits within a file while you're editing it. So they are complementary
plugins rather than competing.

Most commands require being in a hunk. Keymappings start with ``h``, mnemonic
is "hunk" (the term for a block of changes).

.. list-table::
    :header-rows: 1
    :align: left

    * - command
      - description

    * - :kbd:`[c`
      - Previous change

    * - :kbd:`]c`
      - Next change

    * - :kbd:`<leader>hp`
      - Preview hunk (shows floating window of the change, only works in a change)

    * - :kbd:`<leader>hs`
      - Stage hunk (or stage lines in visual mode)

    * - :kbd:`<leader>hr`
      - Reset hunk (or reset lines in visual mode)

    * - :kbd:`<leader>hu`
      - Undo stage hunk

    * - :kbd:`<leader>hS`
      - Stage buffer

    * - :kbd:`<leader>hR`
      - Reset buffer

    * - :kbd:`hb`
      - Blame line in floating window

    * - :kbd:`tb`
      - Toggle blame for line

    * - :kbd:`hd`
      - Diff this file (opens diff mode)

    * - :kbd:`td`
      - Toggle deleted visibility

Additionally, this supports hunks as text objects using ``ih`` (inside hunk).
E.g., select a hunk with :kbd:`vih`, or delete a hunk with :kbd:`dih`.

.. seealso::

   :ref:`vimfugitive`, :ref:`gitsigns_ref`, :ref:`vimgv`,  and :ref:`diffview` are other complementary plugins for working with Git.

.. _toggleterm_ref:

``toggleterm``
~~~~~~~~~~~~~~

.. versionadded:: 2022-12-27

.. versionchanged:: 2024-03-31
   Version of toggleterm is pinned because later versions have issues with
   sending multiple selected lines to the terminal.


`ToggleTerm <https://github.com/akinsho/toggleterm.nvim>`_ lets you easily
interact with a terminal within vim.

The greatest benefit of this is that you can send text from a text buffer
(Python script, RMarkdown file, etc) over to a terminal. This lets you
reproduce an IDE-like environment purely from the terminal. The following
commands are custom mappings set in :file:`.config/nvim/init.vim` that affect
the terminal use.

.. note::

    The terminal will jump to insert mode when you switch to it (either using
    keyboard shortcuts or mouse), but **clicking the mouse a second time will
    enter visual mode**, just like in a text buffer. This can get confusing if
    you're not expecting it.

    You can either click to the text buffer and immediately back in the
    terminal, or use :kbd:`a` or :kbd:`i` in the terminal to get back to insert
    mode.

.. list-table::
    :header-rows: 1
    :align: left

    * - command
      - description

    * - :kbd:`<leader>t`
      - Open terminal to the right.

    * - :kbd:`<leader>w`
      - Move to the right window (assumes it's terminal), and enter insert mode

    * - :kbd:`<leader>q`
      - Move to the text buffer to the left, and enter normal mode

    * - :kbd:`<leader>cd`
      - Send the current RMarkdown code chunk to the terminal, and jump to the
        next chunk

    * - :kbd:`gxx`
      - Send the current *line* to the terminal buffer

    * - :kbd:`gx`
      - Send the current *selection* to the terminal buffer

    * - :kbd:`<leader>k`
      - Render the current RMarkdown file to HTML using `knitr::render()`.
        Assumes you have knitr installed and you're running R in the terminal
        buffer.

    * - :kbd:`<leader>k`
      - Run the current Python script in IPython. Assumes you're running
        IPython in the terminal buffer.


.. _vimfugitive:

``vim-fugitive``
~~~~~~~~~~~~~~~~

.. versionadded:: 2018-09-26

`vim-fugitive <https://github.com/tpope/vim-fugitive>`_ provides a git interface in vim.

This is wonderful for making incremental commits from within vim. This makes it
a terminal-only version of git-cola or an alternative to tig. Specifically:

.. list-table::
    :header-rows: 1
    :align: left

    * - command
      - description

    * - :kbd:`:Git`
      - Opens the main screen for fugitive (hint: use `vim -c ":Git"` from the
        command line to jump right into it)

    * - :kbd:`=`
      - Toggle visibility of changes

    * - :kbd:`-` (when over a filename)
      - Stage or unstage the file

    * - :kbd:`-` (when in a chunk after using ``=``)
      - Stage or unstage the chunk

    * - :kbd:`-` (in visual select mode (``V``))
      - Stage or unstage **just the selected lines**. Perfect for making
        incremental commits.

    * - :kbd:`cc`
      - Commit, opening up a separate buffer in which to write the commit
        message

    * - :kbd:`dd` (when over a file)
      - Open the file in diff mode

The following commands are built-in vim commands when in diff mode, but
are used heavily when working with ``:Gdiff``, so here is a reminder:

.. _working-with-diffs:

Working with diffs
++++++++++++++++++

.. list-table::
    :header-rows: 1
    :align: left

    * - command
      - description

    * - :kbd:`]c`
      - Go to the next diff

    * - :kbd:`[c`
      - Go to the previous diff

    * - :kbd:`do`
      - Use the [o]ther file's contents for the current diff

    * - :kbd:`dp`
      - [P]ut the contents of this diff into the other file

.. seealso::

   :ref:`vimfugitive`, :ref:`gitsigns_ref`, :ref:`vimgv`,  and :ref:`diffview` are other complementary plugins for working with Git.

.. _vimgv:

``vim.gv``
~~~~~~~~~~

.. versionadded:: 2021-02-14

`vim.gv <https://github.com/junegunn/gv.vim>`_ provides an interface to easily
view and browse git history.


.. list-table::
    :header-rows: 1
    :align: left

    * - command
      - description

    * - :kbd:`:GV` in visual mode
      - View commits affecting selection

    * - :kbd:`GV`
      - Open a commit browser, hit :kbd:`Enter` on a commit to view

.. seealso::

   :ref:`vimfugitive`, :ref:`gitsigns_ref`, :ref:`vimgv`,  and :ref:`diffview` are other complementary plugins for working with Git.


.. _vimmergetool:

``vim-mergetool``
~~~~~~~~~~~~~~~~~

.. versionadded:: 2021-02-14

`vim-mergetool <https://github.com/samoshkin/vim-mergetool>`_ makes 3-way merge
conflicts much easier to deal with by only focusing on what needs to be
manually edited.

Makes it MUCH easier to work with 3-way diffs, while at the same time allowing
enough flexibility in configuration to be able to reproduce default behaviors.

.. note::

    You'll need to set the following in your .gitconfig::

        [merge]
        conflictStyle = diff3

.. list-table::
    :header-rows: 1
    :align: left

    * - command
      - description

    * - :kbd:`:MergetoolStart`
      - Starts the tool

    * - :kbd:`:diffget`
      - Pulls "theirs" (that is, assume the remote is correct)

    * - :kbd:`do`, :kbd:`dp`
      - Used as in vim diff mode

Save and quit, or use :kbd:`:MergetoolStop`.

.. _vimdiffenhanced:

``vim-diff-enhanced``
~~~~~~~~~~~~~~~~~~~~~

.. versionadded:: 2019-02-27

`vim-diff-enhanced <https://github.com/chrisbra/vim-diff-enhanced>`_ provides
additional diff algorithms that work better on certain kinds of files. If your
diffs are not looking right, try changing the algorithm with this plugin:

.. list-table::
    :header-rows: 1
    :align: left

    * - command
      - description

    * - :kbd:`:EnhancedDiff <algorithm>`
      - Configure the diff algorithm to use, see below table


The following algorithms are available:

.. list-table::
    :header-rows: 1
    :align: left

    * - algorithm
      - description

    * - myers
      - Default diff algorithm

    * - default
      - alias for `myers`

    * - minimal
      - Like myers, but tries harder to minimize the resulting diff

    * - patience
      - Patience diff algorithm

    * - histogram
      - Histogram is similar to patience but slightly faster

.. _vimtablemode:

``vim-table-mode``
~~~~~~~~~~~~~~~~~~

.. versionadded:: 2019-03-27

`vim-table-mode <https://github.com/dhruvasagar/vim-table-mode>`_ provides
easy formatting of tables in Markdown and Restructured Text

Nice Markdown tables are a pain to format. This plugin makes it easy, by
auto-padding table cells and adding the header lines as needed.

* With table mode enabled, :kbd:`||` on a new line to start the header.
* Type the header, separated by :kbd:`|`.
* On a new line, use :kbd:`||` to fill in the header underline.
* On subsequent rows, delimit fields by :kbd:`|`.
* Complete the table with :kbd:`||` on a new line.

.. list-table::
    :header-rows: 1
    :align: left

    * - command
      - description

    * - :kbd:`:TableModeEnable`
      - Enables table mode, which makes on-the-fly adjustments to table cells
        as they're edited

    * - :kbd:`:TableModeDisable`
      - Disables table mode

    * - :kbd:`:Tableize`
      - Creates a markdown or restructured text table based on TSV or CSV text

    * - :kbd:`TableModeRealign`
      - Realigns an existing table, adding padding as necessary

See the homepage for, e.g., using ``||`` to auto-create header lines.

.. _leap:

``leap.nvim``
~~~~~~~~~~~~~

.. versionadded:: 2022-12-27
.. deprecated:: 2024-03-31
   Removed in favor of the :ref:`flash` plugin, which behaves similarly but
   also supports treesitter selections


.. _flash:

``flash``
~~~~~~~~~

.. versionadded:: 2024-03-31

`flash <https://github.com/folke/flash.nvim>`__ lets you jump around in a buffer with low mental effort.

.. list-table::
    :header-rows: 1
    :align: left

    * - command
      - description

    * - :kbd:`Ctrl-s` when searching
      - Toggle flash during search

    * - :kbd:`s` in normal mode
      - jump to match (see details)

    * - :kbd:`S` in normal mode
      - select this treesitter node (see details)

When searching with :kbd:`/` or :kbd:`?`, **an additional suffix letter will be
shown after each match**. Typing this additional letter lets you jump right to
that instance.

Or just hit :kbd:`Enter` like normal to do a typical search.

Either way, :kbd:`n` and :kbd:`N` for next/prev hit work as normal.

With :kbd:`s`, this changes the syntax highlighting to hide everything but the
search hit and the suffix.

With :kbd:`S`, if a treesitter parser is installed for this filetype, suffix
letters will be shown at different levels of the syntax tree.

For example, :kbd:`S` within an R for-loop within an RMarkdown chunk will show
suffixes to type that will select the inner body of the for-loop, the entire
for-loop, or the entire body of the chunk. If you wanted to select the
backticks as well, you could use :kbd:`S` when on the backticks.


.. _vimsurround:

``vim-surround``
~~~~~~~~~~~~~~~~

.. versionadded:: 2022-12-27

`vim-surround <https://github.com/tpope/vim-surround>`_ lets you easily change
surrounding characters.

.. list-table::
    :header-rows: 1
    :align: left

    * - command
      - description

    * - :kbd:`cs"'`
      - change surrounding ``"`` to ``'``

    * - :kbd:`csw}`
      - add ``{`` and ``}`` surrounding word

    * - :kbd:`csw{`
      - same, but include a space

.. _vis_ref:

``vis``
~~~~~~~

.. versionadded:: 2019-09-30

`vis <https://github.com/vim-scripts/vis>`_ provides better behavior on visual
blocks.

By default in vim and neovim, when selecting things in visual
block mode, operations (substitutions, sorting) operate on the entire line --
not just the block, as you might expect. However sometimes you want to edit
just the visual block selection, for example when editing TSV files.

.. list-table::
    :header-rows: 1
    :align: left

    * - command
      - description
    * - :kbd:`<C-v>`, then use :kbd:`:B` instead of :kbd:`:`
      - Operates on visual block selection only

.. _bufferline:

``bufferline.nvim``
~~~~~~~~~~~~~~~~~~~

.. versionadded:: 2023-11-01

`bufferline.nvim <https://github.com/akinsho/bufferline.nvim>`_ provides the
tabs along the top.


.. list-table::
    :header-rows: 1
    :align: left

    * - command
      - description
    * - :kbd:`<leader>b`, then type highlighted letter in tab
      - Switch to buffer

.. _diffview:

``diffview.nvim``
~~~~~~~~~~~~~~~~~

.. versionadded:: 2023-10-11

`diffview.nvim <https://github.com/sindrets/diffview.nvim>`_ supports viewing
diffs across multiple files. It also has a nice interface for browsing previous
commits.

I'm still figuring out when it's better to use this, fugitive, or gitsigns.

.. seealso::

   :ref:`vimfugitive`, :ref:`gitsigns_ref`, :ref:`vimgv`,  and :ref:`diffview` are other complementary plugins for working with Git.

See the homepage for details.

.. list-table::

    * - command
      - description

    * - ``:DiffviewOpen``
      - Opens the viewer

    * - ``:DiffviewFileHistory``
      - View diffs for this file throughout git history

.. _conform:

``conform``
~~~~~~~~~~~

.. versionadded:: 2024-03-31

`conform <https://github.com/stevearc/conform.nvim>`__ runs style formatters on
the current buffer.

For example, if ``black`` is avaiable it will run that on the code, but in
a way that the changes can be undone (in contrast to running ``black``
manually on the file, which overwrites it).

.. list-table::

    * - command
      - description

    * - :kbd:`<leader>cf`
      - Run configured formatter on buffer (mnemonic: [c]ode [f]ormat)

You can install formatters via :ref:`mason`; search
:file:`.config/nvim/lua/plugins.lua` for ``conform.nvim`` to see the
configuration.

For example, for Python I have ``isort`` and ``black``; for Lua, ``stylua``; for
bash, ``shfmt``.

.. _lualine_ref:


``lualine``
~~~~~~~~~~~

.. versionadded:: 2023-11-01

`lualine <https://github.com/nvim-lualine/lualine.nvim>`_ provides the status line along the bottom.

No additional commands configured.

.. _indentblankline:

``indent-blankline``
~~~~~~~~~~~~~~~~~~~~

.. versionadded:: 2023-10-15

`indent-blankline <https://github.com/lukas-reineke/indent-blankline.nvim>`_
shows vertical lines where there is indentation, and highlights one of these
vertical lines to indicate the current `scope
<https://en.wikipedia.org/wiki/Scope_(computer_science)>`_.

No additional commands configured.

.. _vimpythonpep8indent:

``vim-python-pep8-indent``
~~~~~~~~~~~~~~~~~~~~~~~~~~

.. versionadded:: 2017

`vim-python-pep8-indent <https://github.com/Vimjas/vim-python-pep8-indent>`_
auto-indents Python using pep8 recommendations. This happens as you’re typing,
or when you use :kbd:`gq` on a selection to wrap.

No additional commands configured.

.. _vimrmarkdown:

``vim-rmarkdown``
~~~~~~~~~~~~~~~~~

.. versionadded:: 2019-02-27

.. deprecated:: 2023-11-14
  Removed in favor of treesitter

.. details:: Deprecation notes

  `vim-rmarkdown <https://github.com/vim-pandoc/vim-rmarkdown>`_ provides syntax
  highlighting for R within RMarkdown code chunks. Requires both ``vim-pandoc``
  and ``vim-pandoc-syntax``, described below.

  No additional commands configured.

.. _vimpandoc:

``vim-pandoc``
~~~~~~~~~~~~~~

.. versionadded:: 2019-02-27

.. deprecated:: 2023-11-14
   Removed in favor of treesitter

.. details:: Deprecation notes

  `vim-pandoc <https://github.com/vim-pandoc/vim-pandoc>`_ Integration with
  `pandoc <http://johnmacfarlane.net/pandoc/>`_. Uses vim-pandoc-syntax (see
  below) for syntax highlighting.

  Includes folding and formatting. Lots of shortcuts are defined by this plugin,
  see ``:help vim-pandoc`` for much more.

  No additional commands configured.

.. _vimpandocsyntax:

``vim-pandoc-syntax``
~~~~~~~~~~~~~~~~~~~~~

.. versionadded:: 2019-02-27

.. deprecated:: 2023-11-14
  Removed in favor of treesitter

.. details:: Deprecation notes

  `vim-pandoc-syntax <https://github.com/vim-pandoc/vim-pandoc-syntax>`_ is used
  by vim-pandoc (above). It is a separate plugin because the authors found it
  easier to track bugs separately.

  No additional commands configured.

.. _vimtmuxclipboard:

``vim-tmux-clipboard``
~~~~~~~~~~~~~~~~~~~~~~

.. versionadded:: 2016

`vim-tmux-clipboard <https://github.com/roxma/vim-tmux-clipboard>`_
automatically copies yanked text from vim into the tmux clipboard. Similarly,
anything copied in tmux makes it into the vim clipboard.

See this `screencast <https://asciinema.org/a/7qzb7c12ykv3kcleo4jgrl2jy>`_ for
usage details. Note that this also requires the `vim-tmux-focus-events
<https://github.com/tmux-plugins/vim-tmux-focus-events>`_ plugin. You'll need
to make sure ``set -g focus-events on`` is in your :file:`.tmux.conf`.

No additional commands configured.


.. _zenburn:

``zenburn.nvim``
~~~~~~~~~~~~~~~~

.. versionadded:: 2023-11-01

This uses my fork of https://github.com/phha/zenburn.nvim, which adds addtional
support for plugins and tweaks some of the existing colors to work better.

No additional commands configured.

.. _stickybuf_ref:

``stickybuf.nvim``
~~~~~~~~~~~~~~~~~~

.. versionadded:: 2024-04-27

`stickybuf.nvim <https://github.com/stevearc/stickybuf.nvim>`__ prevents text
buffers from opening up inside a terminal buffer.

No additional commands configured.

.. _lspprogress:

``lsp-progress.nvim``
~~~~~~~~~~~~~~~~~~~~~

.. versionadded:: 2024-04-27

`lsp-progress.nvim <https://github.com/linrongbin16/lsp-progress.nvim>`__ adds
a status/progress indicator to the lualine (at the bottom of a window) so you
know when it's running.

No additional commands configured.

.. _obsidian:

``obsidian.nvim``
~~~~~~~~~~~~~~~~~

.. versionadded:: 2024-07-10

`obsidian.nvim <https://github.com/epwalsh/obsidian.nvim>`__ is a plugin
originally written for working with `Obsidian <https://obsidian.md/>`__ which is a GUI
notetaking app (that uses markdown and has vim keybindings). If you're an
Obsidian user, this plugin makes the experience with nvim quite nice.

The mapped commands below use :kbd:`o` ([o]bsidian)

.. list-table::

    * - command
      - description

    * - :kbd:`<leader>od`
      - Choose or create a daily note

    * - :kbd:`<leader>os`
      - [o]bsidian [s]search

    * - :kbd:`<leader>ot`
      - [o]bsidian [t]ags

    * - :kbd:`<leader>on`
      - [o]bsidian [n]ew link

Colorschemes
------------

For years I've been using the venerable *zenburn* colorscheme. However, now
with additional plugins and highlighting mechansims (especially treesitter), it
became important to be able to configure more than what that colorscheme supported.

The `zenburn.nvim <https://github.com/phha/zenburn.nvim>`_ repo was a reboot of
this colorscheme, but there were some parts of it that I wanted to change, or
at least have more control over. Hence `my fork of the repo
<https://github.com/daler/zenburn.nvim>`_, which is used here. If you're
interested in tweaking your own colorschemes, I've hopefully documented that
fork enough to give you an idea of how to modify on your own.
