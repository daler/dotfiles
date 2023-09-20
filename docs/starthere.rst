
.. _starthere:

Start here
==========

A couple of preliminary things to get out of the way:

* There are **three general sections**:
   - :ref:`dotfilessection`
   - :ref:`setupsection`
   - :ref:`toolsection`

* **Everything is driven by** :file:`setup.sh`. When in doubt, consult that
  file.

* **Everything here is simply a convenience** to make life easier setting up
  a new machine. Since I spent the work figuring this out, I might as well make it
  available to others. For example:

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

* **All steps are optional** though there are some dependencies and assumptions
  which are noted as they come up.

.. _step0:

Step 0: Download and check
--------------------------

* Download the latest `zip file <https://github.com/daler/dotfiles/archive/master.zip>`_
* Unzip, and go to the unzipped directory, and run ``./setup.sh`` to see the help.

.. _dotfilessection:

1. Copy over dotfiles
---------------------

There are two paths to take here:

.. _option1:

.. rubric:: **Option 1: start fresh**

Do this if you're setting up a new machine, or if you've made a backup of your
files and want to try these out, or if you want the "batteries included"
experience.

To start fresh, do this to create or overwrite existing files, and then close
your terminal and reopen it to use the new configuration::

    ./setup.sh --dotfiles


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

2a: neovim
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


2b: vim/nvim plugin setup
~~~~~~~~~~~~~~~~~~~~~~~~~

The vim config included here takes advantage of many plugins. The vim ecosystem
has multiple plugin-managing tools; here we use the popular `vim-plug
<https://github.com/junegunn/vim-plug>`_. This step installs the manager and
then installs the plugins in the vim config.

.. code-block:: bash

    ./setup.sh --set-up-vim-plugins

.. details:: Details

    This sets up `vim-plug <https://github.com/junegunn/vim-plug>`_, placing the
    required files in the locations expected by vim and neovim. Then it
    automatically opens ``vim`` and installs plugins. Then it does the same with
    ``nvim``.

    This command keeps the plugin installation screen up so you can verify
    everything went OK.

    Recall that nvim config is in :file:`~/.config/nvim/init.vim`, and vim
    config is in :file:`~/.vimrc`. Here, we symlink .vimrc to init.vim so they
    share the same config.

    If you're still learning vim, remember that you can quit by hitting
    ``Esc``, then typing ``:q`` and hitting Enter.


2c: powerline fonts
~~~~~~~~~~~~~~~~~~~

In `this gif
<https://raw.githubusercontent.com/wiki/vim-airline/vim-airline/screenshots/demo.gif>`_,
you can see arrow shapes for buffers, line number glyphs, and so on. To get
these, you need a patched font, and your terminal needs to be set to use the
font.

Skip this step if you don't want those.

This only needs to be done on the machine you’re running the terminal app on.
So this does not need to be run on a remote machine.

**If you are using ITerm2**, you can skip this step and instead click
a checkbox: Preferences -> Profiles -> Text -> Use built-in powerline glyphs.
You should see the symbols then.

Otherwise, run:

.. code-block:: bash

    ./setup.sh --powerline

.. details:: Details

    This downloads patched fonts from github and makes them available as fonts
    on your system.

Once it installs, you’ll need to configure your terminal preferences to use
one of the new fonts that ends in “for Powerline”. Note that on Terminal on
Mac, you'll also need to set the font for non-ASCII characters.

.. note::

   You may get a warning about "cannot load default config file". As long as
   the new fonts show up, you should be fine.


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

