.. _plugins:

Nvim plugins
============

Plugins are configured in :file:`lua/plugins/*.lua`.

Plugins are configured using `lazy.nvim <https://github.com/folke/lazy.nvim>`_.
This supports lazy-loading of plugins to keep a snappy startup time, and only
load plugins when they're needed. See :ref:`nvim-lua` for my rationale on that.

.. details:: Quick-reference on lazy.nvim

    Each plugin spec in :file:`lua/plugins/*.lua` is a table. The first property is
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

    .. note::

        Don't like a plugin? Find it in :file:`lua/plugins/*.lua` and add ``enabled
        = false`` next to where the plugin is named. For example:

        .. code-block:: lua

          { "user/plugin-name", enabled = false },

        Or delete the file completely.

.. details:: screencast of lazy.nvim setting up plugins

  .. image:: gifs/lazy_annotated.gif

Because of how frequently nvim changes, each plugin section below has
a changelog. Since I have reorganized files over the years, the changelogs show
the *mention* of a plugin in a commit message, in a filename, or as part of the
changeset of a commit. Checking all of these things is an attempt to catch all
of the changes. This may be a little overzealous (for example the ``trouble``
plugin picks up commits related to troubleshooting) but I've opted to err on
the side of completeness.

Plugin list
-----------

I've organized the plugins into broad categories:

.. contents:: Plugin list
   :local:
   :depth: 3

Git-related
+++++++++++

.. contents::
   :local:

The following commands are built-in vim commands when in diff mode, but
are used heavily when working with git, so here is a reminder:

.. _working-with-diffs:


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

.. _vimfugitive_ref:

``vim-fugitive``
~~~~~~~~~~~~~~~~

`vim-fugitive <https://github.com/tpope/vim-fugitive>`_ provides a git interface in vim.

Fugitive is wonderful for making incremental commits from within vim. This
makes it a terminal-only version of GUIs like git-cola, gitkraken, or GitHub
Desktop.

I use it so much that I have a bash alias for starting this directly from the
command line: ``gsv`` (mnemonic: git status viewer).


.. list-table::
    :header-rows: 1
    :align: left

    * - command
      - description

    * - ``:Git``
      - Opens git status interface in a split window showing modified files,
        staged changes, and recent commits. Navigate with j/k (hint: use `vim -c
        ":Git"` from command line to jump right into it)

    * - ``:tab Git``
      - Opens git status interface in a new tab for fullscreen usage. Press
        :kbd:`:q` to return to previous editing session

    * - :kbd:`=`
      - Toggles visibility of changes (diff) for the file under cursor. Shows
        what changed in chunks

    * - :kbd:`-` (when over a filename)
      - Stages the file if unstaged, unstages if already staged

    * - :kbd:`-` (when in a chunk after using ``=``)
      - Stages the chunk if unstaged, unstages if already staged

    * - :kbd:`-` (in visual select mode (``V``))
      - Stages or unstages **just the selected lines**. Perfect for making
        incremental commits

    * - :kbd:`cc`
      - Opens commit interface in a new buffer. Write your commit message, save
        and close (:wq) to complete the commit

    * - :kbd:`dd` (when over a file)
      - Opens the file in split diff mode showing line-by-line and character-by-
        character changes

.. plugin-metadata::
   :name: vim-fugitive

.. _diffview_ref:

``diffview.nvim``
~~~~~~~~~~~~~~~~~

`diffview.nvim <https://github.com/sindrets/diffview.nvim>`_ supports viewing
diffs across multiple files. It also has a nice interface for browsing previous
commits. I find this to be nicer for browsing git history when there are
multiple files per commit.

I have a bash alias for starting this directly from the command line: ``glv``
(mnemonic: git log viewer).

.. list-table::
    :header-rows: 1
    :align: left

    * - command
      - description

    * - ``:DiffviewOpen``
      - Opens the viewer

    * - ``:DiffviewFileHistory``
      - View diffs for this file throughout git history


.. plugin-metadata::
   :name: diffview


.. _gitsigns_ref:

``gitsigns``
~~~~~~~~~~~~

`gitsigns <https://github.com/lewis6991/gitsigns.nvim>`_ shows a "gutter" along
the left side of the line numbers, indicating where there were changes in
a file. Only works in git repos.

Since you can stage and make commits with this plugin, it is in a way redundant
with vim-fugitive. I find fugitive to be more useful when making commits across
multiple files, and gitsigns to be more useful in showing what's changed while
still editing a file.

Most commands require being in a hunk. Keymappings start with ``h``, mnemonic
is "hunk" (the term for a block of changes).

.. list-table::
    :header-rows: 1
    :align: left

    * - command
      - description

    * - :kbd:`[h`
      - Jump to previous change (hunk) in the file

    * - :kbd:`]h`
      - Jump to next change (hunk) in the file

    * - :kbd:`<leader>hp`
      - Preview hunk: opens floating window showing the diff for the current
        change. Move away (j/k) to close.

    * - :kbd:`<leader>hs`
      - Stage hunk: marks the current change to be included in next commit. In
        visual mode, stages only selected lines

    * - :kbd:`<leader>hr`
      - Reset hunk: discards the current change, reverting to what's in git. In
        visual mode, resets only selected lines

    * - :kbd:`<leader>hu`
      - Undo stage hunk: unstages a previously staged hunk

    * - :kbd:`<leader>hS`
      - Stage entire buffer: marks all changes in the current file for commit

    * - :kbd:`<leader>hR`
      - Reset entire buffer: discards all changes in the current file

    * - :kbd:`<leader>hb`
      - Shows git blame info for current line in a floating window (who changed
        it, when, commit message)

    * - :kbd:`<leader>hd`
      - Opens diff mode showing side-by-side comparison of current file vs git
        version


Additionally, this supports hunks as text objects using ``ih`` (inside hunk).
E.g., select a hunk with :kbd:`vih`, or delete a hunk with :kbd:`dih`.

.. plugin-metadata::
   :name: gitsigns

.. _gv_ref:

``gv``
~~~~~~

`vim.gv <https://github.com/junegunn/gv.vim>`_ provides an interface to easily
view and browse git history.

It's simpler than :ref:`diffview_ref` which can be helpful sometimes.

.. list-table::
    :header-rows: 1
    :align: left

    * - command
      - description

    * - :kbd:`:GV` in visual mode
      - View commits affecting selection

    * - :kbd:`GV`
      - Open a commit browser, hit :kbd:`Enter` on a commit to view

.. plugin-metadata::
   :name: gv


.. _mergetool_ref:

``vim-mergetool``
~~~~~~~~~~~~~~~~~

`vim-mergetool <https://github.com/samoshkin/vim-mergetool>`_ makes 3-way merge
conflicts much easier to deal with by only focusing on what needs to be
manually edited.

This makes it MUCH easier to work with 3-way diffs (like what happens in merge
conflicts), while at the same time allowing enough flexibility in configuration
to be able to reproduce default behaviors.

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

.. plugin-metadata::
   :name: vim-mergetool


LSP-related
+++++++++++

The Language Server Protocol lets an editor like neovim communicate with
a language server. A language server is installed per language (e.g. Python,
Bash, etc), which knows a LOT about the language, and supports things like:

- advanced autocomplete
- advanced highlighting
- going to definitiions or references (e.g., find where a function is
  originally defined, or where it is used)
- identifying syntax errors directly in the editor


`Microsoft's overview
<https://microsoft.github.io/language-server-protocol/>`__ of LSP has more
information.

You install an LSP server for each language you want to use it with (see
:ref:`mason_ref` for installing these). Then you enable the LSP server for
a buffer, and you get code-aware hints, warnings, etc.

Not all features are implemented in every LSP server. For example, the Python
LSP is quite feature-rich. In contrast, the R LSP is a bit weak.

The Python LSP may be quite verbose if you enable it on existing code, though
in my experience addressing everything it's complaining about will improve your
code. You may find you need to add type annotations in some cases.

Because the experience can be hit-or-miss depending on the language you're
using, and the language servers need to be installed, LSP is disabled by
default; start it with :kbd:`cl`.

.. note::

   nvim 0.11 changed the way LSPs are handled, making them more natively
   integrated. These dotfiles now support nvim 0.11+ and are backwards
   compatible with 0.10. 

.. contents::
   :local:

.. _nvimlspconfig_ref:

``nvim-lspconfig``
~~~~~~~~~~~~~~~~~~

`nvim-lspconfig <https://github.com/neovim/nvim-lspconfig>`_ provides access to
nvim's Language Server Protocol (LSP).

.. note::

   You'll probably need to install NodeJS to install language servers with ``:Mason`` (see :ref:`mason_ref`):

  .. code-block:: bash

     ./setup.sh --install-npm  # install nodejs into conda env

These keymaps start with :kbd:`c` (mnemonic: "code"). You need to start the
language server with :kbd:`cl` to have access to any of these keymaps.

In nvim 0.11+, there are `default keymaps
<https://neovim.io/doc/user/lsp.html#gra>`__ for LSP commands. These use the
:kbd:`gr` prefix (presumably g for "global", but not sure what the mnemonic is
for "r"). Otherwise, I'm using :kbd:`<leader>c` as the prefix for custom
commands; mnemonic is "code".


.. list-table::
    :header-rows: 1
    :align: left

    * - command
      - description
    * - :kbd:`<leader>cl`
      - Starts the Language Server Protocol (LSP) for this buffer, enabling
        code completion, diagnostics, and navigation. Mnemonic: [c]ode [l]SP
    * - :kbd:`<leader>ce`
      - Opens floating window with detailed explanation of the diagnostic
        (error/warning) under cursor. Mnemonic: [c]ode [e]rror
    * - :kbd:`<leader>cv`
      - Toggles inline virtual text showing diagnostic messages at end of lines.
        When off, diagnostics only appear in gutter. Mnemonic: [c]ode [v]irtual
    * - :kbd:`[d`
      - Jumps to previous diagnostic (error/warning/hint) in the buffer
    * - :kbd:`]d`
      - Jumps to next diagnostic (error/warning/hint) in the buffer
    * - :kbd:`grt`
      - Jumps to where the symbol under cursor is defined (e.g., function
        definition, class declaration). Mnemonic: [g]o to [r]eference [t]ype
    * - :kbd:`K`
      - Shows hover documentation for the symbol under cursor in a floating
        window (function signature, docstring, type info)
    * - :kbd:`grn`
      - Renames all instances of the symbol under cursor throughout the project.
        Opens prompt for new name. Mnemonic: [g]o to [r]eference [n]ame
    * - :kbd:`grr`
      - Opens list of all places where the symbol under cursor is referenced.
        Select one to jump to it. Mnemonic: [g]o to [r]eferences [r]eferences
    * - :kbd:`gra`
      - Opens menu of available code actions for current context (quick fixes,
        refactorings, imports). Mnemonic: [g]o to [r]eference [a]ction

.. plugin-metadata::
   :name: nvim-lspconfig

.. _mason_ref:

``mason.nvim``
~~~~~~~~~~~~~~

`mason.nvim <https://github.com/williamboman/mason.nvim>`_ easily installs
Language Server Protocols, debuggers, linters, and formatters. Use ``:Mason``
to open the interface, and hit :kbd:`i` on what you want to install, or
:kbd:`g?` for more help.

.. note::

  Many language servers use the npm (javascript package manager) to install.
  This is the case for ``pyright``, for example. You can use ``./setup.sh
  --install-npm`` to easily create a conda env with npm and add its bin dir to
  your ``$PATH``.

For Python, try ``pyright``.

For Lua (working on your nvim configs), use ``lua-language-server``
(nvim-lspconfig calls this ``lua-ls``).

For Bash, ``bash-language-server``.

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
      - Opens floating window with Mason interface showing available language
        servers and tools. Navigate with j/k, press i to install, X to uninstall,
        U to update

    * - :kbd:`i` on an item
      - Install the selected language server or tool


.. plugin-metadata::
   :name: mason

.. _trouble_ref:

``trouble.nvim``
~~~~~~~~~~~~~~~~

`trouble.nvim <https://github.com/folke/trouble.nvim>`_ organizes all the LSP
diagnostics into a single window. You can use that to navigate the issues found
in your code.

This only works if you've started the LSP for the buffer with :kbd:`cl` (see :ref:`nvimlspconfig_ref`).

The alternative is using :kbd:`[d` and :kbd:`]d` to move between diagnostics
(see :ref:`nvimlspconfig_ref`) but it's nice to get an overview with this
plugin.

.. list-table::
    :header-rows: 1
    :align: left

    * - command
      - description
    * - :kbd:`<leader>ct`
      - Toggles trouble.nvim diagnostic window at bottom of screen, showing all
        LSP errors/warnings in your project. Navigate with j/k, Enter to jump to
        issue, q to close (or `<leader>ct` again).

.. plugin-metadata::
   :name: trouble

.. _conform_ref:

``conform``
~~~~~~~~~~~

`conform <https://github.com/stevearc/conform.nvim>`__ runs style formatters on
the current buffer.

For example, if ``black`` is avaiable it will run that on the code, but in
a way that the changes can be undone (in contrast to running ``black``
manually on the file, which overwrites it).

.. list-table::
    :header-rows: 1
    :align: left

    * - command
      - description

    * - :kbd:`<leader>cf`
      - Run configured formatter on buffer (mnemonic: [c]ode [f]ormat)

You can install formatters via :ref:`mason_ref`.

For example, for Python I have ``isort`` and ``black``; for Lua, ``stylua``; for
bash, ``shfmt``. See the config file for how to set this up.

.. plugin-metadata::
   :name: conform

.. _lspprogress_ref:

``lsp-progress.nvim``
~~~~~~~~~~~~~~~~~~~~~

`lsp-progress.nvim <https://github.com/linrongbin16/lsp-progress.nvim>`__ adds
a status/progress indicator to the lualine (at the bottom of a window) so you
know when it's running.

No additional commands configured.

.. plugin-metadata::
   :name: lsp-progress


Interfaces
++++++++++

These plugins add different interfaces unrelated to git (interfaces related to
git are described above).

.. contents::
   :local:

.. _telescope_ref:

``telescope``
~~~~~~~~~~~~~

`Telescope <https://github.com/nvim-telescope/telescope.nvim>`_ provides
a floating window with fuzzy-search selection.

Searching and selecting what, you ask? Pretty much anything you hook it up to.

Type in the text box to filter the list. Hit enter to select (and open the
selected file in a new buffer). Hit Esc twice to exit.

.. list-table::
    :header-rows: 1
    :align: left

    * - command
      - description

    * - :kbd:`<leader>ff`
      - Opens floating window for fuzzy file search under current directory. Type
        to filter filenames, press Enter to open selected file, Esc to cancel.
        Handy alternative to ``:e``

    * - :kbd:`<leader>fg`
      - Search directory for string. This is like using ripgrep, but in vim.
        Selecting entry takes you right to the line.

    * - :kbd:`<leader>/`
      - Opens floating window for fuzzy search within current buffer. Type to
        filter matching lines, Enter to jump to selected line, Esc to cancel

    * - :kbd:`<leader>fc`
      - Opens floating window to search for code symbols (functions, classes,
        variables) in the current buffer using Treesitter. Type to filter, Enter
        to jump to symbol, Esc to cancel


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

.. plugin-metadata::
   :name: telescope

.. _nvimtree_ref:

``nvim-tree``
~~~~~~~~~~~~~

`nvim-tree <https://github.com/nvim-tree/nvim-tree.lua>`__ provides a filesystem tree for browsing.

.. list-table::
    :header-rows: 1

    * - command
      - description

    * - :kbd:`<leader>fb`
      - Toggles file browser sidebar showing directory tree. Navigate with j/k,
        Enter to open files/folders, q to close

    * - :kbd:`-` (within browser)
      - Navigate up one directory level

    * - :kbd:`Enter` (within browser)
      - Opens file in editor, expands directory to show contents, or collapses
        open directory

    * - :kbd:`ga` (within browser)
      - Add file to git. Useful when you have fugitive also open, and want to
        add a file from an as-yet-untracked directory

    * - :kbd:`gu` (within browser)
      - Unstage file to git. Useful when you have fugitive also open

The window-switching shortcuts :kbd:`<leader>w` and :kbd:`<leader>q` (move to
windows left and right respectively; see :ref:`toggleterm_ref`) also work.

.. plugin-metadata::
   :name: nvim-tree

.. _whichkey_ref:

``which-key``
~~~~~~~~~~~~~

`which-key <https://github.com/folke/which-key.nvim>`_ displays a popup with
possible key bindings of the command you started typing. This is wonderful for
discovering commands you didn't know about, or have forgotten.

The window will appear 1 second after pressing a key. For example, try pressing
the leader key (:kbd:`,`) and waiting a second to see all the keys you can
press after the leader and what the behavior will be.

The length of this delay is configured with ``vim.o.timeoutlen``, e.g.
``vim.o.timeoutlen=500`` for half a sectond). There is no timeout though for
registers (``"``) or marks (``'``) or spelling (``z=`` over a word).

You can hit a displayed key to execute the command, or if it's a multi-key
command (typically indicated with a ``+prefix`` to show there's more), then
that will take you to the next menu.

Use :kbd:`<Backspace>` to back out a menu. In fact, pressing any key, waiting
for the menu, and then hitting backspace will give a list of all the default
mapped keys in vim.

There is currently no extra configuration. Instead, when a key is mapped
(either in :file:`lua/mappings.lua` or :file:`lua/plugins/*.lua`), an
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

.. plugin-metadata::
   :name: which-key


.. _aerial_ref:

``aerial``
~~~~~~~~~~

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
      - Toggles aerial navigation sidebar showing code structure outline
        (functions, classes, methods). Navigate with j/k, Enter to jump to item,
        q to close

    * - :kbd:`{` and :kbd:`}`
      - Jump to previous (`{`) or next (`}`) code item in the buffer (function,
        class, snakemake rule, markdown section)

For navigating complex codebases, there are other keys that are automatically
mapped, which you can read about in the `README for aerial
<https://github.com/stevearc/aerial.nvim>`_.

.. plugin-metadata::
   :name: aerial

Visuals
+++++++

These plugins add various visual enhancements to nvim.

.. _bufferline_ref:

``bufferline``
~~~~~~~~~~~~~~

`bufferline.nvim <https://github.com/akinsho/bufferline.nvim>`_ provides the
tabs along the top.

.. list-table::
    :header-rows: 1
    :align: left

    * - command
      - description
    * - :kbd:`<leader>b`, then type highlighted letter in tab
      - Enters buffer-pick mode: each open buffer tab shows a letter. Type that
        letter to switch to the corresponding buffer

.. plugin-metadata::
   :name: bufferline

.. _beacon_ref:

``beacon``
~~~~~~~~~~

`Beacon <https://github.com/danilamihailov/beacon.nvim>`_ provides an animated
marker to show where the cursor is.

.. list-table::
    :header-rows: 1
    :align: left

    * - command
      - description

    * - :kbd:`n` or :kbd:`N` after search
      - Flash beacon at search hit

.. plugin-metadata::
   :name: beacon

.. _lualine_ref:

``lualine``
~~~~~~~~~~~

`lualine <https://github.com/nvim-lualine/lualine.nvim>`_ provides the status line along the bottom.

No additional commands configured, but see the homepage for all the things you
can add to it.

.. plugin-metadata::
   :name: lualine

.. _indentblankline_ref:

``indent-blankline``
~~~~~~~~~~~~~~~~~~~~

`indent-blankline <https://github.com/lukas-reineke/indent-blankline.nvim>`_
shows vertical lines where there is indentation, and highlights one of these
vertical lines to indicate the current `scope
<https://en.wikipedia.org/wiki/Scope_(computer_science)>`_.

No additional commands configured. However, depending on the font you use, you
may want to play around with the symbol used.

.. plugin-metadata::
   :name: indent-blankline

.. _rendermarkdown_ref:

``render-markdown``
~~~~~~~~~~~~~~~~~~~

`render-markdown
<https://github.com/MeanderingProgrammer/render-markdown.nvim>`__ provides
a nicer reading experience for markdown files. This includes bulleted list and
checkbox icons, fancy table rendering, colored background for code blocks, and
more.

In my testing I found it to be more configurable and performant than the
``obsidian.nvim`` equivalent functionality, and in ``daler/zenburn.nvim`` I've
added highlight groups for this plugin.

.. details:: Some notes about its behavior:

    - It uses "conceal" functionality to replace things like ``-`` (for bulleted
      lists) with the unicode ``•``. It hides URLs and only shows the link text
      (like a website does)
    - It's configured to differentiate between a web link (http) and an internal
      link (no http) and show an icon for an internal link.
    - It has functionality for parsing headlines and making them stand out more in
      a document. The actual styling of headlines is configured in the colorscheme.
    - Code blocks have an icon indicating their language, and the background of
      code blocks is different from surrounding text.
    - Tables are rendered nicely

This plugin is **specifically disabled for RMarkdown files**, which are
typically heavy on the source code, and the background of code chunks can get
distracting when entering and exiting insert mode. However, this plugin can be
useful when reviewing a long RMarkdown file to focus on the narrative text.

.. list-table::
    :header-rows: 1
    :align: left

    * - command
      - description

    * - :kbd:`<leader>rm`
      - Toggles render-markdown on/off for the current markdown file. When on,
        shows enhanced formatting (bullets, tables, code blocks). When off, shows
        raw markdown. Mnemonic: [r]ender [m]arkdown

.. plugin-metadata::
   :name: render-markdown

.. _nvimcolorizer_ref:

``nvim-colorizer``
~~~~~~~~~~~~~~~~~~

`nvim-colorizer <https://github.com/norcalli/nvim-colorizer.lua>`__ is
a high-performance color highlighter. It converts hex codes to their actual
colors.

.. list-table::
    :header-rows: 1
    :align: left

    * - command
      - description

    * - ``ColorizerToggle``
      - Toggle colorizing of hex codes

.. plugin-metadata::
   :name: nvim-colorizer

.. _lush_ref:

``lush``
~~~~~~~~

`lush <https://github.com/rktjmp/lush.nvim>`__ is a helper for adjusting colors in a colorscheme.

Open up a color scheme file, run ``:Lushify``, and you can use :kbd:`<C-a>` and
:kbd:`<C-x>` to increase/decrease values. This gives you live feedback as
you're working. See the homepage linked above for a demo, and `zenfade
<https://github.com/daler/zenfade//>`__ for a colorscheme that used lush (and
so supports it well).

.. plugin-metadata::
   :name: lush


Everything else
+++++++++++++++

These plugins don't have a clear categorization. That doesn't mean they're not
super helpful though!

.. contents::
   :local:

.. _vimcommentary_ref:

``vim-commentary``
~~~~~~~~~~~~~~~~~~

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

.. plugin-metadata::
   :name: vim-commentary


.. _acceleratedjk_ref:

``accelerated-jk``
~~~~~~~~~~~~~~~~~~

`accelerated-jk <https://github.com/rhysd/accelerated-jk>`_ speeds up j and
k movements: longer presses will jump more and more lines.

In particular, you might want to tune the acceleration curve depending on your
system's keyboard repeat rate settings -- see the config file for an explanation of
how to tweak.

.. list-table::
    :header-rows: 1
    :align: left

    * - command
      - description

    * - :kbd:`j`, :kbd:`k`
      - Keep holding for increasing vertical scroll speed

.. plugin-metadata::
   :name: accelerated-jk

.. _blink_ref:

``blink``
~~~~~~~~~

`blink <https://github.com/Saghen/blink.cmp>`__ offers autocomplete.


In this config, I've chosen to mimic the bash style of completion,
the commands documented here reflect that. I've also disabled the menu popping
up all the time. There are a lot of ways you can customize this yourself though
-- see the `blink docs <https://cmp.saghen.dev/>`__.

.. list-table::
    :header-rows: 1
    :align: left

    * - command
      - description

    * - :kbd:`<C-space>`
      - Open completion menu

    * - :kbd:`<Tab>` (when typing and the cursor is in a word)
      - Open completion menu

    * - :kbd:`<Tab>`, :kbd:`<Shift-Tab>` (in menu)
      - Next, previous entry

    * - :kbd:`Enter` (when menu visible)
      - Select entry

    * - up/down arrow (in menu)
      - Next, previous entry

.. plugin-metadata::
   :name: blink

.. _treesitter_ref:

``treesitter``
~~~~~~~~~~~~~~

`treesitter <https://github.com/nvim-treesitter/nvim-treesitter>`__ is a parsing
library that underpins many other plugins.

You install a parser for a language, and it figures out which tokens
are functions, classes, variables, modules, etc. Then it's up to other plugins
to do something with that. For example, colorschemes can use that information,
or you can select text based on its semantic meaning within the programming
language (like easily select an entire function, or the body of a for-loop).

Treesitter is configured to ensure the parsers listed in the config are
installed. These will be attempted to be installed automatically, but they do
require a C compiler to be available.

- On a Mac, this may need XCode Command Line Tools to be installed.
- A fresh Ubuntu installation will need ``sudo apt install build-essential``
- RHEL/Fedora will need ``sudo dnf install 'Development Tools'`` (and may need
  the `EPEL repo <https://docs.fedoraproject.org/en-US/epel/>`__ enabled).
- Alternatively, if you don't have root access, you can install `compiler
  packages via conda
  <https://docs.conda.io/projects/conda-build/en/stable/resources/compiler-tools.html>`_,

Alternatively, comment out the entire ``ensure_installed`` block in
:file:`~/.config/nvim/lua/plugins/treesitter.lua`; this means you will not have
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

.. plugin-metadata::
   :name: treesitter

.. _toggleterm_ref:

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
    :header-rows: 1
    :align: left

    * - command
      - description

    * - :kbd:`<leader>t`
      - Opens a terminal in a vertical split on the right side. Terminal starts
        in insert mode ready for commands

    * - :kbd:`<leader>w`
      - Switches focus to the right window (typically the terminal) and enters
        insert mode automatically

    * - :kbd:`<leader>q`
      - Switches focus back to the left window (typically the text buffer) and
        enters normal mode for editing

    * - :kbd:`<leader>cd`
      - Sends the current RMarkdown code chunk to terminal for execution, then
        automatically jumps cursor to the next chunk. Great for interactive data
        analysis

    * - :kbd:`gxx`
      - Sends the current line under cursor to the terminal and executes it.
        Useful for running single commands

    * - :kbd:`gx`
      - Sends the currently selected text (visual mode) to the terminal and
        executes it. Useful for running multiple lines

    * - :kbd:`<leader>k` (in RMarkdown file)
      - Renders the current RMarkdown file to HTML using `knitr::render()`.
        Requires knitr installed and R running in terminal

    * - :kbd:`<leader>k` (in Python file)
      - Runs the current Python script in IPython using `%run` magic command.
        Requires IPython running in terminal

.. plugin-metadata::
   :name: toggleterm


.. _vimdiffenhanced:

``vim-diff-enhanced``
~~~~~~~~~~~~~~~~~~~~~

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

.. plugin-metadata::
   :name: vim-diff-enhanced

.. _vimtablemode_ref:

``vim-table-mode``
~~~~~~~~~~~~~~~~~~

`vim-table-mode <https://github.com/dhruvasagar/vim-table-mode>`_ provides
easy formatting of tables in Markdown and Restructured Text

Nice Markdown and ReStructured Text tables are a pain to format. This plugin
makes it easy, by auto-padding table cells and adding the header lines as
needed.

* With table mode enabled, :kbd:`||` on a new line to start the header.
* Type the header, with column names separated by :kbd:`|`.
* On a new line, use :kbd:`||` to fill in the header underline.
* On subsequent rows, delimit fields by :kbd:`|` (including a leading and trailing :kbd:`|`)
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

.. plugin-metadata::
   :name: vim-table-mode

.. _flash_ref:

``flash``
~~~~~~~~~

`flash <https://github.com/folke/flash.nvim>`__ lets you jump around in
a buffer with low mental effort.

The trick is to *keep your eyes on the destination*. Hit :kbd:`s`, and type the
first 2 letters of where you're trying to go. This plugin will dim the rest of
the buffer, only highlighting instances where those 2 letters occur. It will
also add a *third* letter after it. If you type that third letter, the cursor will
jump to that location.

Alternatively, if a treesitter parser is installed for this filetype, you can
use :kbd:`S` and suffix letters will be shown at different levels of the syntax
tree. For example inside a for-loop (i.e. don't include the `for`); outside
a for-loop (including the `for`), an entire function, entire Rmd code chunk,
etc. In this mode, which is just for selection, you don't type the two
characters you're looking for. Instead you just type the letter coresponding to
level of code that you want to select.

.. list-table::
    :header-rows: 1
    :align: left

    * - command
      - description

    * - :kbd:`s` in normal mode
      - jump to match (see details)

    * - :kbd:`S` in normal mode
      - select this treesitter node (see details)

    * - :kbd:`Ctrl-s` when searching
      - Toggle flash during search

.. plugin-metadata::
   :name: flash

.. _vimsurround:

``vim-surround``
~~~~~~~~~~~~~~~~

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

.. plugin-metadata::
   :name: vim-surround

.. _vis_ref:

``vis``
~~~~~~~

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

.. plugin-metadata::
   :name: vis

.. _stickybuf_ref:

``stickybuf.nvim``
~~~~~~~~~~~~~~~~~~

`stickybuf.nvim <https://github.com/stevearc/stickybuf.nvim>`__ prevents text
buffers from opening up inside a terminal buffer.

Otherwise, you run nvim inside of nvim, and it gets hard to control which
instance of nvim is supposed to be interpreting your keystrokes.

No additional commands configured.

.. plugin-metadata::
   :name: stickybuf


.. _obsidian_ref:

``obsidian.nvim``
~~~~~~~~~~~~~~~~~

`obsidian.nvim <https://github.com/epwalsh/obsidian.nvim>`__ is a plugin
originally written for working with `Obsidian <https://obsidian.md/>`__ which is a GUI
notetaking app (that uses markdown and has vim keybindings). If you're an
Obsidian user, this plugin makes the experience with nvim quite nice.

However, after using it for a bit I really like it for markdown files in
general, in combination with the :ref:`rendermarkdown_ref` plugin.

I've been using it to take daily notes.


The mapped commands below use :kbd:`o` ([o]bsidian) as a a prefix.

.. list-table::
    :header-rows: 1
    :align: left

    * - command
      - description

    * - :kbd:`Enter` on any link
      - Open the link in a browser (if http) or open the file in a new buffer

    * - :kbd:`<leader>od`
      - [o]bsidian [d]ailies: choose or create a daily note

    * - :kbd:`<leader>os`
      - [o]bsidian [s]search for notes with ripgrep

    * - :kbd:`<leader>ot`
      - [o]bsidian [t]ags finds occurrences of ``#tagname`` across files in directory

    * - :kbd:`<leader>on`
      - [o]bsidian [n]ew link with a word selected will make a link to that new file

.. plugin-metadata::
    :name: obsidian


.. _browsher_ref:

``browsher.nvim``
~~~~~~~~~~~~~~~~~

`browsher.nvim <https://github.com/claydugo/browsher.nvim>`_ constructs a URL
for GitHub or GitLab that includes line highlighting, based on your visual
selection.

Run ``:Browsher`` on a line of code, and a URL to that line of code in the
upstream repo (GitHub, GitLab) will be copied to your clipboard.

It is currently configured to store the URL on your OS clipboard, which makes
it useful for working on remote systems. However, you can comment out the
``open_cmd`` config option if you want it to automatically open a browser tab
for working on a local machine.

It is also currently configured to optionally read from a file stored outside
of a dotfiles repo. This is to support the construction of URLs for private
GitHub/GitLab instances. See the config file
:file:`.config/nvim/lua/plugins/browsher.lua` for details.


.. code-block:: lua

   -- Add the following to ~/.browsher.lua, using your own instance URL
    return {
      ["gitlab.private.com"] = {
        url_template = "%s/-/blob/%s/%s",
        single_line_format = "#L%d",
        multi_line_format = "#L%d-%d",
      },
    }

.. list-table::
   :header-rows: 1
   :align: left

   * - command
     - description

   * - ``Browsher``
     - Store URL on OS clipboard

.. plugin-metadata::
   :name: browsher

.. _indentomatic_ref:

``indent-o-matic``
~~~~~~~~~~~~~~~~~~
`indent-o-matic <https://github.com/Darazaki/indent-o-matic>`__ is "dumb
automatic fast indentation detection".

To quote more from the home page, "Instead of trying to be smart about
detecting an indentation using statistics, it will find the first thing that
looks like a standard indentation (tab or 8/4/2 spaces) and assume that's what
the file's indentation is. This has the advantage of being fast and very often
correct while being simple enough that most people will understand what it will
do predictably"

When starting a blank file, if it's not doing what you want when you hit
:kbd:`<Tab>` then give it a hint: manually use the tab spacing you want and then
run ``:IndentOMatic`` to re-check.

No additional commands configured.

.. plugin-metadata::
   :name: indent-o-matic


.. _treesj_ref:

``TreeSJ``
~~~~~~~~~~

`TreeSJ <https://github.com/Wansmer/treesj>`__ uses treesitter to split and
join nodes. This is one of those things that is a lot easier to show than
explain. It converts back and forth between this:

.. code-block:: python

   def f(a, b=True, c='default'):
       pass

and this:

.. code-block:: python

   def f(
       a,
       b=True,
       c='default',
    ):
        pass


.. list-table::
    :header-rows: 1
    :align: left

    * - command
      - description

    * - :kbd:`<leader>j`
      - Toggle split/join

.. plugin-metadata::
   :name: treesj

.. _imgclip_ref:

``img-clip.nvim``
~~~~~~~~~~~~~~~~~

`img-clip.nvim <https://github.com/HakonHarnes/img-clip.nvim>`__ lets you paste
an image on your clipboard into a Markdown, Latex, or ReST file.

It detects what sort of image is on the clipboard, pastes it into a file in the
current directory (that you name at the prompt), and inserts it as an image
link into the document.

On Mac, it needs `pngpaste <https://github.com/jcsalterego/pngpaste>`__ to be
installed and on your PATH.

.. list-table::
    :header-rows: 1
    :align: left

    * - command
      - description

    * - :kbd:`<leader>P`
      - Paste image on clipboard

.. plugin-metadata::
   :name: img-clip

.. colorschemes_ref:

Colorschemes
------------

**If colors look broken** then you may be using a terminal like the default
Terminal.app on macOS that does not support true color. See
:ref:`mac-terminal-colors` for how to fix.

For years I've been using the venerable *zenburn* colorscheme. However, now
with additional plugins and highlighting mechansims (especially treesitter), it
became important to be able to configure more than what that colorscheme supported.

`zenburn.nvim <https://github.com/phha/zenburn.nvim>`_ is a reboot of
this colorscheme, but there were some parts of it that I wanted to change, or
at least have more control over.

`My fork of the repo <https://github.com/daler/zenburn.nvim>`__ is used here.
If you're interested in tweaking your own colorschemes, I've hopefully
documented that fork enough to give you an idea of how to modify on your own.


`zenfade <https://github.com/daler/zenfade/>`__ is what I've been working on
recently. It's a warmer and more faded version of zenburn and I like it quite
a bit. However, since zenburn has been the default for a while and other people
are using it (and are probably used to it), I'm not setting zenfade to be the
default, at least not yet.

Changelog for ``zenburn``:

.. plugin-metadata::
   :name: zenburn
   :file: ../.config/nvim/lua/plugins/colorschemes.lua

Changelog for ``zenfade``:

.. plugin-metadata::
   :name: zenfade

Changelog for ``colorscheme``:

.. plugin-metadata::
   :name: colorscheme

Deprecations
------------

Sometimes there are better plugins for a particular functionality. I've kept
the documentation here in case you're using an old version.

Deprecated plugins
++++++++++++++++++

``vim-rmarkdown``
~~~~~~~~~~~~~~~~~

.. plugin-metadata::
    :name: vim-rmarkdown
    :deprecation: Removed in favor of treesitter

``vim-pandoc``
~~~~~~~~~~~~~~

.. plugin-metadata::
    :name: vim-pandoc
    :deprecation: Removed in favor of treesitter

``vim-pandoc-syntax``
~~~~~~~~~~~~~~~~~~~~~

.. plugin-metadata::
    :name: vim-pandoc-syntax
    :deprecation: Removed in favor of treesitter

``vim-tmux-clipboard``
~~~~~~~~~~~~~~~~~~~~~~

.. plugin-metadata::
    :name: vim-tmux-clipboard
    :deprecation: Removed because OSC 52 support in modern terminals/tmux/nvim makes things much easier for handling copy/paste.

``leap.nvim``
~~~~~~~~~~~~~

.. plugin-metadata::
  :name: leap
  :deprecation: Removed in favor of the :ref:`flash_ref` plugin, which behaves similarly but also supports treesitter selections

``nvim-cmp``
~~~~~~~~~~~~

.. plugin-metadata::
   :name: nvim-cmp
   :deprecation: Deprecated in favor of :ref:`blink_ref`, which has similar configurability but does not *require* it. blink also seems to play nicer with LSP.


``vim-sleuth``
~~~~~~~~~~~~~~

.. plugin-metadata::
   :name: vim-sleuth
   :deprecation: vim-sleuth would often get things wrong. indent-o-matic's simpler algorithm seems to work better.

Notes on tried plugins
----------------------

- nvim-aider, when paired with neo-tree, was nice to use for adding files to the context. But now:

  - nvim-aider supports nvim-tree too now
  - aider has gotten better at tab-completion, making it easy to add even deeply-nested files
  - nvim-tree's :kbd:`-` to go up a directory was confusing with neo-tree's "remove from aider context"
  - It's a better experience to just keep aider running in a different tmux pane/window . . . no need to consume nnvim screen real estate.

- vim-matchup was nice to have (esp for Python) but it caused errors when
  trying to edit a buffer where a treesitter parser wasn't installed.


- ``jakewvincent/mkdnflow.nvim`` was nice for hitting :kbd:`<CR>` to open
  a linked file and then :kbd:`<BS>` to go back. But I realized I needed to
  keep the context in my head of where I came from. I prefer having separate
  buffers open so I can keep track of that (and buffer navigation helps move
  between them). This plugin is also pretty nice for collapsing sections into
  fancy headers. But I didn't consider it sufficiently useful to warrant
  including and configuring it.
- ``lukas-reineke/headlines.nvim`` had nice section headers, and it had
  backgrounds for code blocks. However that ended up having too much visual
  noise for my taste.
- ``nvim-telekasten/telekasten.nvim`` has nice pickers for tags and files and
  making links, but it was too opinionated for forcing the "telekasten" style
  of note-taking.
