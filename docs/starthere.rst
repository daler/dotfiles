
.. _starthere:

Start here
==========

A couple of preliminary things to get out of the way:

* **Everything is driven by** :file:`setup.sh`. When in doubt, consult that
  file.

* **Everything here is simply a convenience** to make life easier setting up
  a new machine. Since I spent the work figuring this out, I might as well make it
  available to others.

* **All steps are optional** though there are some dependencies and assumptions
  which are noted as they come up.

.. details:: Details

    For example:

    * There are some common fixes for things like backspace in vim not working
      in tmux, spaces instead of tabs for Python code, getting the mouse to
      work in vim and tmux, and so on.

    * To avoid visiting each tool's homepage, downloading for Linux or Mac, and
      following the particular installation instructions, you can instead use the
      ``--install-<toolname>`` commands.

    * The ``--vim-diffs`` commands help figure out if all your dotfiles on
      a particular machine are up-to-date with this repo.

    * A centrally available resource for setup and configuration means there's
      only one place to look for updates.

.. _step0:

0: Download and check
---------------------

* Download the latest `zip file <https://github.com/daler/dotfiles/archive/master.zip>`_
* Unzip it and go to the unzipped directory in your terminal
* Run ``./setup.sh`` to see the help.

.. tip::

   Are you setting up a recent Mac? The default shell is ``zsh`` which may cause
   issues. See :ref:`zshmac` for how to change it back to bash.

.. _dotfilessection:

1. Copy over dotfiles
---------------------

There are two paths to take here:

.. _option1:

.. rubric:: **Option 1: start fresh**


- Are you setting up a new machine?
- Have you made a backup of your files and want to try these out?
- Do you want the "batteries included" experience?

Then you should probably start fresh. Do this to create or overwrite existing
files, and then close your terminal and reopen it to use the new configuration:

.. code-block:: bash

    # START FRESH....

    ./setup.sh --dotfiles

    # then close your terminal and re-open

.. details:: Details
    :anchor: dotfiles-details

    The ``./setup.sh --dotfiles`` command copies all dotfiles over to your home
    directory, making a backup of any existing files in case you want to roll
    back. The list of files copied can be found in :file:`include.file`.

    It's important to close and then reopen your terminal so that your terminal
    will load all the new configuration.


.. _option2:

.. rubric:: **Option 2: update existing**

Do this if you already have your own files.

* Read through :ref:`bash`, :ref:`vim`, and :ref:`tmux` to see how things are set up.
* ``./setup.sh --vim-diffs`` may be helpful to you if you're updating. See
  :ref:`working-with-diffs` if you need a refresher for working with diffs.
* Use the tool installation commands as-is, but make sure :file:`~/opt/bin` is on your ``$PATH``

.. code-block:: bash

    # UPDATE EXISTING...

    ./setup.sh --vim-diffs

    # use standard vim diff operations, e.g.
    # ]c, do, dp, :qa

The remainder of this documentation will assume you're starting fresh.

.. _setupsection:

2: Setup vim & conda
--------------------

2a: Set a patched terminal font
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. note::

   If you don't do this, your terminal will display missing glyphs as open
   boxes or question marks, making things look strange.


* Manually download and install your favorite font from `nerdfonts.com
  <https://www.nerdfonts.com/>`_. This needs to be done **on your local
  machine**.

* Install by double-clicking the .ttf files. On Mac, for example, this will
  open the font manager, where you can click the "Install" button.

* Change your terminal program's preferences to use the new font. You're
  looking for a font that includes "Nerd Font". *Using Terminal on Mac? You'll
  also need to set the same font for non-ASCII characters.*


.. details:: Details

  Without a patched font, you'll get question mark symbols showing up in many places
  in nvim. That's because many of the plugins expect fonts with additional glyphs.

  Do this **on the machine running the terminal app** because that's the program
  displaying all the text. This is almost always your local machine. For example,
  even if you're setting up dotfiles on a remote cluster, the font should not be
  installed there. It should be installed on the laptop you're using to connect
  to that cluster.

  In `this gif
  <https://raw.githubusercontent.com/wiki/vim-airline/vim-airline/screenshots/demo.gif>`_,
  you can see arrow shapes for buffers, line number glyphs, and so on. To get
  these, you need a patched font, and your terminal needs to be set to use the
  font.

  Skip this step if you don't want those.


2b: neovim
~~~~~~~~~~


.. note::

  If you are doing this on a system like NIH's Biowulf that has an old version of
  glibc, then you should make sure you have the ``OLD_GLIBC`` environment
  variable set to 1. 

  If you've already copied over your dotfiles, a good place to do this is in :file:`~/.extra`:

  .. code-block:: bash

     # in ~/.extra
     export OLD_GLIBC=1

  And then make sure you source the updated file with ``source ~/.extra`` and
  ensure it shows up with ``echo $OLD_GLIBC`` before proceeding.


Do this if you want to use `neovim <https://neovim.io/>`_. See :ref:`why` for
more help on deciding.

.. code-block:: bash

    ./setup.sh --install-neovim

    # then close and reopen your terminal

.. details:: Details

     This reuses a working release of Neovim on ``PATH`` if its version is at
     least the version pinned in :file:`setup.sh`; otherwise it installs Neovim
     to :file:`~/opt/neovim` with a symlink in :file:`~/opt/bin`. In either case,
     it restores the configured plugins using that executable. Mason tools and
     Treesitter parsers are installed separately after Node/npm are available
     (step 2e below).

     On systems whose glibc is too old for the prebuilt Neovim (e.g., some HPC
     clusters), set ``export OLD_GLIBC=1`` (e.g., in :file:`~/.extra`). Then
     ``--install-neovim`` will reuse a suitable system-provided nvim, but will
     refuse to download one if none is available. Load your Neovim module (or
     add its directory to ``PATH``), then run ``./setup.sh --install-neovim``.
     Provide a system-compatible tree-sitter CLI 0.26.1+ on ``PATH`` and install
     tools and parsers separately as described in step 2e below.

     It then creates an ``alias vim=nvim`` in the :file:`~/.aliases` file
     (which is sourced by :file:`~/.bashrc`). This way, whenever you call ``vim``,
     the alias will redirect it to ``nvim``.

     It's important to close and reopen your terminal, because this
     alias is conditional on finding nvim, and the alias is only created upon
     first starting bash.

     If you want to use actual ``vim``, provide the full path when calling it.
     For example, on many machines it's at :file:`/usr/bin/vim`.


2c: neovim plugin setup
~~~~~~~~~~~~~~~~~~~~~~~

.. note::

  Have you used these dotfiles before? In Oct 2023, the nvim configuration
  changed. Please see :ref:`nvim-lua` for more context, rationale, and details
  on migrating to this new config method.

The ``--install-neovim`` step restores the configured plugin versions with
`lazy.nvim <https://github.com/folke/lazy.nvim>`_. No separate plugin setup step
is needed. It does not install external tools or Treesitter parsers; those are
handled in step 2e after setting up conda and Node/npm.

Plugin restoration requires the nvim config to already be at
:file:`~/.config/nvim`, which is why ``--dotfiles`` comes first in the
recommended order.

.. details:: Details

  If running ``nvim`` after installation does not work, check that it is on
  your path. Close and then reopen your terminal just to make sure. The setup
  command puts it in ``~/opt/bin/nvim``. Make sure that directory is on your
  PATH by checking:

  .. code-block:: bash

    echo $PATH


.. _setupconda:

2d: conda
~~~~~~~~~

.. note::

   If you are setting this up on NIH's Biowulf HPC, then you need to export
   ``CONDA_INSTALLATION_DIR`` to point to a directory with enough space.
   Conda's default of your home directory will break after a little while of
   usage. This is because the home directory quota is fixed on Biowulf and is
   too small to support many conda environments. Your data directory is
   a better option.

   .. code-block:: bash

     # in ~/.extra
     export CONDA_INSTALLATION_DIR=/data/$USER/miniconda

   Then be sure to source this updated file with ``source ~/.extra`` and ensure
   it shows up with ``echo $CONDA_INSTALLATION_DIR`` before proceeding.

`conda <https://docs.conda.io/en/latest/>`_ is a cross-platform,
language-agnostic package manager. It's by far the best way to get set up with
Python, but it also works for many other languages. See :ref:`conda` for some
details on how to activate environments.

.. code-block:: bash

  ./setup.sh --install-conda
  ./setup.sh --set-up-bioconda

.. warning::

    Are you on a Mac with an M1 or M2 chip? You will not be able to install
    packages from Bioconda because packages are not built yet for the Apple
    Silicon architecture.

.. details:: Details

    First, this downloads the latest version of `Miniforge
    <https://github.com/conda-forge/miniforge>`_, and installs conda and mamba
    into :file:`~/miniforge/condabin`.

    Then it adds the line ``export PATH="$PATH:~/miniforge/condabin"`` to the
    :file:`~/.path` (which you can read more about at :ref:`bash`).

    If you happen to be on NIH's Biowulf cluster where the home directory is too small to
    support the installation, then set CONDA_INSTALLATION_DIR to a directory
    with enough space. The installation will auto-detect that and adjust accordingly.

    Finally, ``./setup.sh --set-up-bioconda`` sets up the bioconda and
    conda-forge channels in the right way as documented by `Bioconda
    <https://bioconda.github.io>`_.


2e: neovim tools and Treesitter parsers
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Some Mason tools require Node.js and npm. If these are not already available
on your ``PATH``, install them using conda first:

.. code-block:: bash

    ./setup.sh --install-npm
    source ~/.path

Then install the configured language servers, formatters, and linters with
Mason, followed by the Treesitter parsers:

.. code-block:: bash

    ./setup.sh --nvim-mason-tools
    ./setup.sh --nvim-treesitter-parsers

The Mason step also installs ``tree-sitter-cli``. If ``OLD_GLIBC`` is set,
Mason skips that CLI; put a system-compatible ``tree-sitter`` version 0.26.1+
on your ``PATH`` before installing parsers (for example, via ``module load``).
Treesitter parsers also require a C compiler. See :ref:`treesitter_ref` for
platform-specific prerequisites.

These commands can be rerun independently to install/update tools or parsers
without reinstalling Neovim.


3: Post-installation
--------------------

Now that the files are copied, see :ref:`postinstall` for some next steps to
take, like setting up SSH keys, macOS-specific tweaks, git config, and more.

.. _toolsection:

4: Installing programs
----------------------

The :file:`setup.sh` script has many commands for installing various tools
I find useful. These warrant their own section, so **continue to** :ref:`tools` for
descriptions of tools and the commands to install them.
