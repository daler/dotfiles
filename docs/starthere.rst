
.. _starthere:

Start here
==========

A couple of preliminary things to get out of the way:

* There are **three general sections**: :ref:`dotfilessection`,
  :ref:`setupsection`, and :ref:`toolsection`.

* **Everything is driven** by :file:`setup.sh`. When in doubt, consult that
  file!

* Everything here is **simply a convenience** to make my life easier setting up
  a new machine. I spent the work figuring this out, so might as well make it
  available to others. For example:

    * To avoid visiting each tool's homepage, downloading for Linux or Mac, and
      following the particular installation instructions, I can instead use the
      ``--install-<toolname>`` commands.

    * The ``--diffs`` commands help me figure out if all my dotfiles  on
      a particular machine are up-to-date with this repo.

* **All steps are optional** though there are some dependencies and assumptions
  which are noted as they come up.

.. _step0:

Step 0: Download and check the help
-----------------------------------

**Already have git installed?** Clone the repo and go to the directory:

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

.. _option1:

Option 1: Use everything
~~~~~~~~~~~~~~~~~~~~~~~~
**To replace all your existing dotfiles with the ones here**, run:

.. code-block:: bash 

    ./setup.sh --dotfiles

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
    export PATH="$HOME/miniconda3/bin:$HOME/opt/bin:$PATH"


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
you're familiar with vimdiff:

.. code-block:: bash

    # shows diffs in vimdiff
    ./setup.sh --vim-diffs

If you have :program:`meld` installed:

.. code-block:: bash

    # shows diffs in meld, if installed
    ./setup.sh --graphical-diffs



.. _setupsection:

2: setup
--------

2.1 vim
~~~~~~~

This section sets up vim (or neovim), particularly to get set up for using
plugins.

2.1.1 neovim
++++++++++++

Install `neovim <https://neovim.io/>`_, if you want to use it. See :ref:`why`
for more info on deciding.

.. code-block::

    ./setup.sh --install-neovim

This:

- installs neovim to :file:`~/opt/bin`
- adds an alias `alias vim=nvim` to :file:`~/.aliases`. If you are using
  :ref:`option2`, then you may want to manually add that alias to your
  :file:`.bashrc` or :file:`.bash_profile`.

2.1.2 vim/nvim plugin setup
+++++++++++++++++++++++++++

This step sets up `vim-plug <https://github.com/junegunn/vim-plug>`_, placing
the required files in the locations expected by vim and neovim. If you're using
:ref:`option1`, there are a lot of vim plugins included, which you can read
more about at :ref:`vim`. If you're using :ref:`option2`, then you may or may
not have any plugins configured, so you might not need this step.


- set up vim-plug:

.. code-block:: bash

    ./setup.sh --set-up-vim-plugins

-  As the command reminds you, open up vim (and/or nvim, if you installed that)
   and run :command:`:PlugInstall`. This will install the plugins configured in
   :file:`.vimrc` (for vim) or :file:`.config/nvim/init.vim` (for nvim).

2.1.3 powerline
+++++++++++++++

I really like the `vim-airline <https://github.com/vim-airline/vim-airline>`_
plugin, but it uses fancy glyphs (see the documentation for some nice demos).
Those arrow shapes for buffers, line number glyphs, and so on need a patched
font, and your terminal needs to be set to use those font.

This only needs to be done on the machine you’re running the terminal app on.
So this does not need to be run on a remote machine.

- Install the fonts with:

.. code-block:: bash

    ./setup.sh --install-powerline

- Once it installs, you’ll need to configure your terminal to use one of the
  new fonts that ends in “for Powerline”.

2.2: conda
~~~~~~~~~~


2.2.1: install miniconda
++++++++++++++++++++++++

The following command:

- downloads the latest version of `Miniconda <https://docs.conda.io/en/latest/miniconda.html>`_
- installs it to :file:`~/miniconda3`
- adds the line ``export PATH="$PATH:~/miniconda3/bin"`` to the :file:`~/.path`
  (which you can read more about at :ref:`bash`)

If you went with :ref:`option2`, you should add this to your path manually.

.. code-block:: bash

  ./setup.sh --install-miniconda

2.2.2: set up bioconda
++++++++++++++++++++++

Set up conda to use the proper channel order for `Bioconda <https://bioconda.github.io>`_:

.. code-block:: bash

   ./setup.sh --set-up-bioconda

.. _toolsection:

3: programs
-----------

3.1 install conda packages
~~~~~~~~~~~~~~~~~~~~~~~~~~

Install the packages listed in :file:`requirements.txt` into the base
environment, as well as :file:`requirements-mac.txt` if you're on a Mac:

.. code-block:: bash

   ./setup.sh --conda-env

3.2: install apt packages
~~~~~~~~~~~~~~~~~~~~~~~~~
If you're on Linux and have root privileges, this is a quick way to install
"the works" or a minimal set of packages. You can inspect the files
:file:`apt-installs.txt` or :file:`apt-installs-minimal.txt` for what will be
installed. These are packages I find to be most useful (git, build-essential,
meld, and so on).

.. code-block::

    ./setup.sh --apt-get-installs

    # or

    ./setup.sh --apt-get-installs-minimal

3.3: install other tools
~~~~~~~~~~~~~~~~~~~~~~~~

The :file:`setup.sh` script has many commands for installing various tools
I find useful. These warrant their own section, so continue to :ref:`tools` for
descriptions of tools and the commands to install them.
