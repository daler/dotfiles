.. _plugins:

Nvim plugins
============

Plugins are configured in :file:`lua/plugins/*.lua` using
`lazy.nvim <https://github.com/folke/lazy.nvim>`_.
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

    * ``event``: load on an event such as ``VeryLazy`` or ``InsertEnter``.
      Implies lazy=true.

    * ``config``: run this stuff after the plugin loads. ``config = true`` calls
      ``require(<main>).setup(opts)``, with the main module inferred by lazy.nvim.

    * ``opts``: options passed to the plugin's setup function; implies
      ``config = true`` unless a custom config function is supplied.

    * ``init``: runs before the plugin loads, during startup. Useful for setting
      ``vim.g`` variables that vimscript plugins read when they load.

    * ``cond``: load only when this condition is true. Unlike ``enabled``, a false
      condition does not uninstall the plugin

    If keys are specified, this is the only place they need to be mapped, and they
    will make their way into the which-key menu even if they trigger a lazy-loaded
    plugin. Use the ``desc`` argument to give which-key a description to use.

    .. note::

        Don't like a plugin? Find it in :file:`lua/plugins/*.lua` and add ``enabled
        = false`` next to where the plugin is named. For example:

        .. code-block:: lua

          { "user/plugin-name", enabled = false },

        Or delete the file completely.

.. details:: Screencast
    :class: screencasts

    .. figure:: gifs/lazy_annotated.gif

       **Set up plugins with lazy.nvim.** Follow the annotated plugin setup
       recording to see lazy.nvim managing the Neovim plugin installation.

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
   :depth: 2
   :backlinks: none
   :class: plugin-toc

Git-related
+++++++++++

.. contents::
   :local:
   :depth: 1
   :backlinks: none

The following commands are built-in vim commands when in diff mode, but
are used heavily when working with git, so here is a reminder:

.. _working-with-diffs:


.. list-table::
    :header-rows: 1
    :align: left

    * - command
      - description

    * - :kbd:`]c`
      - Goes to the next diff

    * - :kbd:`[c`
      - Goes to the previous diff

    * - :kbd:`do`
      - Uses the other file's contents for the current diff. Mnemonic: [o]ther

    * - :kbd:`dp`
      - Puts the contents of this diff into the other file. Mnemonic: [p]ut

.. _vimfugitive_ref:

``vim-fugitive``
~~~~~~~~~~~~~~~~

`vim-fugitive <https://github.com/tpope/vim-fugitive>`_ provides a git interface in vim.

Fugitive is wonderful for making incremental commits from within vim. This
makes it a terminal-only version of GUIs like git-cola, gitkraken, or GitHub
Desktop.

I use it so much that I have a bash alias for starting this directly from the
command line: ``gsv``. Mnemonic: git status viewer.

.. details:: Screencasts
    :class: screencasts

    .. asciinema:: screencasts/casts/vim-fugitive.cast
        :preload:
        :poster: npt:5
        :caption: **Git status and inline diffs.** Open the status window with ``:Git``, navigate its untracked, unstaged, and staged sections, and expand inline diffs with :kbd:`=`.

    .. asciinema:: screencasts/casts/vim-fugitive2.cast
        :preload:
        :poster: npt:5
        :caption: **Build an incremental commit.** Select lines in an inline diff and stage just that selection with :kbd:`-`, then stage a whole file and toggle staged changes back out of the index.

    .. asciinema:: screencasts/casts/vim-fugitive3.cast
        :preload:
        :poster: npt:5
        :caption: **Review and commit.** Continue from the staging demo: inspect the staged diff with :kbd:`=`, open a commit message with :kbd:`cc`, then save and close it to create the commit.

    .. asciinema:: screencasts/casts/vim-fugitive4.cast
        :preload:
        :poster: npt:5
        :caption: **Compare a whole file.** Open a side-by-side diff from the status window with :kbd:`dd` and use :kbd:`do` and :kbd:`dp` to pull or push individual changes between versions.

.. list-table::
    :header-rows: 1
    :align: left

    * - command
      - description

    * - ``:Git``
      - Opens git status interface in a split window showing modified files,
        staged changes, and recent commits. Navigate with j/k (hint: use ``vim -c
        ":Git"`` from command line to jump right into it)

    * - ``:tab Git``
      - Opens git status interface in a new tab for fullscreen usage. Press
        ``:q`` to return to previous editing session

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

I have a bash alias for starting this directly from the command line: ``glv``.
Mnemonic: git log viewer.

.. details:: Screencasts
    :class: screencasts

    .. asciinema:: screencasts/casts/diffview.cast
        :preload:
        :poster: npt:5
        :caption: **Compare changes across files.** Use ``:DiffviewOpen`` to compare the working tree with HEAD, move between file diffs with Tab and Shift-Tab, then compare a range covering the last two commits.

    .. asciinema:: screencasts/casts/diffview2.cast
        :preload:
        :poster: npt:5
        :caption: **Browse historical changes.** Use ``:DiffviewFileHistory`` with a path to list one file's commits, open a commit's diff, then omit the path to explore repository-wide history.

.. list-table::
    :header-rows: 1
    :align: left

    * - command
      - description

    * - ``:DiffviewOpen``
      - Opens the viewer

    * - ``:DiffviewFileHistory``
      - Views diffs for this file throughout git history


.. plugin-metadata::
   :name: diffview


.. _gitsigns_ref:

``gitsigns.nvim``
~~~~~~~~~~~~~~~~~

`gitsigns <https://github.com/lewis6991/gitsigns.nvim>`_ shows a "gutter" along
the left side of the line numbers, indicating where there were changes in
a file. Only works in git repos.

Since you can stage and make commits with this plugin, it is in a way redundant
with vim-fugitive. I find fugitive to be more useful when making commits across
multiple files, and gitsigns to be more useful in showing what's changed while
still editing a file.

Most commands require being in a hunk. Keymappings use :kbd:`<leader>h`.
Mnemonic: [h]unk (the term for a block of changes).

.. details:: Screencasts
    :class: screencasts

    .. asciinema:: screencasts/casts/gitsigns.cast
        :preload:
        :poster: npt:5
        :caption: **Inspect changes in place.** Follow gutter signs with :kbd:`]h` and :kbd:`[h`, preview the current hunk without leaving the file, and select a hunk using the ``ih`` text object.

    .. asciinema:: screencasts/casts/gitsigns2.cast
        :preload:
        :poster: npt:5
        :caption: **Stage from the editing buffer.** Stage a hunk, undo that staging operation, then stage only selected lines. Finish by staging the remaining changes in the buffer.

.. list-table::
    :header-rows: 1
    :align: left

    * - command
      - description

    * - :kbd:`[h`
      - Jumps to previous change (hunk) in the file

    * - :kbd:`]h`
      - Jumps to next change (hunk) in the file

    * - :kbd:`<leader>hp`
      - Previews hunk: opens floating window showing the diff for the current
        change. Move away (j/k) to close

    * - :kbd:`<leader>hs`
      - Stages hunk: marks the current change to be included in next commit. In
        visual mode, stages only selected lines

    * - :kbd:`<leader>hr`
      - Resets hunk: discards the current change, reverting to what's in git. In
        visual mode, resets only selected lines

    * - :kbd:`<leader>hu`
      - Undoes staging: unstages a previously staged hunk

    * - :kbd:`<leader>hS`
      - Stages entire buffer: marks all changes in the current file for commit

    * - :kbd:`<leader>hR`
      - Resets entire buffer: discards all changes in the current file

    * - :kbd:`<leader>hb`
      - Shows git blame info for current line in a floating window (who changed
        it, when, commit message)

    * - :kbd:`<leader>hd`
      - Opens diff mode showing side-by-side comparison of current file vs git
        version


Additionally, this supports hunks as text objects using ``ih`` (inside hunk).
For example, select a hunk with :kbd:`vih`, or delete a hunk with :kbd:`dih`.

.. plugin-metadata::
   :name: gitsigns

.. _gv_ref:

``gv.vim``
~~~~~~~~~~

`gv.vim <https://github.com/junegunn/gv.vim>`_ provides an interface to easily
view and browse git history.

It's simpler than :ref:`diffview_ref` which can be helpful sometimes.

.. details:: Screencast
    :class: screencasts

    .. asciinema:: screencasts/casts/gv.cast
        :preload:
        :poster: npt:5
        :caption: **Explore the commit graph.** Open ``:GV`` to browse branches and merge commits, inspect a commit's patch with Enter, then run it on a visual selection to narrow history to a particular block.

.. list-table::
    :header-rows: 1
    :align: left

    * - command
      - description

    * - ``:GV`` in visual mode
      - Shows commits affecting selection

    * - ``:GV``
      - Opens a commit browser, hit :kbd:`Enter` on a commit to view

.. plugin-metadata::
   :name: gv


.. _mergetool_ref:

``vim-mergetool``
~~~~~~~~~~~~~~~~~

`vim-mergetool <https://github.com/samoshkin/vim-mergetool>`_ makes 3-way merge
conflicts much easier to deal with by only focusing on what needs to be
manually edited, while allowing enough flexibility in configuration to
reproduce default behaviors.

.. details:: Screencast
    :class: screencasts

    .. asciinema:: screencasts/casts/vim-mergetool.cast
        :preload:
        :poster: npt:5
        :caption: **Resolve conflicts one hunk at a time.** Start the focused merge view, navigate unresolved hunks, accept an incoming change with ``:diffget`` while keeping another local, then save and stop the merge tool.

.. note::

    You'll need to set the following in your .gitconfig::

        [merge]
        conflictStyle = diff3

.. list-table::
    :header-rows: 1
    :align: left

    * - command
      - description

    * - ``:MergetoolStart``
      - Starts the tool

    * - ``:diffget``
      - Pulls "theirs" (that is, assume the remote is correct)

    * - :kbd:`do`, :kbd:`dp`
      - Uses vim's built-in diff operations

Save and quit, or use ``:MergetoolStop``.

.. plugin-metadata::
   :name: vim-mergetool


LSP-related
+++++++++++

.. contents::
   :local:
   :depth: 1
   :backlinks: none

The Language Server Protocol lets an editor like neovim communicate with
a language server. A language server is installed per language (e.g., Python,
Bash, etc.), which knows a LOT about the language, and supports things like:

- advanced autocomplete
- advanced highlighting
- going to definitions or references (e.g., find where a function is
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
default; start it with :kbd:`<leader>cl`.

.. note::

   These dotfiles use the native LSP configuration API and require nvim 0.12
   or newer.


.. _nvimlspconfig_ref:

``nvim-lspconfig``
~~~~~~~~~~~~~~~~~~

`nvim-lspconfig <https://github.com/neovim/nvim-lspconfig>`_ supplies default
language server configurations. These dotfiles use nvim's native
``vim.lsp.config`` and ``vim.lsp.enable`` APIs to configure and enable them.

.. note::

   You'll probably need to install NodeJS to install language servers with ``:Mason`` (see :ref:`mason_ref`):

  .. code-block:: bash

     ./setup.sh --install-npm  # install nodejs into conda env

Start the language server with :kbd:`<leader>cl` to use its features.
Custom commands use :kbd:`<leader>c` as the prefix. Mnemonic: [c]ode.
In nvim 0.11+, the `default keymaps
<https://neovim.io/doc/user/lsp.html#gra>`__ for LSP commands use the built-in
:kbd:`gr` prefix; the mnemonics below describe only the final key.


.. details:: Screencasts
    :class: screencasts

    .. asciinema:: screencasts/casts/nvim-lspconfig.cast
        :preload:
        :poster: npt:5
        :caption: **Start the LSP and read diagnostics.** Attach pyright and ruff to a Python buffer, jump between problems, expand a diagnostic message, toggle inline diagnostic text, and inspect hover documentation.

    .. asciinema:: screencasts/casts/nvim-lspconfig2.cast
        :preload:
        :poster: npt:5
        :caption: **Navigate and rename across files.** Jump to a function's definition with :kbd:`Ctrl-]`, list its references with :kbd:`grr`, rename it with :kbd:`grn`, and check both edited files before saving.

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
    * - :kbd:`Ctrl-]`
      - Jumps to where the symbol under cursor is defined (e.g., function
        definition, class declaration), even in another file. :kbd:`Ctrl-o`
        jumps back
    * - :kbd:`grt`
      - Jumps to the definition of the *type* of the symbol under cursor (e.g.,
        the class of a variable). Mnemonic: [t]ype
    * - :kbd:`K`
      - Shows hover documentation for the symbol under cursor in a floating
        window (function signature, docstring, type info)
    * - :kbd:`grn`
      - Renames all instances of the symbol under cursor throughout the project.
        Opens prompt for new name. Mnemonic: [n]ame
    * - :kbd:`grr`
      - Opens list of all places where the symbol under cursor is referenced.
        Select one to jump to it. Mnemonic: [r]eferences
    * - :kbd:`gra`
      - Opens menu of available code actions for current context (quick fixes,
        refactorings, imports). Mnemonic: [a]ction

.. plugin-metadata::
   :name: nvim-lspconfig

.. _mason_ref:

``mason.nvim``
~~~~~~~~~~~~~~

`mason.nvim <https://github.com/williamboman/mason.nvim>`_ easily installs
language servers, debuggers, linters, and formatters. Use ``:Mason``
to open the interface, and hit :kbd:`i` on what you want to install, or
:kbd:`g?` for more help.

The tool list lives in :file:`~/.config/nvim/lua/plugins/mason.lua`.
Use ``:MasonInstallConfigured`` to install missing tools or
``:MasonUpdateConfigured`` to install and update them. Both commands block until
finished and check for missing packages. They can also run headlessly::

    nvim --headless '+MasonInstallConfigured' '+qa'
    nvim --headless '+MasonUpdateConfigured' '+qa'

If you want to browse other options, use ``:Mason`` which gives an interactive
menu (see keymaps below). If you decide to keep something, consider adding it
to your :file:`~/.config/nvim/lua/plugins/mason.lua` so it will be installed
the next time you set up dotfiles.

.. note::

  Many language servers use the npm (javascript package manager) to install.
  This is the case for ``pyright``, for example. You can use ``./setup.sh
  --install-npm`` to easily create a conda env with npm and add its bin dir to
  your ``$PATH``.

The configured language tools include ``pyright`` and ``ruff`` for Python,
``lua-language-server`` for Lua (nvim-lspconfig calls this ``lua_ls``),
``bash-language-server``, ``yaml-language-server``, and
``ansible-language-server``. For R, :ref:`rnvim_ref` provides its own ``r_ls``,
so a separate ``r-languageserver`` installation isn't needed for that workflow.

On older Linux systems, set ``OLD_GLIBC`` before starting nvim. The configured
installer skips entries marked ``skip_on_old_glibc`` (currently ``stylua`` and
``tree-sitter-cli``), whose prebuilt binaries may require newer glibc. Install
compatible versions yourself; see :ref:`treesitter_ref` for the HPC workflow.

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
      - Installs the selected language server or tool


.. plugin-metadata::
   :name: mason

.. _trouble_ref:

``trouble.nvim``
~~~~~~~~~~~~~~~~

`trouble.nvim <https://github.com/folke/trouble.nvim>`_ organizes all the LSP
diagnostics into a single window. You can use that to navigate the issues found
in your code.

This only works if you've started the LSP for the buffer with :kbd:`<leader>cl` (see :ref:`nvimlspconfig_ref`).

The alternative is using :kbd:`[d` and :kbd:`]d` to move between diagnostics
(see :ref:`nvimlspconfig_ref`) but it's nice to get an overview with this
plugin.

.. details:: Screencast
    :class: screencasts

    .. asciinema:: screencasts/casts/trouble.cast
        :preload:
        :poster: npt:5
        :caption: **Survey project diagnostics.** Open trouble's bottom panel with :kbd:`<leader>ct`, see problems grouped by file, move through entries, and press Enter to jump to the corresponding source line.

.. list-table::
    :header-rows: 1
    :align: left

    * - command
      - description
    * - :kbd:`<leader>ct`
      - Toggles trouble.nvim diagnostic window at bottom of screen, showing all
        LSP errors/warnings in your project. Navigate with j/k, Enter to jump to
        issue, q to close (or :kbd:`<leader>ct` again)

.. plugin-metadata::
   :name: trouble

.. _conform_ref:

``conform.nvim``
~~~~~~~~~~~~~~~~

`conform <https://github.com/stevearc/conform.nvim>`__ runs style formatters on
the current buffer.

For example, if ``black`` is available it will run that on the code, but in
a way that the changes can be undone (in contrast to running ``black``
manually on the file, which overwrites it).

.. details:: Screencast
    :class: screencasts

    .. asciinema:: screencasts/casts/conform.cast
        :preload:
        :poster: npt:5
        :caption: **Format Python without leaving the editor.** Run the configured ruff and black formatters with :kbd:`<leader>cf`, then undo and redo the formatting as ordinary buffer edits without writing the file.

.. list-table::
    :header-rows: 1
    :align: left

    * - command
      - description

    * - :kbd:`<leader>cf`
      - Runs configured formatter on buffer. Mnemonic: [c]ode [f]ormat

You can install formatters via :ref:`mason_ref`.

For example, for Python I have ``ruff`` and ``black``; for Lua, ``stylua``; for
bash, ``shfmt``. See the config file for the other configured formatters and
how to set this up.

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
   :depth: 1
   :backlinks: none

.. _telescope_ref:

``telescope.nvim``
~~~~~~~~~~~~~~~~~~

`Telescope <https://github.com/nvim-telescope/telescope.nvim>`_ provides
a floating window with fuzzy-search selection.

Searching and selecting what, you ask? Pretty much anything you hook it up to.

Type in the text box to filter the list. Hit enter to select (and open the
selected file in a new buffer). Hit Esc twice to exit.

.. details:: Screencasts
    :class: screencasts

    .. asciinema:: screencasts/casts/telescope.cast
        :preload:
        :poster: npt:5
        :caption: **Find a file by name.** Open Telescope with :kbd:`<leader>ff`, narrow the current directory's file list by typing ``setup``, move between matches, and press Enter to open a result.

    .. asciinema:: screencasts/casts/telescope2.cast
        :preload:
        :poster: npt:5
        :caption: **Search text across files.** Launch live grep with :kbd:`<leader>fg`, search for ``python``, browse matching lines with the arrow keys, and open a hit at its source location.

    .. asciinema:: screencasts/casts/telescope3.cast
        :preload:
        :poster: npt:5
        :caption: **Search the current buffer.** Use :kbd:`<leader>/` to find ``conda``, move through matches while the preview shows their surrounding context, then press Enter to jump to the selected line.

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
      - Searches directory for string. This is like using ripgrep, but in vim.
        Selecting entry takes you right to the line

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

``nvim-tree.lua``
~~~~~~~~~~~~~~~~~

`nvim-tree <https://github.com/nvim-tree/nvim-tree.lua>`__ provides a filesystem tree for browsing.

.. details:: Screencast
    :class: screencasts

    .. asciinema:: screencasts/casts/nvim-tree.cast
        :preload:
        :poster: npt:5
        :caption: **Browse files and manage staging.** Open the tree with :kbd:`<leader>fb`, expand directories and open files, switch focus between browser and editor, then stage and unstage a file with :kbd:`ga` and :kbd:`gu`.

.. list-table::
    :header-rows: 1
    :align: left

    * - command
      - description

    * - :kbd:`<leader>fb`
      - Toggles file browser sidebar showing directory tree. Navigate with j/k,
        Enter to open files/folders, q to close

    * - :kbd:`-` (within browser)
      - Navigates up one directory level

    * - :kbd:`Enter` (within browser)
      - Opens file in editor, expands directory to show contents, or collapses
        open directory

    * - :kbd:`ga` (within browser)
      - Adds file to git. Useful when you have fugitive also open, and want to
        add a file from an as-yet-untracked directory

    * - :kbd:`gu` (within browser)
      - Unstages file. Useful when you have fugitive also open

The window-switching shortcuts :kbd:`<leader>w` and :kbd:`<leader>q` (move to
windows left and right respectively; see :ref:`toggleterm_ref`) also work.

.. plugin-metadata::
   :name: nvim-tree

.. _whichkey_ref:

``which-key.nvim``
~~~~~~~~~~~~~~~~~~

`which-key <https://github.com/folke/which-key.nvim>`_ displays a popup with
possible key bindings of the command you started typing. This is wonderful for
discovering commands you didn't know about, or have forgotten.

The window will appear 1 second after pressing a key. For example, try pressing
the leader key (:kbd:`,`) and waiting a second to see all the keys you can
press after the leader and what the behavior will be.

The length of this delay is configured with ``vim.o.timeoutlen``, e.g.,
``vim.o.timeoutlen=500`` for half a second. There is no timeout though for
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

.. details:: Screencast
    :class: screencasts

    .. asciinema:: screencasts/casts/which-key.cast
        :preload:
        :poster: npt:5
        :caption: **Discover a mapping interactively.** Press the leader key and pause to see named command groups, follow a prefix into its submenu, use Backspace to return, and dismiss the menu with Escape.

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
     - Shows a popup menu after 1 second

   * - :kbd:`<Backspace>`
     - Goes back a menu

   * - :kbd:`z=` (over a word)
     - Shows popup with spelling suggestions, use indicated character to select

   * - :kbd:`'`
     - Shows popup with list of marks

   * - :kbd:`"`
     - Shows popup with list of registers

.. plugin-metadata::
   :name: which-key


.. _aerial_ref:

``aerial.nvim``
~~~~~~~~~~~~~~~

`aerial <https://github.com/stevearc/aerial.nvim>`_ provides a navigation
sidebar for quickly moving around code (for example, jumping to functions or
classes or methods). For markdown or reStructuredText, it acts like a table of
contents.

.. details:: Screencast
    :class: screencasts

    .. asciinema:: screencasts/casts/aerial.cast
        :preload:
        :poster: npt:5
        :caption: **Navigate a file by structure.** Open aerial's outline of Python classes, methods, and functions, press Enter to jump to a symbol, then use :kbd:`{` and :kbd:`}` to move between symbols from the main buffer.


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
      - Jumps to previous (``{``) or next (``}``) code item in the buffer (function,
        class, snakemake rule, markdown section)

For navigating complex codebases, there are other keys that are automatically
mapped, which you can read about in the `README for aerial
<https://github.com/stevearc/aerial.nvim>`_.

.. plugin-metadata::
   :name: aerial

.. _punchlist_ref:

``punchlist.nvim``
~~~~~~~~~~~~~~~~~~

`punchlist <https://github.com/daler/punchlist.nvim>`__ is a plugin to make
annotations on files, like using comments in Google Docs or Microsoft Word. The
annotations are stored in a hidden directory in the repo, but are visually
attached to text in a buffer.

Annotations move with the text that you edit, and can be cut-and-paste if
editing is too disruptive to track position automatically.

A summary can be shown that can be pasted into LLM agents to direct them right
to the files and lines of interest.

The keymaps use the ``<localleader>``, by default :kbd:`\\`.

.. details:: Screencast
    :class: screencasts

    .. asciinema:: screencasts/casts/punchlist.cast
        :preload:
        :poster: npt:5
        :caption: **Collect review notes without changing the code.** Attach DISCUSS and FIX notes to lines or selections, watch them follow edits, move a note with cut and paste, then compile the notes into a prompt with file and line references.

.. list-table::
    :header-rows: 1
    :align: left

    * - command
      - description

    * - :kbd:`<localleader>pd`
      - Adds a DISCUSS annotation

    * - :kbd:`<localleader>pf`
      - Adds a FIX annotation

    * - :kbd:`<localleader>ps`
      - Shows the list of all annotations, ready to copy

    * - :kbd:`<localleader>px`
      - Cuts an annotation

    * - :kbd:`<localleader>pv`
      - Pastes an annotation on current line/selection

    * - :kbd:`<localleader>pr`
      - Re-anchors an annotation

    * - :kbd:`<localleader>pc`
      - Clears all annotations in repo (asks for confirmation)

.. plugin-metadata::
   :name: punchlist


Visuals
+++++++

These plugins add various visual enhancements to nvim.

.. contents::
   :local:
   :depth: 1
   :backlinks: none

.. _bufferline_ref:

``bufferline.nvim``
~~~~~~~~~~~~~~~~~~~

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

``beacon.nvim``
~~~~~~~~~~~~~~~

`Beacon <https://github.com/danilamihailov/beacon.nvim>`_ provides an animated
marker to show where the cursor is.

.. list-table::
    :header-rows: 1
    :align: left

    * - command
      - description

    * - :kbd:`n` or :kbd:`N` after search
      - Flashes beacon at search hit

.. plugin-metadata::
   :name: beacon

.. _lualine_ref:

``lualine.nvim``
~~~~~~~~~~~~~~~~

`lualine <https://github.com/nvim-lualine/lualine.nvim>`_ provides the status line along the bottom.

No additional commands configured, but see the homepage for all the things you
can add to it.

.. plugin-metadata::
   :name: lualine

.. _indentblankline_ref:

``indent-blankline.nvim``
~~~~~~~~~~~~~~~~~~~~~~~~~

`indent-blankline <https://github.com/lukas-reineke/indent-blankline.nvim>`_
shows vertical lines where there is indentation, and highlights one of these
vertical lines to indicate the current `scope
<https://en.wikipedia.org/wiki/Scope_(computer_science)>`_.

No additional commands configured. However, depending on the font you use, you
may want to play around with the symbol used.

.. plugin-metadata::
   :name: indent-blankline

.. _rendermarkdown_ref:

``render-markdown.nvim``
~~~~~~~~~~~~~~~~~~~~~~~~

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

.. details:: Screencast
    :class: screencasts

    .. asciinema:: screencasts/casts/render-markdown.cast
        :preload:
        :poster: npt:5
        :caption: **Switch between reading and editing Markdown.** See rendered headings, links, checkboxes, tables, and code blocks; move onto a line or enter insert mode to reveal the source, and toggle rendering with :kbd:`<leader>rm`.

.. list-table::
    :header-rows: 1
    :align: left

    * - command
      - description

    * - :kbd:`<leader>rm`
      - Toggles rendering in RMarkdown buffers by switching the filetype between
        ``rmarkdown`` and ``markdown`` and disabling or enabling RenderMarkdown.
        Only mapped in RMarkdown buffers. Mnemonic: [r]ender [m]arkdown

.. plugin-metadata::
   :name: render-markdown

.. _nvimcolorizer_ref:

``nvim-colorizer.lua``
~~~~~~~~~~~~~~~~~~~~~~

`nvim-colorizer <https://github.com/norcalli/nvim-colorizer.lua>`__ is
a high-performance color highlighter. It converts hex codes to their actual
colors.

.. list-table::
    :header-rows: 1
    :align: left

    * - command
      - description

    * - ``:ColorizerToggle``
      - Toggles colorizing of hex codes

.. plugin-metadata::
   :name: nvim-colorizer

.. _lush_ref:

``lush.nvim``
~~~~~~~~~~~~~

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
   :depth: 1
   :backlinks: none

.. _vimcommentary_ref:

``vim-commentary``
~~~~~~~~~~~~~~~~~~

`vim-commentary <https://github.com/tpope/vim-commentary>`_ lets you easily
toggle comments on lines or blocks of code.

.. details:: Screencast
    :class: screencasts

    .. asciinema:: screencasts/casts/vim-commentary.cast
        :preload:
        :poster: npt:5
        :caption: **Toggle comments without changing the code.** Use :kbd:`gcc` for a line and :kbd:`gc` for a visual selection, then repeat to uncomment.


.. list-table::
    :header-rows: 1
    :align: left

    * - command
      - description

    * - :kbd:`gc` on a visual selection
      - Toggles comments

    * - :kbd:`gcc` on a single line
      - Toggles comments

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
      - Increases vertical scroll speed while held

.. plugin-metadata::
   :name: accelerated-jk

.. _blink_ref:

``blink.cmp``
~~~~~~~~~~~~~

`blink <https://github.com/Saghen/blink.cmp>`__ offers autocomplete.


In this config, I've chosen to mimic the bash style of completion,
the commands documented here reflect that. I've also disabled the menu popping
up all the time. There are a lot of ways you can customize this yourself though
-- see the `blink docs <https://cmp.saghen.dev/>`__.

.. details:: Screencast
    :class: screencasts

    .. asciinema:: screencasts/casts/blink.cast
        :preload:
        :poster: npt:5
        :caption: **Completion when you ask for it.** Open and navigate suggestions with :kbd:`Tab`, accept with :kbd:`Enter`, and try filesystem and command-line completion.

.. list-table::
    :header-rows: 1
    :align: left

    * - command
      - description

    * - :kbd:`<C-space>`
      - Opens completion menu

    * - :kbd:`<Tab>` (when typing and the cursor is in a word)
      - Opens completion menu

    * - :kbd:`<Tab>`, :kbd:`<Shift-Tab>` (in menu)
      - Selects next or previous entry

    * - :kbd:`Enter` (when menu visible)
      - Accepts selected entry

    * - up/down arrow (in menu)
      - Selects next or previous entry

.. plugin-metadata::
   :name: blink

.. _treesitter_ref:

``nvim-treesitter``
~~~~~~~~~~~~~~~~~~~

`treesitter <https://github.com/nvim-treesitter/nvim-treesitter>`__ is a parsing
library that underpins many other plugins.

You install a parser for a language, and it figures out which tokens
are functions, classes, variables, modules, etc. Then it's up to other plugins
to do something with that. For example, colorschemes can use that information,
or you can select text based on its semantic meaning within the programming
language (like easily select an entire function, or the body of a for-loop).

Things have been changing recently in the treesitter-related world. This config
now uses the ``main`` branch, which requires nvim 0.12+, ``tree-sitter-cli``
0.26.1+, and a C compiler.

- On a Mac, the compiler may need XCode Command Line Tools to be installed.
- A fresh Ubuntu installation will need ``sudo apt install build-essential``
- RHEL/Fedora will need ``sudo dnf install 'Development Tools'`` (and may need
  the `EPEL repo <https://docs.fedoraproject.org/en-US/epel/>`__ enabled).
- Alternatively, if you don't have root access, you can install `compiler
  packages via conda
  <https://docs.conda.io/projects/conda-build/en/stable/resources/compiler-tools.html>`_.

We have to be a little careful when using this on a system with old glibc, like
many HPC systems. In such cases, you need to manually compile
``tree-sitter-cli`` and put it on your path first. If you are running on newer
Linux or macOS, you can use::

    :MasonInstall tree-sitter-cli

To install the configured parsers, run ``./setup.sh --nvim-treesitter-parsers``
or ``nvim --headless '+TSInstallConfigured' '+qa'`` (the former calls the
latter).

Parsers are stored in nvim-treesitter's
default :file:`~/.local/share/nvim/site/parser` directory. Use
``:checkhealth nvim-treesitter`` to check the installed parsers.

Alternatively, remove parsers from the ``parsers`` table in
:file:`~/.config/nvim/lua/plugins/treesitter.lua`; removed languages will not
have treesitter-enabled syntax highlighting. ``:TSInstallConfigured`` warns about
installed parsers absent from this table, including their paths; it does not
delete them.

.. details:: Screencast
    :class: screencasts

    .. asciinema:: screencasts/casts/treesitter.cast
        :preload:
        :poster: npt:5
        :caption: **Select code by syntax structure.** Start with :kbd:`<leader>cs`, expand with :kbd:`Tab`, shrink with :kbd:`Shift-Tab`, and edit the selected code.

.. list-table::
    :header-rows: 1
    :align: left

    * - command
      - description

    * - :kbd:`<leader>cs`
      - Starts incremental selection

    * - :kbd:`<Tab>` (in incremental selection)
      - Increases selection by node

    * - :kbd:`<S-Tab>` (in incremental selection)
      - Decreases selection by node

.. plugin-metadata::
   :name: treesitter

.. _toggleterm_ref:

``toggleterm.nvim``
~~~~~~~~~~~~~~~~~~~

`ToggleTerm <https://github.com/akinsho/toggleterm.nvim>`_ lets you easily
interact with a terminal within vim.

The greatest benefit of this is that you can send text from a text buffer
(Python script, RMarkdown file, etc) over to a terminal. Because these mappings
send text to an ordinary terminal rather than managing a particular REPL, the
workflow is language-agnostic: the same editor commands can drive R, IPython,
or another interactive program. This lets you reproduce an IDE-like
environment purely from the terminal. The following commands are custom
mappings set in :file:`.config/nvim/lua/plugins/toggleterm.lua` that affect the
terminal use.

.. details:: Screencasts
    :class: screencasts

    .. asciinema:: screencasts/casts/toggleterm.cast
        :preload:
        :poster: npt:5
        :caption: **The terminal is just a shell.** Open and hide a terminal split with :kbd:`<leader>t`, hop between it and the text buffer with :kbd:`<leader>q` / :kbd:`<leader>w`, and send the current line with :kbd:`gxx` or a visual selection with :kbd:`gx`.

    .. asciinema:: screencasts/casts/toggleterm2.cast
        :preload:
        :poster: npt:5
        :caption: **Same keys, any REPL.** Start IPython in the terminal and send a line, then a whole function with its blank line and indentation intact, then call it.

    .. asciinema:: screencasts/casts/toggleterm3.cast
        :preload:
        :poster: npt:5
        :caption: **Send RMarkdown chunks.** Start R in the terminal, then use :kbd:`<leader>cd` to send the current chunk and advance to the next one.

.. note::

    The terminal will jump to insert mode when you switch to it (either using
    keyboard shortcuts or mouse), but **clicking the mouse a second time will
    enter visual mode**, just like in a text buffer. This can get confusing if
    you're not expecting it.

    You can either click to the text buffer and immediately back in the
    terminal, or use :kbd:`a` or :kbd:`i` in the terminal to get back to insert
    mode.

    Starting from 2026-05-07, when the terminal is not in insert mode, the
    terminal-specific cursorline will be a different color to help indicate the
    status.

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

    * - :kbd:`gxx`
      - Sends the current line under cursor to the terminal and executes it.
        For Python, preserves indentation and clears IPython's auto-indent
        before sending; other filetypes use the ordinary current-line send

    * - :kbd:`gx`
      - Sends the currently selected text (visual mode) to the terminal and
        executes it. For Python only, uses a single `bracketed paste
        <https://en.wikipedia.org/wiki/Bracketed-paste>`_ so blank lines and
        indentation survive rather than being interpreted as end-of-block by
        IPython. Other filetypes use ``:ToggleTermSendVisualSelection`` to send
        line by line, trimming whitespace, since other shells and REPLs may not
        support bracketed paste

    * - :kbd:`<leader>cd`
      - Sends the current RMarkdown code chunk to terminal for execution, then
        automatically jumps cursor to the next chunk. Great for interactive data
        analysis

    * - :kbd:`<leader>k` (in RMarkdown file)
      - Renders the current RMarkdown file to HTML using ``rmarkdown::render()``.
        Requires rmarkdown installed and R running in terminal

    * - :kbd:`<leader>k` (in Python file)
      - Runs the current Python script in IPython using ``%run`` magic command.
        Requires IPython running in terminal

.. plugin-metadata::
   :name: toggleterm


.. _vimdiffenhanced_ref:

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

    * - ``:EnhancedDiff <algorithm>``
      - Configures the diff algorithm to use, see below table

The following algorithms are available:

.. list-table::
    :header-rows: 1
    :align: left

    * - algorithm
      - description

    * - myers
      - Default diff algorithm

    * - default
      - Alias for ``myers``

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
easy formatting of tables in Markdown and reStructuredText

Nice Markdown and reStructuredText tables are a pain to format. This plugin
makes it easy, by auto-padding table cells and adding the header lines as
needed.

* With table mode enabled, :kbd:`||` on a new line to start the header.
* Type the header, with column names separated by :kbd:`|`.
* On a new line, use :kbd:`||` to fill in the header underline.
* On subsequent rows, delimit fields by :kbd:`|` (including a leading and trailing :kbd:`|`)
* Complete the table with :kbd:`||` on a new line.

.. details:: Screencast
    :class: screencasts

    .. asciinema:: screencasts/casts/vim-table-mode.cast
        :preload:
        :poster: npt:5
        :caption: **Create and repair Markdown tables.** Type pipe-separated rows that align as you go, turn selected CSV into a table with ``:Tableize``, add a header separator, and repair ragged edits with ``:TableModeRealign``.

.. list-table::
    :header-rows: 1
    :align: left

    * - command
      - description

    * - ``:TableModeEnable``
      - Enables table mode, which makes on-the-fly adjustments to table cells
        as they're edited

    * - ``:TableModeDisable``
      - Disables table mode

    * - ``:Tableize``
      - Creates a markdown or reStructuredText table based on TSV or CSV text

    * - ``:TableModeRealign``
      - Realigns an existing table, adding padding as necessary

.. plugin-metadata::
   :name: vim-table-mode

.. _flash_ref:

``flash.nvim``
~~~~~~~~~~~~~~

`flash <https://github.com/folke/flash.nvim>`__ lets you jump around in
a buffer with low mental effort.

The trick is to *keep your eyes on the destination*. Hit :kbd:`s`, and type the
first 2 letters of where you're trying to go. This plugin will dim the rest of
the buffer, only highlighting instances where those 2 letters occur. It will
also add a *third* letter after it. If you type that third letter, the cursor will
jump to that location.

Alternatively, if a treesitter parser is installed for this filetype, you can
use :kbd:`S` and suffix letters will be shown at different levels of the syntax
tree. For example inside a for-loop (i.e. don't include the ``for``); outside
a for-loop (including the ``for``), an entire function, entire Rmd code chunk,
etc. In this mode, which is just for selection, you don't type the two
characters you're looking for. Instead you just type the letter corresponding to
level of code that you want to select.

.. details:: Screencasts
    :class: screencasts

    .. asciinema:: screencasts/casts/flash.cast
        :preload:
        :poster: npt:5
        :caption: **Jump to a visible destination.** Press :kbd:`s`, type the start of the target text, then choose a one-letter match label to reach a method without counting lines or repeating searches.

    .. asciinema:: screencasts/casts/flash2.cast
        :preload:
        :poster: npt:5
        :caption: **Select syntax nodes and repeat character jumps.** Use :kbd:`S` to label enclosing Treesitter nodes and select an entire class, then use flash-enhanced :kbd:`f` motions to jump between highlighted character matches.

.. list-table::
    :header-rows: 1
    :align: left

    * - command
      - description

    * - :kbd:`s` in normal mode
      - Jumps to match (see details)

    * - :kbd:`S` in normal mode
      - Selects this treesitter node (see details)

    * - :kbd:`Ctrl-s` when searching
      - Toggles flash during search

.. plugin-metadata::
   :name: flash

.. _vimsurround_ref:

``vim-surround``
~~~~~~~~~~~~~~~~

`vim-surround <https://github.com/tpope/vim-surround>`_ lets you easily change
surrounding characters.

.. details:: Screencast
    :class: screencasts

    .. asciinema:: screencasts/casts/vim-surround.cast
        :preload:
        :poster: npt:5
        :caption: **Edit the delimiters, not the text inside.** Add quotes around a word, change the surrounding pair, and remove it again.

.. list-table::
    :header-rows: 1
    :align: left

    * - command
      - description

    * - :kbd:`cs"'`
      - Changes surrounding ``"`` to ``'``

    * - :kbd:`csw}`
      - Adds ``{`` and ``}`` surrounding word

    * - :kbd:`csw{`
      - Adds surrounding braces with a space inside

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

.. details:: Screencast
    :class: screencasts

    .. asciinema:: screencasts/casts/vis.cast
        :preload:
        :poster: npt:5
        :caption: **Limit a substitution to the selected block.** Compare a line-range substitution with ``:B``, changing the group column while leaving identical text in the note column untouched.

.. list-table::
    :header-rows: 1
    :align: left

    * - command
      - description
    * - :kbd:`<C-v>`, then use ``:B`` instead of :kbd:`:`
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


The mapped commands below use :kbd:`<leader>o` as a prefix.
Mnemonic: [o]bsidian.

.. list-table::
    :header-rows: 1
    :align: left

    * - command
      - description

    * - :kbd:`Enter` on any link
      - Opens the link in a browser (if http) or opens the file in a new buffer

    * - :kbd:`<leader>od`
      - Chooses or creates a daily note. Mnemonic: [o]bsidian [d]ailies

    * - :kbd:`<leader>os`
      - Searches for notes with ripgrep. Mnemonic: [o]bsidian [s]earch

    * - :kbd:`<leader>ot`
      - Finds occurrences of ``#tagname`` across files in directory.
        Mnemonic: [o]bsidian [t]ags

    * - :kbd:`<leader>on`
      - Makes a link to a new file with a word selected.
        Mnemonic: [o]bsidian [n]ew

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

   * - ``:Browsher``
     - Stores URL on OS clipboard

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

``treesj``
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

.. details:: Screencast
    :class: screencasts

    .. asciinema:: screencasts/casts/treesj.cast
        :preload:
        :poster: npt:5
        :caption: **Expand and collapse code structures.** Toggle a function call, list, and dictionary between single-line and multiline layouts with :kbd:`<leader>j`, keeping arguments and key-value pairs together without changing what the code does.

.. list-table::
    :header-rows: 1
    :align: left

    * - command
      - description

    * - :kbd:`<leader>j`
      - Toggles split/join

.. plugin-metadata::
   :name: treesj

.. _pasteimg_ref:

``pasteimg.nvim``
~~~~~~~~~~~~~~~~~

`pasteimg.nvim <https://github.com/daler/pasteimg.nvim>`__ supports pasting
images to a remote system over SSH by locally converting the image to base64
text on the clipboard.

See the docs for the plugin on how to set it up, including a macOS Shortcut.

.. list-table::
    :header-rows: 1
    :align: left

    * - command
      - description

    * - ``:PasteImgFromPayload`` on a line
      - Converts the base64 text on the line to an image, saves it, and inserts a link to it

.. plugin-metadata::
   :name: pasteimg

.. _rnvim_ref:

``R.nvim``
~~~~~~~~~~

`R.nvim <https://github.com/R-nvim/R.nvim/>`__ provides tight integration with
R running in an nvim terminal.

.. note::

   The existing method of using :ref:`toggleterm_ref` for R (or any other
   terminal) remains the same. This is a new optional method that is specific
   to R, with key mappings deliberately set to be similar to the toggleterm
   method.

   It does need a little more setup though.


R.nvim provides more features than simply running R in an nvim terminal (like
with :ref:`toggleterm_ref`). For example:

- An R object browser. This is like using the object panel in RStudio; you hit
  Enter on an object to view its contents. Very useful for exploring complex
  objects, and way better than ``str()``.
- View a dataframe in Visidata. This is like using ``View()`` in RStudio.
- Help entries open up in a new nvim split, rather than in the R terminal. So
  the terminal remains usable while you're reading the help so you can
  experiment as you read.
- Insert a commented version of output into the text buffer. This is great for
  ``head(df)``: the contents of the data.frame are shown as a comment for nicer
  documentation.
- Tab-completion of functions and arguments within the text buffer, based on
  the running R instance.
- When sending large amounts of text to the R interpreter, lines are
  bundled, only reporting a single line confirmation. This avoids cluttering
  the interpreter.
- Syntax highlighting in the R interpreter
- An R language server that doesn't itself require R
- More flexibility in controlling what is sent to the terminal -- send
  functions, chunks, lines, statements that run across multiple lines, etc.
- Send ``str`` with the name of the object under the cursor for quick inspection in R
- Navigate through an RMarkdown file by chunk
- ``eval=FALSE`` chunks are highlighted as commented text for a visual reminder.
- **Lots** more...

Initial setup
^^^^^^^^^^^^^

.. warning::

    By default, R.nvim will try to grab **all CPUs on the hardware** in order
    to build the tab-completion database. This will crash an interactive node
    on an HPC system. 

    When using an HPC system (like Biowulf), **you must put the following** in your
    :file:`~/.Rprofile`.

    .. code-block:: r

        # This restricts the number of CPUs that can be used by the R.nvim plugin.
        # Needs R.nvim >=0.9.96
        options(nvimcom.max_cpu_cores = max(2, as.numeric(Sys.getenv("SLURM_CPUS_PER_TASK")), na.rm=TRUE))


1. When running on an HPC, add the line above to your :file:`~/.Rprofile`.
2. Activate the environment containing R before starting nvim, then open an
   R or Rmd file. lazy.nvim installs R.nvim at startup; it is configured with
   ``lazy = false`` but **does not load at all if R is not on PATH when nvim
   starts**. Wait for installation to finish, then quit.
3. Follow the instructions below. Note that when first running ``Ropen`` for
   a version of R, you will see notices at the bottom about installing nvimcom
   and setting up tab completions. This process times out after a set number of
   completions, but picks up where it left off the next time. Depending on the
   size of your R environment, it may take opening an R file a few times before
   all completions are installed. You just won't have tab completions for *all*
   installed packages until that process finishes.

Routine usage
^^^^^^^^^^^^^

There are three major differences compared to using toggleterm.

1. Nvim and R must be running on the same host.

   - e.g., activate the environment *before starting nvim* that you want to
     use, on the host you want to use.

   - If you're running R on an interactive node, you need to **run nvim on
     the interactive node** as well. This is different from using toggleterm,
     where you can start nvim on the login node, start a terminal, and log into
     the interactive node from there.

2. Use ``Ropen`` to open files.

   - Don't use ``nvim`` directly to open files.

   - ``Ropen`` starts nvim with the right env vars set. This ``Ropen``
     function is now included in the updated :file:`.functions` file of these
     dotfiles, so make sure you have that. It also uses the ``install-nvimcom``
     function, also from :file:`.functions`.

3. Use :kbd:`<localleader>rf` to start R

   - Don't use :kbd:`<leader>t`, that's just a plain terminal. We want the plugin to
     start R so it can talk to it.

.. details:: What these functions do

   In order for all of this to work, the ``nvimcom`` package needs to be
   installed into the environment with R.

   However, it didn't seem right to "contaminate" an otherwise reproducible
   R environment with a package used only for personal editing preferences.

   In addition, ``nvimcom`` is compiled. The source code lives in this nvim
   plugin, but it needs to be compiled with the exact R version you're using.

   The trick here is that we're compiling it the first time you use it for an
   R version, but storing it in a "sidecar" library outside the main
   R environment. Then we're telling R about that sidecar library only when we
   want to use R.nvim.

   The ``Ropen`` function, now available in :file:`.functions` does the following:

   - checks the version of R on the path (i.e. from an activated environment)
   - check to see if we already have a compiled sidecar library for this version
   - if not, compiles it with the function ``install-nvimcom``, which:

     - pulls the ``nvimcom`` source from the nvim plugin directory
     - compiles it against the R version on the path
     - stores it in :file:`~/R/nvimcom/<X.Y.Z>` (that's the sidecar library)

   - sets the ``R_LIBS_USER`` env var to point to the sidecar library for this
     version of R containing the compiled ``nvimcom``
   - With all that set up, then runs ``nvim <filename>`` to open the file.


R.nvim loads at startup when R is on ``PATH``; its editing behavior and
buffer-local mappings are scoped to R-related filetypes.

R.nvim uses ``<localleader>`` instead of ``<leader>``. This essentially
allows another whole namespace in which to put shortcuts.

By default ``<localleader>`` is ``\`` (backslash).

.. details:: Screencasts
    :class: screencasts

    .. asciinema:: screencasts/casts/r-nvim.cast
        :preload:
        :poster: npt:5
        :caption: **Connect the script to a live R session.** Start R, send lines and selections, and inspect changing objects in the object browser.

    .. asciinema:: screencasts/casts/r-nvim2.cast
        :preload:
        :poster: npt:5
        :caption: **Inspect data and document the results.** Browse the built-in mtcars data frame in VisiData, return to the script, and insert a commented summary below the expression.

Commands that do the same thing as :ref:`toggleterm_ref` (:kbd:`gx`,
:kbd:`gxx`, :kbd:`<leader>cd`, :kbd:`<leader>k`) have been remapped to match
existing toggleterm so you can take advantage of existing muscle memory.
The send mappings (:kbd:`gx`, :kbd:`gxx`, :kbd:`<leader>cd`) fall back to
toggleterm when the R.nvim session isn't ready; the render mapping does not.

.. list-table::
    :header-rows: 1
    :align: left

    * - command
      - description

    * - :kbd:`<localleader>rf`
      - Starts an R session that communicates with nvimcom

    * - :kbd:`gxx` on a line
      - Sends line to R (like :ref:`toggleterm_ref`)

    * - :kbd:`gx` on a selection
      - Sends selection to R (like :ref:`toggleterm_ref`)

    * - :kbd:`<leader>cd`
      - Sends chunk to R (like :ref:`toggleterm_ref`)

    * - :kbd:`<leader>k`
      - Renders RMarkdown to HTML (like :ref:`toggleterm_ref`)

    * - :kbd:`<localleader>ro`
      - Opens R object browser

    * - :kbd:`<localleader>rv` with the cursor on a dataframe variable
      - Opens a new nvim terminal to view the data frame in visidata. ``q``
        quits VisiData; leave terminal mode and use ``:q`` to close the
        remaining terminal window

    * - :kbd:`<localleader>o`
      - Runs the line under the cursor in R, captures the output, and pastes it
        under the cursor -- but commented out. Useful for documenting data
        structures

    * - ``:RMapsDesc``
      - Lists all the other available commands


.. plugin-metadata::
   :name: r-nvim

.. _colorschemes_ref:

Colorschemes
------------

**If colors look broken** then you may be using a terminal like the default
Terminal.app on macOS that does not support true color. See
:ref:`mac-terminal-colors` for how to fix.

For years I've been using the venerable *zenburn* colorscheme. However, now
with additional plugins and highlighting mechanisms (especially treesitter), it
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
   :file: ../.config/nvim/lua/plugins/colorschemes.lua
   :noconfig:

Changelog for ``colorscheme``:

.. plugin-metadata::
   :name: colorscheme
   :file: ../.config/nvim/lua/plugins/colorschemes.lua
   :noconfig:

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

``img-clip.nvim``
~~~~~~~~~~~~~~~~~

.. plugin-metadata::
   :name: img-clip.nvim
   :deprecation: This was only included for a short time; it didn't work on remote systems so I wrote :ref:`pasteimg_ref` and used that instead.


Notes on tried plugins
----------------------

- ``GeorgesAlkhouri/nvim-aider``, when paired with neo-tree, was nice to use for adding files to the context. But now:

  - nvim-aider supports nvim-tree too now
  - aider has gotten better at tab-completion, making it easy to add even deeply-nested files
  - nvim-tree's :kbd:`-` to go up a directory was confusing with neo-tree's "remove from aider context"
  - It's a better experience to just keep aider running in a different tmux pane or window rather than consume nvim screen real estate.

- ``andymass/vim-matchup`` was nice to have (esp for Python) but it caused errors when
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
