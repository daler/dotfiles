.. _vim:

Vim / Neovim
============

:file:`.vimrc` and :file:`.config/nvim/init.vim` have the same contents.

In the :file:`.config/nvim/init.vim` file in this
repo:

-  ``<Leader>`` is set to ``,``
-  ``<Localleader>`` is set to ``/``


.. note:: 

    **Setting up powerline fonts:** After running ``./setup.sh --powerline``,
    which will install the fonts, you need to tell the terminal to use those
    fonts. Go to Preferences for the terminal app, select the “Custom Font”
    checkbox, and choose a font that ends with “Powerline”.

General features
----------------

Here are the features (and fixes) you get when using this config file.
Note that the file itself is pretty heavily commented so you can
pick-and-choose at will.

-  Lots of nice plugins (see below)
-  Syntax highlighting and proper Python formatting
-  In some situations backspace does not work, this fixes it
-  Use mouse to click around
-  Current line has a subtle coloring when in insert mode
-  Hitting the TAB key enters spaces, not a literal tab character.
   Important for writing Python!
-  TAB characters are rendered as ``>...`` which helps troubleshoot
   spaces vs tabs. This is disabled for files like HTML and XML where
   tabs vs whitespace is not important
-  Set the tabstop to 2 for YAML format files
-  Trailing spaces are rendered as faded dots
-  Comments, numbered lists can be auto-wrapped after selecting and
   using ``gq``
-  In insert mode while editing a comment, hitting enter will
   automatically add the comment character to the beginning of the next
   line
-  Searches will be case-sensitive only if at least letter is a capital
-  Plugins for working more easily within tmux

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


Shortcuts
---------

Here are some general shortcuts that are defined in the included config:

.. list-table::

    * - command
      - mode
      - description
    * - :kbd:`,`
      -
      - Remapped leader. Below, when you see :kbd:`<leader>` it means :kbd:`,`.
    * - :kbd:`<leader>r`
      - normal
      - Toggle relative line numbering (makes it easier to jump around lines
        with motion operators).
    * - :kbd:`<leader>H`
      - normal
      - Toggle highlighted search. Sometimes it's distracting to have all the
        highlights stick around.
    * - :kbd:`<leader>W`
      - normal
      - Remove all trailing spaces in the file. Useful when cleaning up code to
        commit.
    * - :kbd:`<leader>R`
      - normal or insert
      - Refresh syntax highlighting. Useful when syntax highlighting gets wonky.
    * - :kbd:`@l`
      - normal
      - Macro to surround the line with quotes and add a trailing comma. Useful
        for making Python or R lists out of pasted text
    * - :kbd:`<leader>d`
      - normal or insert
      - Insert the current date as a ReST-formatted title. Useful when writing
        logs.
    * - :kbd:`<leader>-`
      - normal
      - Fills in the rest of the line with "-", out to column 80. Useful for
        making section separators.
    * - :kbd:`<leader>md`
      - normal
      - Sets hard-wrap to 80, useful for writing markdown.
    * - :kbd:`<leader>nd`
      - normal
      - Opposite of :kbd:`,md`
    * - :kbd:`<leader><TAB>`
      - normal
      - Useful for working with TSVs. Writes ``:set nowrap tabstop=`` and then
        leaves the cursor at the vim command bar so you can fill in a reasonble
        tabstop for the file you're looking at.
    * - :kbd:`<leader>ko`
      - normal
      - Used for RMarkdown; writes an RMarkdown chunk with commonly-used knitr
        global options (mnemonic: knitr options)
    * - :kbd:`<leader>ry`
      - normal
      - Used for RMarkdown; writes commonly-used YAML front matter (mnemonic: rmarkdown yaml)
    * - :kbd:`<leader>\``
      - insert or normal
      - (that's a backtick) Adds a new RMarkdown chunk and places the cursor inside it

Plugins
-------

The plugins configured at the top of :file:`.config/nvim/init.vim` have lots
and lots of options. Here I’m only highlighting the options I use the most, but
definitely check out each homepage to see all the other weird and wonderful
ways they can be used.

Here, plugins are sorted roughly so that the ones that provide additional
commands come first.

.. contents::
    :local:

``toggleterm``
~~~~~~~~~~~~~~
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

    * - command
      - mode
      - description
    * - :kbd:`<leader>t`
      - normal
      - Open terminal to the right.
    * - :kbd:`<leader>w`
      - normal
      - Move to the right window (assumes it's terminal), and enter insert mode
    * - :kbd:`<leader>q`
      - normal or insert
      - Move to the text buffer to the left, and enter normal mode
    * - :kbd:`<leader>cd`
      - normal
      - Send the current RMarkdown code chunk to the terminal, and jump to the next chunk
    * - :kbd:`gxx`
      - normal
      - Send the current *line* to the terminal buffer
    * - :kbd:`gx`
      - visual
      - Send the current *selection* to the terminal buffer
    * - :kbd:`<leader>k`
      - normal
      - Render the current RMarkdown file to HTML using `knitr::render()`.
        Assumes you have knitr installed and you're running R in the terminal
        buffer.
    * - :kbd:`<leader>k`
      - normal
      - Run the current Python script in IPython. Assumes you're running IPython
        in the terminal buffer.


.. _vimfugitive:

``vim-fugitive``
~~~~~~~~~~~~~~~~
`vim-fugitive <https://github.com/tpope/vim-fugitive>`_ provides a git interface in vim.

This is wonderful for making incremental commits from within vim. This makes it
a terminal-only version of git-cola or an alternative to tig. Specifically:

.. list-table::

    * - command
      - description
    * - :kbd:`:Git`
      - Opens the main screen for fugitive (hint: use `vim -c ":Git"` from
        the command line to jump right into it)
    * - :kbd:`=`
      - Toggle visibility of changes
    * - :kbd:`-` (when over a filename)
      - Stage or unstage the file
    * - :kbd:`-` (when in a chunk after using ``=``)
      - Stage or unstage the chunk
    * - :kbd:`-` (in visual select mode (``V``))
      - Stage or unstage **just the selected lines**. Perfect for making incremental commits.
    * - :kbd:`cc`
      - Commit, opening up a separate buffer in which to write the commit message
    * - :kbd:`dd` (when over a file)
      - Open the file in diff mode

The following commands are built-in vim commands when in diff mode, but
are used heavily when working with ``:Gdiff``, so here is a reminder:

.. list-table::

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

.. _vim-gv:

``vim.gv``
~~~~~~~~~~
`vim.gv <https://github.com/junegunn/gv.vim>`_ provides an interface to easily
view and browse git history.

.. list-table::

    * - command
      - description
    * - :kbd:`:GV` in visual mode
      - View commits affecting selection
    * - :kbd:`GV`
      - Open a commit browser, hit :kbd:`Enter` on a commit to view

``vim-mergetool``
~~~~~~~~~~~~~~~~~
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
`vim-diff-enhanced <https://github.com/chrisbra/vim-diff-enhanced>`_ provides
additional diff algorithms that work better on certain kinds of files. If your
diffs are not looking right, try changing the algorithm with this plugin:

.. list-table::

    * - command
      - description
    * - :kbd:`:EnhancedDiff <algorithm>`
      - Configure the diff algorithm to use, see below table


The following algorithms are available:

.. list-table::

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
`leap <https://github.com/ggandor/leap.nvim>`_ lets you jump around in a buffer
with low mental effort.

.. list-table::

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
`vim-surround <https://github.com/tpope/vim-surround>`_ lets you easily change
surrounding characters.

.. list-table::

    * - command
      - description
    * - :kbd:`cs"'`
      - change surrounding ``"`` to ``'``

``vim-commentary``
~~~~~~~~~~~~~~~~~~
`vim-commentary <https://github.com/tpope/vim-commentary>`_ lets you easily
toggle comments on lines or blocks of code.

.. list-table::

    * - command
      - description
    * - :kbd:`gc` on a visual selection
      - toggle comment
    * - :kbd:`gcc` on a single line
      - toggle comment


``vis``
~~~~~~~
`vis <https://github.com/vim-scripts/vis>`_ provides better behavior on visual
blocks.

Did you know that by default in vim and neovim, when selecting things in visual
block mode, operations (substitutions, sorting) operate on the entire line --
not just the block, as you might expect. However sometimes you want to edit
just the visual block selection, for example when editing TSV files.

.. list-table::

    * - command
      - description
    * - :kbd:`Ctrl-v`, then use :kbd:`:B` instead of :kbd:`:`
      - Operates on visual block selection only

``nerdtree``
~~~~~~~~~~~~
`nerdtree <https://github.com/scrooloose/nerdtree>`_ provides a file browser
for finding/selecting files to edit. Navigate it with vim movement keys, and
hit ``Enter`` to open the file in a new buffer.

.. list-table::

    * - command
      - description
    * - :kbd:`<leader>n`
      - toggle file browser

``supertab``
~~~~~~~~~~~~
`Supertab <https://github.com/ervandew/supertab>`_ lets you autocomplete most
things with ``TAB`` in insert mode. This is enabled automatically when the
plugin is installed. 

No additional configuration is performed here, but see ``:help supertab`` for
available options.

``python-syntax``
~~~~~~~~~~~~~~~~~
`python-syntax <https://github.com/vim-python/python-syntax>`_ provides
improved Python syntax highlighting.

This happens automatically when editing Python files. The syntax highlighting
is improved within format strings, within docstrings, reserved keywords.
Happens automatically when editing Python files; no additional commands.

``simpylfold``
~~~~~~~~~~~~~~
`SimpylFold <https://github.com/tmhedberg/SimpylFold>`_ provides improved code folding for Python.

Built-in vim folding for Python will also fold for-loops and if-blocks; this
only folds function, method, and class definitions using built-in vim commands
for folding like ``zc``, ``zn``, ``zM``.

``vim-python-pep8-indent``
~~~~~~~~~~~~~~~~~~~~~~~~~~
`vim-python-pep8-indent <https://github.com/Vimjas/vim-python-pep8-indent>`_
auto-indents Python using pep8 recommendations. This happens as you’re typing,
or when you use :kbd:`gq` on a selection to wrap. No additional commands
configured.

``vim-rmarkdown``
~~~~~~~~~~~~~~~~~
`vim-rmarkdown <https://github.com/vim-pandoc/vim-rmarkdown>`_ provides syntax
highlighting for R within RMarkdown code chunks. Requires both ``vim-pandoc``
and ``vim-pandoc-syntax``, described below.

No additional commands configured.

``vim-pandoc``
~~~~~~~~~~~~~~
`vim-pandoc <https://github.com/vim-pandoc/vim-pandoc>`_ Integration with
`pandoc <http://johnmacfarlane.net/pandoc/>`_. Uses vim-pandoc-syntax (see
below) for syntax highlighting.

Includes folding and formatting. Lots of shortcuts are defined by this plugin,
see ``:help vim-pandoc`` for much more.

``vim-pandoc-syntax``
~~~~~~~~~~~~~~~~~~~~~
`vim-pandoc-syntax <https://github.com/vim-pandoc/vim-pandoc-syntax>`_ is used
by vim-pandoc (above). It is a separate plugin because the authors found it
easier to track bugs separately.

No additional commands configured.


``vim-airline``
~~~~~~~~~~~~~~~
`vim-airline <https://github.com/vim-airline/vim-airline>`_ provides a nice
statusline, plus "tabs" that allow you to easily switch between open files and
copy/paste between them.

Install powerline fonts for full effect (``./setup.sh --powerline``). See below
for themes.

``vim-airline-themes``
~~~~~~~~~~~~~~~~~~~~~~
`vim-airline-themes
<https://github.com/vim-airline/vim-airline/wiki/Screenshots>`_ provides themes
for use with vim-airline.


``vim-tmux-clipboard``
~~~~~~~~~~~~~~~~~~~~~~
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

Troubleshooting
~~~~~~~~~~~~~~~

Sometimes text gets garbled when using an interactive node on biowulf.
This is due to a known bug in Slurm, but Biowulf is not intending on
updating any time soon. The fix is ``Ctrl-L`` either in the Rmd buffer
or in the terminal buffer. And maybe ``,R`` to refresh the syntax
highlighting.

Remember that the terminal is a vim window, so to enter commands you
need to be in insert mode.
