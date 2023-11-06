
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
* Unzip it
* Go to the unzipped directory
* Run ``./setup.sh`` to see the help.

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

* Read through :ref:`bash`, :ref:`vim`, and :ref:`tmux` to see how things are set up here
* Browse the dotfiles to look for parts that would be useful for you, and copy them into your own files
* ``./setup.sh --vim-diffs`` may be helpful to you if you're updating
* Use the tool installation commands as-is, but make sure :file:`~/opt/bin` is on your ``$PATH``

The remainder of this documentation will assume you're starting fresh.

.. _setupsection:

2: Setup vim & conda
--------------------
2a: Set a patched terminal font
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Without a patched font, you'll get question mark symbols showing up in many places
in nvim. That's because many of the plugins expect fonts with additional glyphs.

Do this **on the machine running the terminal app.** This is almost always your
local machine. For example, even if you're setting up dotfiles on a remote
cluster, the font is installed on the laptop you're using to connect to that
cluster.

* Manually download and install your favorite font from `nerdfonts.com <https://www.nerdfonts.com/>`_.
* Change your terminal program's preferences to use the new font. *Using
  Terminal on Mac? You'll also need to set the font for non-ASCII characters.*


.. details:: Details

  In `this gif
  <https://raw.githubusercontent.com/wiki/vim-airline/vim-airline/screenshots/demo.gif>`_,
  you can see arrow shapes for buffers, line number glyphs, and so on. To get
  these, you need a patched font, and your terminal needs to be set to use the
  font.

  Skip this step if you don't want those.


2b: neovim
~~~~~~~~~~

Do this if you want to use `neovim <https://neovim.io/>`_. See :ref:`why` for
more help on deciding.

.. code-block::

    ./setup.sh --install-neovim

.. details:: Details

     This installs Neovim to :file:`~/opt/bin`, and then creates an ``alias
     vim=nvim`` in the :file:`~/.aliases` file (which is sourced by
     :file:`~/.bashrc`). This way, whenever you call ``vim``, the alias will
     redirect it to ``nvim``.

     If you want to use actual ``vim``, provide the full path when calling it.
     For example, on many machines it's at :file:`/usr/bin/vim`.


2c: neovim plugin setup
~~~~~~~~~~~~~~~~~~~~~~~

.. note::

  Have you used these dotfiles before? In Oct 2023, the nvim configuration
  changed. Please see :ref:`nvim-lua` for more context, rationale, and details
  on migrating to this new config method.

Plugins are now managed via the `lazy.nvim
<https://github.com/folke/lazy.nvim>`_ manager rather than ``vim-plug`` (as in
previous versions of these dotfiles). Simply opening neovim should be
sufficient to trigger ``lazy.nvim`` to download, install, and configure plugins
automatically.

.. code-block:: bash

  nvim

.. details:: Details

  ``lazy.nvim`` will show progress downloading plugins. Treesitter will also
  automatically install parsers, so you should watch the log on the bottom and
  wait until everything settles down. Then you can quit as normal with
  ``<Esc>:q``.

  If running ``nvim`` didn't work, check that it's on your path. Close and then
  reopen your terminal just to make sure. If you installed with ``./.setup.sh
  --install-neovim``, it put it in ``~/opt/bin/nvim``. Make sure that directory
  is on your PATH by checking:

  .. code-block:: bash

    echo $PATH


.. _setupconda:

2d: conda
~~~~~~~~~

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

    First, this downloads the latest version of `Mambaforge
    <https://github.com/conda-forge/miniforge>`_, and installs conda and mamba
    into :file:`~/mambaforge/condabin`.

    Then it adds the line ``export PATH="$PATH:~/mambaforge/condabin"`` to the
    :file:`~/.path` (which you can read more about at :ref:`bash`).

    If you happen to be on NIH's Biowulf cluster where the home directory is too small to
    support the installation, this will auto-detect that and install instead to
    :file:`/data/$USER/mambaforge/condabin` and add the line ``export
    PATH="$PATH:~/data/$USER/mambaforge/condabin`` to the :file:`~/.path`

    Finally, ``./setup.sh --set-up-bioconda`` sets up the bioconda and
    conda-forge channels in the right way as documented by `Bioconda
    <https://bioconda.github.io>`_.


.. _toolsection:

3: Installing programs
----------------------

The :file:`setup.sh` script has many commands for installing various tools
I find useful. These warrant their own section, so **continue to** :ref:`tools` for
descriptions of tools and the commands to install them.

