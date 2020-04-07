.. _vim:

Vim / Neovim
============

:file:`.vimrc` and :file:`.config/nvim/init.vim` have the same contents.

In the `.config/nvim/init.vim <.config/nvim/init.vim>`__ file in this
repo:

-  ``<Leader>`` is set to ``,``.
-  ``<Localleader>`` is set to ``/``

**Setting up powerline fonts:** After running
``./setup.sh --powerline``, which will install the fonts, you need to
tell the terminal to use those fonts. In the terminal itself, go to
Preferences, select the “Custom Font” checkbox, and choose a font that
ends with “Powerline”.

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

Shortcuts
---------

Here are some general shortcuts that are defined in the included config:

.. list-table::

    * - command
      - mode
      - description
    * - :kbd:`,`
      -
      - Remapped leader. Below, when you see :kbd:`,` it means :kbd:`<leader>`
        below, it means :kbd:`,`. E.g., :kbd:`<leader>3` becomes :kbd:`,3`
    * - :kbd:`,r`
      - normal
      - Toggle relative line numbering (makes it easier to jump around lines
        with motion operators).
    * - :kbd:`,H`
      - normal
      - Toggle highlighted search
    * - :kbd:`,\``
      - normal or insert
      - When editing RMarkdown, creates a new code chunk and enters it, ready
        to type
    * - :kbd:`,W`
      - normal
      - clean up all trailing spaces
    * - :kbd:`,R`
      - normal or insert
      - refresh syntax highlighting
    * - :kbd:`@l`
      - normal
      - macro to surround the line with quotes and add a trailing comma, making
        it easy to make Python or R lists out of pasted text


Plugins
-------

The plugins configured at the top of :file:`.config/nvim/init.vim` have lots
and lots of options. Here I’m only highlighting the options I use the most, but
definitely check out each homepage to see all the other weird and wonderful
ways they can be used.


neoterm
~~~~~~~

Provides a separate terminal in vim.

`homepage <https://github.com/kassio/neoterm>`_

With a terminal inside vim, you can send text between that terminal and a file
you have open. As described in the “Using R with nvim” section, this lets you
reproduce an RStudio-like environment purely from the terminal.

The following commands are custom mappings set in :file:`.config/nvim/init.vim`
that affect the terminal use:

.. list-table::

    * - command
      - mode
      - description
    * - :kbd:`,t`
      - normal
      - Open neoterm terminal to the right.
    * - :kbd:`Alt-w`
      - normal or insert
      - Move to terminal on right and enter insert mode
    * - :kbd:`,w`
      - normal
      - Same as above, but normal mode only
    * - :kbd:`Alt-q`
      - normal or insert
      - Move to buffer on left and enter normal mode
    * - :kbd:`,q`
      - normal
      - Same as above, but normal mode only
    * - :kbd:`,cd`
      - normal
      - Send the current RMarkdown code chunk to the neoterm buffer, and jump to the next chunk
    * - :kbd:`gxx`
      - normal
      - Send the current *line* to the neoterm buffer
    * - :kbd:`gx`
      - visual
      - Send the current *selection* to the neoterm buffer
    * - :kbd:`,k`
      - normal
      - Render the current RMarkdown file to HTML using `knitr::render()`.
        Assumes you have knitr installed and you're running R in a neoterm
        buffer
    * - :kbd:`,te`
      - normal
      - Open neoterm terminal to the right, and immediately activate the conda environment in the `./env` directory
    * - :kbd:`,t1e`
      - normal
      - Same as above, but 1 dir above in  `../env`
    * - :kbd:`,t2e`
      - normal
      - Same as above, but 2 dir above in  `../../env`
    * - :kbd:`,t3e`
      - normal
      - Same as above, but 3 dir above in  `../../../env`



supertab
~~~~~~~~

Autocomplete most things with ``TAB`` in insert mode.

`homepaage <https://github.com/ervandew/supertab>`_

This is enabled automatically when the plugin is installed.

python-syntax
~~~~~~~~~~~~~
Sophisticated Python syntax highlighting.

`homepage https://github.com/vim-python/python-syntax>`_

This happens automatically when editing Python files.
The syntax highlighting works for example within format
strings, within docstrings, reserved keywords. Happens automatically when
editing Python files.

SimpylFold
~~~~~~~~~~

Nice code folding for Python.

`homepage <https://github.com/tmhedberg/SimpylFold>`_


Use built-in vim commands for folding like ``zc``, ``zn``, ``zM`` as follows:

.. list-table::

    * - command
      - description
    * - :kbd:`zn`
      - unfold everything
    * - :kbd:`zM`
      - fold everything
    * - :kbd:`zc`
      - toggle folding of current block

vim-python-pep8-indent
~~~~~~~~~~~~~~~~~~~~~~

Auto-indent Python using pep8 recommendations.

`homepage <https://github.com/Vimjas/vim-python-pep8-indent>`_

This happens as you’re typing, or when you use :kbd:`gq` on a selection to wrap
it.

vim-rmarkdown
~~~~~~~~~~~~~

Syntax highlight R within RMarkdown code chunks.

`homepage <https://github.com/vim-pandoc/vim-rmarkdown>`_

Requires both ``vim-pandoc`` and ``vim-pandoc-syntax``, described below.

vim-pandoc
~~~~~~~~~~

Integration with `pandoc <http://johnmacfarlane.net/pandoc/>`_.

`homepage <https://github.com/vim-pandoc/vim-pandoc>`_

Includes folding and formatting. Lots of shortcuts defined, see `this section
of the help
<https://github.com/vim-pandoc/vim-pandoc/blob/master/doc/pandoc.txt#L390>`_
for more.

Uses vim-pandoc-syntax (see below) for syntax highlighting.

.. list-table::

    * - command
      - description
    * - :kbd:`:TOC`
      - Open a table of contents for the current document that you can use to
        navigate

vim-pandoc-syntax
~~~~~~~~~~~~~~~~~

Used by vim-pandoc (above)

`homepage <https://github.com/vim-pandoc/vim-pandoc-syntax>`_

vis
~~~
Better behavior on visual blocks.

`homepage <vim-scripts/vis>`_

By default, when selecting things in visual block mode, operations
(substitutions, sorting) operate on the entire line, not just the block.
However sometimes you want to edit just the visual block selection, for example
when editing TSV files.

.. list-table::

    * - command
      - description
    * - :kbd:`Ctrl-v`, then use `:B` instead of `:`
      - Operates on visual block selection only

nerdcommenter
~~~~~~~~~~~~~

Easily comment blocks of text.

`homepage <https://github.com/scrooloose/nerdcommenter>`_

.. list-table::

    * - command
      - description
    * - :kbd:`,cc`
      - Comment current or selected lines


nerdtree
~~~~~~~~

Open up a file browser for finding/selecting files to edit.

`homepage <https://github.com/scrooloose/nerdtree>`_


Open up a file browser, navigate it with vim movement keys, and hit ``Enter``
to open the file in a new buffer.

.. list-table::

    * - command
      - description
    * - :kbd:`,n`
      - toggle file browser


vim-airline
~~~~~~~~~~~
Nice statusline, plus "tabs" that allow you to easily switch between open files
and copy/paste between them.

`homepage <https://github.com/vim-airline/vim-airline>`

Install powerline fonts for full effect (``./setup.sh --powerline``). See below
for themes.

vim-airline-themes
~~~~~~~~~~~~~~~~~~
Themes for use with vim-airline.

`homepage <https://github.com/vim-airline/vim-airline/wiki/Screenshots>`_


vim-tmux-clipboard
~~~~~~~~~~~~~~~~~~

Automatically copy yanked text from vim into the tmux clipboard.

`homepage <https://github.com/roxma/vim-tmux-clipboard>`

See this `screencast <https://asciinema.org/a/7qzb7c12ykv3kcleo4jgrl2jy>`_ for
usage details. Note that this also requires the `vim-tmux-focus-events
<https://github.com/tmux-plugins/vim-tmux-focus-events>`_ plugin as well.


vim-fugitive
~~~~~~~~~~~~

Run git from vim.

`homepage <https://github.com/tpope/vim-fugitive>`_

I mostly use this for making incremental commits from within vim. This makes it
a terminal-only version of `git-cola <https://git-cola.github.io>`__.
Specifically:


.. list-table::

    * - command
      - description
    * - :kbd:`:Gdiff`
      - Split the current buffer, showing the current version on one side and
        the last-committed version on the other
    * - :kbd:`Gcommit`
      - After saving the buffer, commit to git (without having to jump back out
        the terminal). ``:Gcommit -m "commit message..."`` works too.

The following commands are built-in vim commands when in diff mode, but
are used heavily when working with ``:Gdiff``:

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

vim-diff-enhanced
~~~~~~~~~~~~~~~~~

Provides additional diff algorithms that work better on certain kinds of
files.

`homepage: <https://github.com/chrisbra/vim-diff-enhanced>`_

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


vim-table-mode
~~~~~~~~~~~~~~

Easy formatting of tables in Markdown and Restructured Text.

`homepage <https://github.com/vim-pandoc/vim-pandoc-syntax>`_

Nice Markdown tables are a pain to format. This plugin makes it easy, by
auto-padding table cells and adding the header lines as needed.


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
6. Go back to the RMarkdown or R script, and use the commands above to
   send lines over.

Working with R
~~~~~~~~~~~~~~

Once you have the terminal up and running:

1. Write some R code.
2. ``gxx`` to send the current line to R
3. Highlight some lines (``Shift-V`` in vim gets you to visual select
   mode), ``gx`` sends them and then jumps to the terminal.
4. Inside a code chunk, ``,cd`` sends the entire code chunk and then
   jumps to the next one. This way you can ``,cd`` your way through an
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
