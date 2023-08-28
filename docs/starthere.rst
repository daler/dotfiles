
.. _starthere:

Start here
==========

A couple of preliminary things to get out of the way:

* There are **three general sections**:
   - :ref:`dotfilessection` for copying over the `dotfiles <https://medium.com/@webprolific/getting-started-with-dotfiles-43c3602fd789>`_ in this repo to your home directory
   - :ref:`setupsection` for setting up vim/neovim and conda
   - :ref:`toolsection` for installing useful tools

* **Everything is driven** by :file:`setup.sh`. When in doubt, consult that
  file.

* Everything here is **simply a convenience** to make life easier setting up
  a new machine. Since I spent the work figuring this out, I might as well make it
  available to others. For example:

    * There are some common fixes for things like backspace in vim not working
      in tmux, spaces instead of tabs for Python code, getting the mouse to
      work in vim and tmux, and so on.

    * To avoid visiting each tool's homepage, downloading for Linux or Mac, and
      following the particular installation instructions, you can instead use the
      ``--install-<toolname>`` commands.

    * The ``--diffs`` commands help figure out if all your dotfiles on
      a particular machine are up-to-date with this repo.

    * A centrally available resource for setup and configuration means there's
      only one place to look for updates.

* **All steps are optional** though there are some dependencies and assumptions
  which are noted as they come up.

.. _step0:

Step 0: Download and check the help
-----------------------------------

**If you already have git installed,** clone the repo and go to the directory:

.. code-block:: bash

    cd ~
    git clone https://github.com/daler/dotfiles.git
    cd dotfiles

**Don't have git installed?** Download the `zip file
<https://github.com/daler/dotfiles/archive/master.zip>`_ containing the latest
version of this repo, unzip, and go to the unzipped directory.

**To test**, run:

.. code-block::

    ./setup.sh

to see the help which includes links for each tool and a guide on what steps
can be run on what kinds of systems.

.. _dotfilessection:

1. dotfiles
-----------

There are two options, :ref:`option1` and :ref:`option2`. Choose option 1 if
you are just starting out in `BSPC <https://bioinformatics.nichd.nih.gov>`_ and
don't already have your own dotfiles, or if you want the "batteries included"
experience.

If you choose option 2, it may take some more effort since you will need to
read through the various files to figure out what to use or keep track of what
parts are needed from these dotfiles to make the subsequent installations work.
This is all documented below.

.. _option1:

Option 1: Use everything
~~~~~~~~~~~~~~~~~~~~~~~~
**To replace all your existing dotfiles with the ones here**, run:

.. code-block:: bash 

    ./setup.sh --dotfiles

This copies files over to your home directory. You should now either
close your terminal and reopen it, or source the new :file:`.bashrc` file:

.. code-block:: bash

   source ~/.bashrc

and then move to :ref:`setupsection`.

.. warning::

    This will make a backup of any existing files so you can roll back any
    changes if you don’t like anything here. This method is best when you are
    setting up a machine for the first time.

.. _option2:

Option 2: Selective usage
~~~~~~~~~~~~~~~~~~~~~~~~~
**Otherwise if you want to manually copy over the parts that you find useful**,
you'll probably want to spend some time reading through :ref:`bash`,
:ref:`vim`, and :ref:`tmux` to see what's useful. You can copy over the parts
of the relevant config files that may be useful to you.

However, you should at least put the following line in your ``.bashrc`` or
``.bash_profile``, which adds the directories into which later tools will be
installed:

.. code-block:: bash

    # add to .bashrc or .bash_profile
    export PATH="$HOME/opt/bin:$PATH"

If you've used this repo before and want to update, but aren't sure what's
changed and whether you have custom stuff that you want to keep, the setup
script provides some tools for figuring this out. For example, the
:program:`icdiff` tool shows colored, side-by-side, easy-to-read diffs. Install
it to :file:`~/opt/bin` with

.. code-block:: bash

    ./setup.sh --install-icdiff

and then use it with

.. code-block:: bash

    # shows diffs through icdiff
    ./setup.sh --diffs

There are also some other ways of viewing the diffs to decide what to add. If
you're familiar with vimdiff, this will open up diffs of all the files included
in this repo to compare to what you already have:

.. code-block:: bash

    # shows diffs in vimdiff
    ./setup.sh --vim-diffs

Alternatively you can browse the files and read the comments in them to see
what might be useful.

In any case, once you're done with your dotfiles you can move on to the next
step.

.. _setupsection:

2: setup
--------

2.1 vim
~~~~~~~

This section sets up vim (or neovim), particularly to get set up for using
plugins.

2.1.1 neovim
++++++++++++

Do this if you want to use `neovim <https://neovim.io/>`_. See
:ref:`why` for more help on deciding.

.. code-block::

    ./setup.sh --install-neovim

This:

- installs neovim to :file:`~/opt/bin`
- so that `nvim` will run when you type `vim`, this adds an alias `alias
  vim=nvim` to :file:`~/.aliases`. As described in :ref:`bash`, this is sourced
  each time you start a new shell. If you are using :ref:`option2` and you are
  not using the module approach of separate files,  then you may want to
  manually add that alias to your :file:`.bashrc` or :file:`.bash_profile`.


2.1.2 vim/nvim plugin setup
+++++++++++++++++++++++++++

Do this if you want to use all the plugins in the ``.config/nvim/init.vim``
file or if you want to set up vim-plug at all for any plugins. If you're going
with :ref:`option1` then you should do this.

This step sets up `vim-plug <https://github.com/junegunn/vim-plug>`_, placing
the required files in the locations expected by vim and neovim. There are a lot
of vim plugins included, which you can read more about at :ref:`vim`. If you're
using :ref:`option2`, this step is useful if you have plugins managed by
vim-plug.

- set up vim-plug:

.. code-block:: bash

    ./setup.sh --set-up-vim-plugins

-  As the command reminds you, open up vim (and/or nvim, if you installed that)
   and run :command:`:PlugInstall`. This will install the plugins configured in
   :file:`.vimrc` (for vim) or :file:`.config/nvim/init.vim` (for nvim).

2.1.3 powerline
+++++++++++++++

Do this if you want the fancy `vim-airline
<https://github.com/vim-airline/vim-airline>`_ status bar in vim; these are
special fonts to make that work.

The vim-airline plugin uses fancy glyphs (see the documentation for some nice
demos). Those arrow shapes for buffers, line number glyphs, and so on need
a patched font, and your terminal needs to be set to use those font.

This only needs to be done on the machine you’re running the terminal app on.
So this does not need to be run on a remote machine.

- Install the fonts with:

.. code-block:: bash

    ./setup.sh --powerline

.. note::

   You may get a warning about "cannot load default config file". As long as
   the new fonts show up, you should be fine.

.. note::

    Once it installs, you’ll need to configure your terminal preferences to use
    one of the new fonts that ends in “for Powerline”. Note that on Terminal on
    Mac, you'll also need to set the font for non-ASCII characters.

2.2: conda
~~~~~~~~~~

`conda <https://docs.conda.io/en/latest/>`_ is a cross-platform,
language-agnostic package manager. It's by far the best way to get set up with
Python, but it also works for many other languages.

2.2.1: Install conda
++++++++++++++++++++

Do this if you want to use conda to create environments that are
isolated from the rest of your system.

The following command:

- downloads the latest version of `Mambaforge
  <https://github.com/conda-forge/miniforge>`_
- installs conda and mamba to :file:`~/mambaforge/condabin/conda` and :file:`~/mambaforge/condabin/mamba`, or if you're on NIH's Biowulf cluster
  where the home directory is too small to support the installation, it will
  install to :file:`/data/$USER/mambaforge/condabin`
- adds the line ``export PATH="$PATH:~/mambaforge/condabin"`` to the :file:`~/.path`
  (which you can read more about at :ref:`bash`)

If you went with :ref:`option2`, you should add this to your path manually.

.. code-block:: bash

  ./setup.sh --install-conda

After installation, run the following:

.. code-block:: bash

   conda init bash

to allow the use of ``conda activate`` to activate environments.

2.2.2: set up bioconda
++++++++++++++++++++++

Do this if you want to use `Bioconda <https://bioconda.github.io>`_ and you
have installed conda (see above). It sets up the channels in the proper order
as recommended by the bioconda docs.

.. code-block:: bash

   ./setup.sh --set-up-bioconda

.. _toolsection:

3: programs
-----------

This section (and the following :ref:`tools`) contains quick ways of getting
useful stuff installed. This is my opinionated list of what I like to have
installed, so you should check the files referenced and edit them as you see
fit to match your requirements.

3.1 install conda packages
~~~~~~~~~~~~~~~~~~~~~~~~~~
Do this if you want to install the conda packages in :file:`requirements.txt`
into the base conda environment. (you may want to edit that file first)

If you're on a Mac, :file:`requirements-mac.txt` will be used as well:

.. code-block:: bash

   ./setup.sh --conda-env

3.2: install apt packages
~~~~~~~~~~~~~~~~~~~~~~~~~
Do this if you want to install a large or small set of package for Linux (you
may want to edit the files mentioned below first).

If you're on Linux and have root privileges, this is a quick way to install
"the works" or optionally a minimal set of packages. You can inspect the files
:file:`apt-installs.txt` or :file:`apt-installs-minimal.txt` for what will be
installed. These are packages I find to be most useful (git, build-essential,
meld, and so on).

.. code-block::

    ./setup.sh --apt-install

    # or

    ./setup.sh --apt-install-minimal

3.3: install other tools
~~~~~~~~~~~~~~~~~~~~~~~~

The :file:`setup.sh` script has many commands for installing various tools
I find useful. These warrant their own section, so **continue to** :ref:`tools` for
descriptions of tools and the commands to install them.
