.. _vim:

Neovim
======

The :file:`.vimrc` file has only basic setup for vim.

The files :file:`.config/nvim/init.lua` is the entry point of the nvim config.

See :ref:`nvim-lua` and :ref:`Why Lua <why-lua>` if you're coming here from using older
versions of these dotfiles.

.. note::

   Unless otherwise specified, paths on this page are relative to
   :file:`~/.config/nvim`.

Structure
---------

Here is a schematic of the nvim config files in :file:`~/.config/nvim`:

- :file:`init.lua`: entry point, and imports files from :file:`lua/` subdirectory
- :file:`lua/settings.lua`: general vim settings
- :file:`lua/lazy-bootstrap.lua`: automatically installs and makes available
  the lazy.nvim plugin manager (no need for ``./setup.sh
  --set-up-vim-plugins``)
- :file:`lua/plugins/init.lua`: loaded by lazy.nvim, contains plugins that don't need additional config
- :file:`lua/plugins/*.lua`: one file per plugin, containing that plugin's config.
- :file:`lua/mappings.lua`: custom keymappings
- :file:`lua/autocommands.lua`: custom autocommands
- :file:`lua/colorscheme.lua`: set and/or modify colorscheme


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

The vim config has these lines:

.. code-block:: vim

    :autocmd InsertEnter * set listchars=tab:>•
    :autocmd InsertLeave * set listchars=tab:>•,trail:∙,nbsp:•,extends:⟩,precedes:⟨

With these settings <TAB> characters look like ``>••••``. Trailing spaces show up
as dots like ``∙∙∙∙∙``.

The autocmds here mean that we only show the trailing spaces when we're outside
of insert mode, so that every space typed doesn't show up as trailing. When
wrap is off, the characters for "extends" and "precedes" indicate that there's
text offscreen.

Switching buffers
-----------------

Two main ways of opening a file in a new buffer:

.. list-table::
   :header-rows: 1
   :align: left

   * - command
     - description

   * - :kbd:`:e` <filename>
     - Open filename in new buffer

   * - :kbd:`<leader>ff`
     - Search for file in directory to open in new buffer (Telescope)

Once you have multiple buffers, you can switch between them in these ways:

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

   * - :kbd:`,b`
     - tab-complete buffer name (or number), then hit enter

The bufferline is configured to show the basename of the file and the buffer
number.

Using Telescope and some of the other new plugins will open hidden buffers that
increment the buffer number. This means that sometimes, opening a new buffer
will give an unexpectedly high buffer number (instead of buffer 1 and buffer 2,
you might get buffer 1 and buffer 19, for example). I'm currently keeping the
buffer numbers because they are sometimes easier to use with :kbd:`<leader>b`
than filenames.

The display of the bufferline is configured in :file:`lua/plugins/vim-airline.lua`.

Format options explanation
--------------------------

The following options change the behavior of various formatting; see ``:h formatoptions``:

.. code-block:: vim

    set formatoptions=qrn1coj

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

Here are some general shortcuts that are defined in the included config. With
the ``which-key`` plugin, many of these are also discoverable by hitting the
first key and then waiting a second for the menu to pop up.

These are defined in :file:`lua/mappings.lua`. 

**Mappings that use a plugin** are configured in the respective plugin's
:file:`lua/plugins/*.lua` file, so check below for more mappings.


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
      - Useful for working with TSVs. Writes ``:set nowrap tabstop=`` and then
        leaves the cursor at the vim command bar so you can fill in a reasonble
        tabstop for the file you're looking at.

    * - :kbd:`<leader>\``
      - (that's a backtick) Adds a new RMarkdown chunk and places the cursor
        inside it

    * - :kbd:`<leader>ry`
      - Used for RMarkdown; writes commonly-used YAML front matter (mnemonic:
        rmarkdown yaml)

    * - :kbd:`<leader>ko`
      - Used for RMarkdown; writes an RMarkdown chunk with commonly-used knitr
        global options (mnemonic: knitr options)

This is configured in :file:`lua/autocommands.lua`:

.. list-table::
    :header-rows: 1
    :align: left

    * - command
      - description

    * - :kbd:`<leader>d`
      - Insert the current date as a ReST or Markdown-formatted title,
        depending on the file type. Useful when writing logs.



Plugins
-------

The plugins configured at the top of :file:`.config/nvim/init.vim` have lots
and lots of options. Here I’m only highlighting the options I use the most, but
definitely check out each homepage to see all the other weird and wonderful
ways they can be used.

Here, plugins are sorted roughly so that the ones that provide additional
commands come first.

.. note:: note


    Don't like a plugin? Find where it's being loaded, either in
    :file:`lua/plugins/init.lua` (for plugins without config) or
    :file:`lua/plugins/*.lua` (for plugins with config). Add ``enabled
    = false`` next to where the plugin is named. For example:

    .. code-block:: lua

      -- ... other stuff
      { "user/plugin-name", enabled = false },
      -- ... more stuff


.. contents::
    :local:

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

``beacon``
~~~~~~~~~~

.. versionadded:: 2023-10-15

`Beacon <https://github.com/danilamihailov/beacon.nvim>`_ provides an animated
marker to show where the cursor is.

Configured in :file:`lua/plugins/beacon.lua`.

.. list-table::
    :header-rows: 1
    :align: left

    * - command
      - description

    * - :kbd:`KJ` (hold shift and tap kj)
      - Flash beacon

In addition, moving between search hits with :kbd:`N` and :kbd:`n` will flash
the beacon.

``telescope``
~~~~~~~~~~~~~

.. versionadded:: 2023-10-15

`Telescope <https://github.com/nvim-telescope/telescope.nvim>`_ opens
a floating window with fuzzy-search selection.

Type in the text box to filter the list. Hit enter to select (and open the
selected file in a new buffer).

Configured in :file:`lua/plugins/telescope.lua`.

.. list-table::
    :header-rows: 1
    :align: left

    * - command
      - description

    * - :kbd:`<leader>ff`
      - Find files under this directory. Handy alternative to ``:e``

    * - :kbd:`<leader>fg`
      - Search directory for string. This is like using ripgrep in vim.
        Selecting entry takes you right to the line.

    * - :kbd:`<leader>/`
      - Fuzzy find within buffer

    * - :kbd:`<leader>fc`
      - Find code object

    * - :kbd:`<leader>fo`
      - Find recently-opened files


Other useful things you can do with Telescope:

- ``:Telescope highlights`` to see the currently set highlights for the
  colorscheme. You can use that information to modify
  :file:`lua/plugins/zenburn.lua`.

- ``:Telescope builtin`` to see a picker of all the built-in pickers.
  Selecting one opens that picker. Very meta. But also very interesting for
  poking around to see what's configured. 

- ``:Telescope planets`` to use a telescope

- ``:Telescope autocommands``, ``:Telescope commands``, ``:Telescope
  vim_options``, ``:Telescope man_pages`` are some other built-in pickers that
  are interesting to browse through.

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
command (typically indicated with a ``+prefix`` to show there's more), then that will take you to the next menu.

Use :kbd:`<Backspace>` to back out a menu. In fact, pressing any key, waiting
for the menu, and then hitting backspace will give a list of all the default
mapped keys in vim.

There is currently no extra configuration. Instead, when a key is mapped
(either in :file:`lua/mappings.lua` or :file:`lua/plugins/*.lua`), an
additional parameter ``{ desc = "description of mapping" }`` is included. This
allows which-key to show a description. Mappings with no descriptions will
still be shown.

.. code-block:: lua

   -- example mapping, with description
   vim.keymap.set('n', '<leader>1', ':bfirst<CR>',
     { desc = "First buffer" })


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


``accelerated-jk``
~~~~~~~~~~~~~~~~~~

.. versionadded:: 2023-10-15

`accelerated-jk <https://github.com/rhysd/accelerated-jk>`_ speeds up j and
k movements: longer presses will jump more and more lines.

Configured in :file:`lua/plugins/accelerated-jk`. In particular, you might want
to tune the acceleration curve depending on your system's keyboard repeat rate
settings -- see that file for an explanation of how to tweak.

.. list-table::
    :header-rows: 1
    :align: left

    * - command
      - description

    * - :kbd:`j`, :kbd:`k`
      - Keep holding for increasing vertical scroll speed

``nvim-cmp``
~~~~~~~~~~~~

.. versionadded:: 2023-10-15

`nvim-cmp <https://github.com/hrsh7th/nvim-cmp>`_ provides tab-completion.

By default, this would show a tab completion window on every keypress, which to
me is annoying and distracting. So this is configured to only show up when
I hit :kbd:`<Tab>`.

Hit :kbd:`<Tab>` to initiate. Hit :kbd:`<Tab>` until you like what you see.
Then keep typing -- no need to hit Enter. Arrow keys work to select, too.

If you have enabled spell checking (``set spell``) then tab-completion will
also show spelling suggestions from the dictionary. Otherwise, it will only use
options from words already in the buffer.

.. list-table::
    :header-rows: 1
    :align: left

    * - command
      - description

    * - :kbd:`<Tab>`
      - Tab completion

``aerial``
~~~~~~~~~~

.. versionadded:: 2023-10-15

`aerial <https://github.com/stevearc/aerial.nvim>`_ provides a navigation
sidebar for quickly moving around code (for example, jumping to functions or
classes or methods).

Configured in :file:`lua/plugins/aerial.lua`.

.. list-table::
    :header-rows: 1
    :align: left

    * - command
      - description
  
    * - :kbd:`<leader>a`
      - Toggle aerial sidebar

    * - :kbd:`{` and :kbd:`}`
      - Jump to prev or next item

For navigating complex codebases, there are other keys that are automatically
mapped, which you can read about in the `README for aerial
<https://github.com/stevearc/aerial.nvim>`_.

``treesitter``
~~~~~~~~~~~~~~

.. versionadded:: 2023-10-15

`treesitter <https://github.com/nvim-treesitter/nvim-treesitter>`_ is a parsing
library. You install a parser for a language, and it figures out which tokens
are functions, classes, variables, modules, etc. Then it's up to other plugins
to do something with that. For example, colorschemes can use that information,
or you can select text based on its semantic meaning within the programming
language.

Configured in :file:`lua/plugins/treesitter.lua`.


.. list-table::
    :header-rows: 1
    :align: left

    * - command
      - description

    * - :kbd:`gnn`
      - Start incremental selection

    * - :kbd:`<Tab>` (in incremental selection)
      - Increase selection by node

    * - :kbd:`<Backspace>` (in incremental selection)
      - Decrease selection by node

``indent-blankline``
~~~~~~~~~~~~~~~~~~~~

.. versionadded:: 2023-10-15

`indent-blankline <https://github.com/lukas-reineke/indent-blankline.nvim>`_
shows vertical lines where there is indentation, and highlights one of these
vertical lines to indicate the current `scope
<https://en.wikipedia.org/wiki/Scope_(computer_science)>`_.

Configured in :file:`lua/plugins/indent-blankline.lua`.

``color-picker``
~~~~~~~~~~~~~~~~

.. versionadded:: 2023-10-15

`color-picker <https://github.com/ziontee113/color-picker.nvim>`_ opens a mini
color picker in nvim, optionally replacing the edited color.

Configured in :file:`lua/plugins/color-picker.lua`

.. list-table::
    :header-rows: 1
    :align: left

    * - command
      - description

    * - :kbd:`<leader>cp`
      - Start color picker over color

    * - :kbd:`j`, :kbd:`k`
      - Choose slider

    * - :kbd:`h`, :kbd:`l`
      - Move slider by 1

    * - :kbd:`U`, :kbd:`O`
      - Move slider by 5


``toggleterm``
~~~~~~~~~~~~~~

.. versionadded:: 2022-12-27

`ToggleTerm <https://github.com/akinsho/toggleterm.nvim>`_ lets you easily
interact with a terminal within vim.

The greatest benefit of this is that you can send text from a text buffer
(Python script, RMarkdown file, etc) over to a terminal. This lets you
reproduce an IDE-like environment purely from the terminal. The following
commands are custom mappings set in :file:`.config/nvim/init.vim` that affect
the terminal use.

Configured in :file:`lua/plugins/toggleterm.lua`.

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

Configured in :file:`lua/plugins/gitsigns.lua`

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

.. _vim-gv:

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


``vim-table-mode``
~~~~~~~~~~~~~~~~~~

.. versionadded:: 2019-03-27

`vim-table-mode <https://github.com/vim-pandoc/vim-pandoc-syntax>`_ provides
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
      - Enables table mode, which makes on-the-fly adjustements to table cells
        as they're edited

    * - :kbd:`:TableModeDisable`
      - Disables table mode

    * - :kbd:`:Tableize`
      - Creates a markdown or restructured text table based on TSV or CSV text

    * - :kbd:`TableModeRealign`
      - Realigns an existing table, adding padding as necessary

See the homepage for, e.g., using ``||`` to auto-create header lines.


``leap.nvim``
~~~~~~~~~~~~~

.. versionadded:: 2022-12-27

`leap <https://github.com/ggandor/leap.nvim>`_ lets you jump around in a buffer
with low mental effort.

.. list-table::
    :header-rows: 1
    :align: left

    * - command
      - description

    * - :kbd:`s` in normal mode
      - jump below (see details)

    * - :kbd:`S` in normal mode
      - jump above (see details)

After hitting :kbd:`s` or :kbd:`S`, type two of the characters you want to leap
to. You will see highlighted letters pop up at all the possible destinations.
These label possible jump points. Hit the letter corresponding to the jump
point to go right there.

This works best when keeping your eyes on the place you want to jump to.

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


``vis``
~~~~~~~

.. versionadded:: 2019-09-30

`vis <https://github.com/vim-scripts/vis>`_ provides better behavior on visual
blocks.

Did you know that by default in vim and neovim, when selecting things in visual
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

``nerdtree``
~~~~~~~~~~~~

.. versionadded:: 2016

`nerdtree <https://github.com/scrooloose/nerdtree>`_ provides a file browser
for finding/selecting files to edit. Navigate it with vim movement keys, and
hit ``Enter`` to open the file in a new buffer.

.. list-table::
    :header-rows: 1
    :align: left

    * - command
      - description
    * - :kbd:`<leader>n`
      - toggle file browser

``vim-python-pep8-indent``
~~~~~~~~~~~~~~~~~~~~~~~~~~

.. versionadded:: 2017

`vim-python-pep8-indent <https://github.com/Vimjas/vim-python-pep8-indent>`_
auto-indents Python using pep8 recommendations. This happens as you’re typing,
or when you use :kbd:`gq` on a selection to wrap. No additional commands
configured.

``vim-rmarkdown``
~~~~~~~~~~~~~~~~~

.. versionadded:: 2019-02-27

`vim-rmarkdown <https://github.com/vim-pandoc/vim-rmarkdown>`_ provides syntax
highlighting for R within RMarkdown code chunks. Requires both ``vim-pandoc``
and ``vim-pandoc-syntax``, described below.

No additional commands configured.

``vim-pandoc``
~~~~~~~~~~~~~~

.. versionadded:: 2019-02-27

`vim-pandoc <https://github.com/vim-pandoc/vim-pandoc>`_ Integration with
`pandoc <http://johnmacfarlane.net/pandoc/>`_. Uses vim-pandoc-syntax (see
below) for syntax highlighting.

Includes folding and formatting. Lots of shortcuts are defined by this plugin,
see ``:help vim-pandoc`` for much more.

``vim-pandoc-syntax``
~~~~~~~~~~~~~~~~~~~~~

.. versionadded:: 2019-02-27

`vim-pandoc-syntax <https://github.com/vim-pandoc/vim-pandoc-syntax>`_ is used
by vim-pandoc (above). It is a separate plugin because the authors found it
easier to track bugs separately.

No additional commands configured.


``vim-airline``
~~~~~~~~~~~~~~~

.. versionadded:: 2016

`vim-airline <https://github.com/vim-airline/vim-airline>`_ provides a nice
statusline, plus "tabs" that allow you to easily switch between open files and
copy/paste between them.

Install powerline fonts for full effect (``./setup.sh --powerline``). See below
for themes.

``vim-airline-themes``
~~~~~~~~~~~~~~~~~~~~~~

.. versionadded:: 2016

`vim-airline-themes
<https://github.com/vim-airline/vim-airline/wiki/Screenshots>`_ provides themes
for use with vim-airline.


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

Working with R in nvim
----------------------

This assumes that you’re using neovim and have installed the neoterm
plugin.

Initial setup
~~~~~~~~~~~~~

When first starting work on a file:

1. Open or create a new RMarkdown file with nvim
2. Open a neoterm terminal to the right (``,t``)
3. Move to that terminal (``Alt-w``).
4. In the terminal, source activate your environment
5. Start R in the terminal
6. Go back to the RMarkdown or R script, and use the commands below to
   send lines over.

Working with R
~~~~~~~~~~~~~~

Once you have the terminal up and running, write some R code in the text file
buffer. To test, you can send lines over using any of the following methods:

1. ``gxx`` to send the current line to R

2. Highlight some lines (``Shift-V`` in vim gets you to visual select
   mode), ``gx`` sends them and then jumps to the terminal.

3. Inside a code chunk, ``,cd`` sends the entire code chunk and then

4  jumps to the next one. This way you can ``,cd`` your way through an
   Rmd

5. ``,k`` to render the current Rmd to HTML.
