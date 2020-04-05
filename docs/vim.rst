.. _vim:

Vim / Neovim
============

``.vimrc`` and ``.config/nvim/init.vim`` have the same contents.

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

Here are the shortcuts defined. Note that many of these (the ones
talking about a terminal) expect Neovim and the neoterm plugin.

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
    * - :kbd:`,t`
      - normal
      - Open neoterm terminal to the right.
    * - :kbd:`,te`
      - normal
      - Open neoterm terminal to the right, and immediatly activate the conda environment in the `./env` directory
    * - :kbd:`,t1e`
      - normal
      - Same as above, but 1 dir above in  `../env`
    * - :kbd:`,t2e`
      - normal
      - Same as above, but 2 dir above in  `../../env`
    * - :kbd:`,t3e`
      - normal
      - Same as above, but 2 dir above in  `../../../env`
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
      - Send the current line to the neoterm buffer
    * - :kbd:`gx`
      - visual
      - Send the selection to the neoterm buffer
    * - :kbd:`,k`
      - normal
      - Render the current RMarkdown file to HTML using `knitr::render()`.
        Assumes you have knitr installed and you're running R in a neoterm
        buffer


Plugins
-------

The plugins configured at the top of ``.config/nvim/init.vim`` have lots
and lots of options. Here I’m only highlighting the options I use the
most, but definitely check out each homepage to see all the other weird
and wonderful ways they can be used.



+----------------------------------------+-----------------------------+
| Plugin                                 | Description                 |
+========================================+=============================+
| ``neoterm`` `[section] <#neoterm>`__   | Provides a separate         |
| `[repo]                                | terminal in vim             |
| <https://github.com/kassio/neoterm>`__ |                             |
+----------------------------------------+-----------------------------+
| `                                      | Autocomplete most things by |
| `supertab``\ `[section] <#supertab>`__ | hitting                     |
| `[repo] <ht                            |                             |
| tps://github.com/ervandew/supertab>`__ |                             |
+----------------------------------------+-----------------------------+
| ``python-syntax``                      | Sophisticated python syntax |
| `[section] <#python-syntax>`__         | highlighting.               |
| `[repo] <https://g                     |                             |
| ithub.com/vim-python/python-syntax>`__ |                             |
+----------------------------------------+-----------------------------+
| ``Vimjas/vim-python-pep8-indent``      | Indent python using pep8    |
|                                        | recommendations             |
+----------------------------------------+-----------------------------+
| ``vim-pandoc/vim-rmarkdown``           | Nice RMarkdown syntax       |
|                                        | highlighting                |
+----------------------------------------+-----------------------------+
| ``vim-pandoc/vim-pandoc``              | Required for vim-rmarkdown  |
+----------------------------------------+-----------------------------+
| ``vim-pandoc/vim-pandoc-syntax``       | Required for vim-rmarkdown, |
|                                        | lots of other nice syntax   |
|                                        | highlighting, too           |
+----------------------------------------+-----------------------------+
| ``dhruvasagar/vim-table-mode``         | Easily create Markdown or   |
|                                        | ReST tables                 |
+----------------------------------------+-----------------------------+
| ``tmhedberg/SimpylFold``               | Nice folding for Python     |
+----------------------------------------+-----------------------------+
| ``vim-scripts/vis``                    | Operations in visual block  |
|                                        | mode respect selection      |
+----------------------------------------+-----------------------------+
| ``scrooloose/nerdcommenter``           | Comment large blocks of     |
|                                        | text                        |
+----------------------------------------+-----------------------------+
| ``scrooloose/nerdtree``                | File browser for vim        |
+----------------------------------------+-----------------------------+
| ``roxma/vim-tmux-clipboard``           | Copy yanked text from vim   |
|                                        | into tmux’s clipboard and   |
|                                        | vice versa.                 |
+----------------------------------------+-----------------------------+
| ``tmux-plugins/vim-tmux-focus-events`` | Makes tmux and vim play     |
|                                        | nicer together.             |
+----------------------------------------+-----------------------------+
| ``tpope/vim-fugitive``                 | Run git from vim            |
+----------------------------------------+-----------------------------+
| ``tpope/vim-surround``                 | Quickly change surrounding  |
|                                        | characters                  |
+----------------------------------------+-----------------------------+
| ``vim-airline/vim-airline``            | Nice statusline. Install    |
|                                        | powerline fonts for full    |
|                                        | effect.                     |
+----------------------------------------+-----------------------------+
| ``vim-airline/vim-airline-themes``     | Themes for the statusline   |
+----------------------------------------+-----------------------------+
| ``chrisbra/vim-diff-enhanced``         | Provides additional diff    |
|                                        | algorithms                  |
+----------------------------------------+-----------------------------+
| ``flazz/vim-colorschemes``             | Pile ’o colorschemes        |
+----------------------------------------+-----------------------------+
| ``felixhummel/setcolors.vim``          | ``:SetColors all`` and then |
|                                        | use F8 to change            |
|                                        | colorscheme                 |
+----------------------------------------+-----------------------------+
| ``jremmen/vim-ripgrep``                | Search current directory    |
|                                        | for lines in files          |
|                                        | containing word under       |
|                                        | cursor                      |
+----------------------------------------+-----------------------------+
| ``singularityware/singularity.lang``   | Syntax highlighting for     |
|                                        | Singularity                 |
+----------------------------------------+-----------------------------+

```kassio/neoterm`` <https://github.com/kassio/neoterm>`__
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Provides a separate terminal in vim. That way you can send text between
that terminal and a file you have open. As described in the “Using R
with nvim” section, this lets you reproduce an RStudio-like environment
purely from the terminal.

The following commands are custom mappings set in
`.config/nvim/init.vim <.config/nvim/init.vim>`__ that affect the
terminal use:

+---------+------------------------------------------------------------+
| command | description                                                |
+=========+============================================================+
| ``<lea  | Open a terminal in a new window to the right               |
| der>t`` |                                                            |
+---------+------------------------------------------------------------+
| ``gx``  | Send the current selection to the terminal                 |
+---------+------------------------------------------------------------+
| ``gxx`` | Send the current line to the terminal                      |
+---------+------------------------------------------------------------+
| ``<lead | Send the current RMarkdown chunk to the terminal (which is |
| er>cd`` | assumed to be running R)                                   |
+---------+------------------------------------------------------------+

```ervandew/supertab`` <https://github.com/ervandew/supertab>`__
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Autocomplete most things with ``TAB`` in insert mode.

```vim-python/python-syntax`` <https://github.com/vim-python/python-syntax>`__
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Sophisticated python syntax highlighting, for example within format
strings. Happens automatically when editing Python files.

```Vimjas/vim-python-pep8-indent`` <https://github.com/Vimjas/vim-python-pep8-indent>`__
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Auto-indent Python using pep8 recommendations. This happens as you’re
typing, or when you use ``gq`` on a selection.

```vim-pandoc/vim-rmarkdown`` <https://github.com/vim-pandoc/vim-rmarkdown>`__
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Syntax highlight R within RMarkdown code chunks. Requires both
``vim-pandoc`` and ``vim-pandoc-syntax``, described below.

```vim-pandoc/vim-pandoc`` <https://github.com/vim-pandoc/vim-pandoc>`__ and ```vim-pandoc/vim-pandoc-syntax`` <https://github.com/vim-pandoc/vim-pandoc-syntax>`__
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Integration with pandoc, including folding and formatting. Lots of
shortcuts defined, see `this section of the
help <https://github.com/vim-pandoc/vim-pandoc/blob/master/doc/pandoc.txt#L390>`__
for more.

+-----+----------------------------------------------------------------+
| c   | description                                                    |
| omm |                                                                |
| and |                                                                |
+=====+================================================================+
| ``  | Open a table contents for the current document that you can    |
| :TO | use to navigate the document                                   |
| C`` |                                                                |
+-----+----------------------------------------------------------------+

```vis`` <vim-scripts/vis>`__
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

When selecting things in visual block mode, by default operations
(substitutions, sorting) operate on the entire line, not just the block.

================================================= ======================
command                                           description
================================================= ======================
Ctrl-v, then select, then ``:B`` instead of ``:`` Operates on block only
================================================= ======================

```scrooloose/nerdcommenter`` <https://github.com/scrooloose/nerdcommenter>`__
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Easily comment blocks of text

============== =================================
command        description
============== =================================
``<leader>cc`` Comment current or selected lines
============== =================================

```scrooloose/nerdtree`` <https://github.com/scrooloose/nerdtree>`__
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Open up a file browser, navigate it with vim movement keys, and hit
``Enter`` to open the file in a new buffer.

============= ===================
command       description
============= ===================
``<leader>n`` Toggle file browser
============= ===================

```vim-airline/vim-airline`` <https://github.com/vim-airline/vim-airline>`__ and ```vim-airline/vim-airline-themes`` <https://github.com/vim-airline/vim-airline/wiki/Screenshots>`__
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Nice statusline. Install powerline fonts for full effect (with
``./setup.py --powerline-fonts`` using the setup script in this
repository)

```roxma/vim-tmux-clipboard``, ``tmux-plugins/vim-tmux-focus-events`` <https://github.com/roxma/vim-tmux-clipboard>`__
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Copy yanked text from vim into tmux’s clipboard and vice versa. The
focus-events plugin is also needed for this to work.

```tpope/vim-fugitive`` <https://github.com/tpope/vim-fugitive>`__
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Run git from vim.

I mostly use it for making incremental commits from within vim. This
makes it a terminal-only version of
`git-cola <https://git-cola.github.io>`__. Specifically:

+-----+----------------------------------------------------------------+
| c   | description                                                    |
| omm |                                                                |
| and |                                                                |
+=====+================================================================+
| `   | Split the current buffer, showing the current version on one   |
| `:G | side and the last-committed version in the other side          |
| dif |                                                                |
| f`` |                                                                |
+-----+----------------------------------------------------------------+
| ``: | After saving the buffer, commit to git (without having to jump |
| Gco | back out to terminal) \`:Gcommit -m “commit notes” works, too. |
| mmi |                                                                |
| t`` |                                                                |
+-----+----------------------------------------------------------------+

The following commands are built-in vim commands when in diff mode, but
are used heavily when working with ``:Gdiff``:

======= ========================================================
command description
======= ========================================================
``]c``  Go to the next diff.
``[c``  Go to the previous diff
``do``  Use the **o**\ ther file’s contents for the current diff
``dp``  **p**\ ut the contents of this diff into the other file
======= ========================================================

```chrisbra/vim-diff-enhanced`` <https://github.com/chrisbra/vim-diff-enhanced>`__
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Provides additional diff algorithms that work better on certain kinds of
files.

+------------------------+---------------------------------------------+
| command                | description                                 |
+========================+=============================================+
| ``:Enha                | Configure the diff algorithm to use, see    |
| ncedDiff <algorithm>`` | below table                                 |
+------------------------+---------------------------------------------+

The following algorithms are available:

+--------+-------------------------------------------------------------+
| Alg    | Description                                                 |
| orithm |                                                             |
+========+=============================================================+
| myers  | Default diff algorithm                                      |
+--------+-------------------------------------------------------------+
| d      | Alias for myers                                             |
| efault |                                                             |
+--------+-------------------------------------------------------------+
| m      | Like myers, but tries harder to minimize the resulting diff |
| inimal |                                                             |
+--------+-------------------------------------------------------------+
| pa     | Use the patience diff algorithm                             |
| tience |                                                             |
+--------+-------------------------------------------------------------+
| his    | Use the histogram diff algorithm (similar to patience but   |
| togram | slightly faster)                                            |
+--------+-------------------------------------------------------------+

```dhruvasagar/vim-table-mode`` <https://github.com/vim-pandoc/vim-pandoc-syntax>`__
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Nice Markdown tables are a pain to format. This plugin makes it easy, by
auto-padding table cells and adding the header lines as needed.

+-----------------+----------------------------------------------------+
| command         | description                                        |
+=================+====================================================+
| ``:Ta           | enables table mode                                 |
| bleModeEnable`` |                                                    |
+-----------------+----------------------------------------------------+
| ``:Tab          | disables table mode                                |
| leModeDisable`` |                                                    |
+-----------------+----------------------------------------------------+
| ``:Tableize     | realigns an existing table (adding padding as      |
|       | creates | necessary)                                         |
|  a markdown or  |                                                    |
| ReST table base |                                                    |
| d on TSV or CSV |                                                    |
|  text | |``:Tab |                                                    |
| leModeRealign\` |                                                    |
+-----------------+----------------------------------------------------+

See the homepage for, e.g., using ``||`` to auto-create header lines.

```tmhedberg/SimpylFold`` <https://github.com/tmhedberg/SimpylFold>`__
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Nice folding for Python, using built-in vim commands for folding like
``zc``, ``zn``, ``zM``.

======= ===============================
command description
======= ===============================
``zn``  unfold everything
``zM``  fold everything
``zc``  toggle folding of current block
======= ===============================

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
