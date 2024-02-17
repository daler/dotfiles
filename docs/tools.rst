.. _tools:

Additional tool installations
=============================

Base conda packages
-------------------
Do this if you want to install the conda packages in :file:`requirements.txt`
into the base conda environment. (you may want to edit that file first)

If you're on a Mac, :file:`requirements-mac.txt` will be used as well:

.. code-block:: bash

   ./setup.sh --conda-env

``apt`` packages
----------------
Do this if you want to install a large or small set of packages on an Ubuntu
machine. (you may want to edit the files mentioned below first).

If you're on Ubuntu and have root privileges, this is a quick way to install
"the works" or optionally a minimal set of packages. You can inspect the files
:file:`apt-installs.txt` or :file:`apt-installs-minimal.txt` for what will be
installed. These are packages I find to be most useful (git, build-essential,
meld, and so on).

.. code-block:: bash

    ./setup.sh --apt-install
    # or
    ./setup.sh --apt-install-minimal

Tool installation
-----------------

Run the ``--install-<toolname>`` for each of the tools below. Each is copied
into ``~/opt/bin``, so you’ll want to make sure that’s on your path.

Tools are listed alphabetically.

The help for ``setup.sh`` suggests some to start with (fzf, ripgrep, visidata,
pyp, and fd):

.. code-block:: bash

    ./setup.sh --install-fzf
    ./setup.sh --install-ripgrep
    ./setup.sh --install-vd
    ./setup.sh --install-pyp
    ./setup.sh --install-fd

.. details:: Details

   If a tool below is available in conda, it is "installed" as follows:

   - create a conda environment named after the tool (using the -n argument,
     which will place the env in your miniconda installation directory).
   - symlink the tool's executable from the conda environment over to
     :file:`~/opt/bin`

   This means that you do **not** have to :command:`conda activate` an environment to
   use an installed tool. As long as :file:`~/opt/bin` is on your path, you can
   use it immediately. This allows for more modular updating of the tools and
   avoiding conflicting dependencies.


``alacritty``
~~~~~~~~~~~~~

.. code-block:: bash

    ./setup.sh --install-alacritty

`alacritty <https://github.com/alacritty/alacritty>`_ is a
cross-platform GPU-accelerated terminal emulator. The speed is most
noticable when catting large files over tmux.

You can find more details on the benefits of alactritty at
https://jwilm.io/blog/announcing-alacritty/.

Alternatives:

- On Mac, iTerm2 or the default Terminal app
- On Linux, any number of default terminal apps


.. _bat_ref:

``bat``
~~~~~~~

.. code-block:: bash

    ./setup.sh --install-bat

`bat <https://github.com/sharkdp/bat>`_ is a replacement for ``cat``,
with syntax highlighting, line numbers, non-printable characters, and
git diffs.

Alternatives:

- cat


``bfg``
~~~~~~~

.. code-block:: bash

    ./setup.sh --install-bfg

The `BFG <https://rtyley.github.io/bfg-repo-cleaner/>`_ is a tool for cleaning
out mistakenly-committed data from git repos such as very large files or
sensitive information.

Alternatives:

- ``git-filter-branch``, which is built in to git but is slower and not as feature-rich.

``black``
~~~~~~~~~

.. code-block:: bash

    ./setup.sh --install-black

`black <https://black.readthedocs.io>`_ reformats Python files to conform to
PEP8 style conventions. I'll typically run it on a file in vim with ``!black
%`` (the ``!`` calls out to the shell, and the ``%`` means "this file".


``docker``
~~~~~~~~~~

.. code-block:: bash

  ./setup.sh --install-docker

`docker <https://www.docker.com>`_ runs containers. Needs root access, and the
installation here is currently only supported on Linux.

Alternatives:

- Singularity, though this requires a Linux machine to build and is a bit more
  involved to install.


``fd``
~~~~~~

.. code-block:: bash

    ./setup.sh --install-fd

`fd <https://github.com/sharkdp/fd>`__ is a much faster and more ergonomic
``find``. For example, it uses regular expressions by default and defaults to
skipping directories ignored by git. One place this is useful is in avoiding
lengthy, unneeded searches through conda envs.

Alternatives:

- ``find``

.. _fzf_ref:

``fzf``
~~~~~~~

.. code-block:: bash

    ./setup.sh --install-fzf

`fzf <https://github.com/junegunn/fzf>`_ is a fuzzy-finder interface that works
with stdin. It integrates with bash so that when you use ``Ctrl-R`` (the
standard bash way of reverse-search through history), you’ll instead get the
fzf interface. Other tools may also look for ``fzf`` to use as an interface.
``zoxide`` for example does this. You can also pipe in any arbitrary text to
``fzf`` for a fuzzy search tool.


``icdiff``
~~~~~~~~~~

.. code-block:: bash

    ./setup.sh --install-icdiff

`icdiff <https://www.jefftk.com/icdiff>`_ makes an easy-to-read, side-by-side
colored diff between files. It’s used for ``./setup.sh --diffs``.

Alternatives:

- ``diff``, which doesn't do side-by-side or colored diffs
- ``vim -d``, which I still use quite often

``jless``
~~~~~~~~~

.. code-block:: bash

    ./setup.sh --install-jless

`jless <https://jless.io>`_ makes it easy to inspect large JSON files. From
within the terminal you can fold large sections to get a better sense of the
structure, using vim-like keybindings.

Alternatives:

- a combination of less, grep, and text editor

``jq``
~~~~~~

.. code-block:: bash

    ./setup.sh --install-jq

`jq <https://stedolan.github.io/jq/>`_ is like sed or awk for JSON data.


``pyp``
~~~~~~~

`pyp <https://github.com/hauntsaninja/pyp>`_ lets you run Python right from the
terminal similar to Perl one-liners.

I use it most often for a quick calculator (``pyp "(4e6 / 300) * 3600"``), and
am starting to introduce it more into my workflow for arbitrary command-line
activities. It strikes a nice balance of having enough magic (e.g., implicit
variable names for lines) while still being understandable (the ``--explain``
flag is a brilliant touch).

Alternatives:

- pythonpy (no longer maintained)
- opening up a Python interpreter


``radian``
~~~~~~~~~~

.. code-block:: bash

    ./setup.sh --install-radian

`radian <https://github.com/randy3k/radian>`_ is a replacement shell for
R. It has syntax highlighting, multiline editings, and tab completion built in.
can be used with any version of R, in a conda environment or otherwise.

Note that if you are intending to use it with R and Python mixed together via
reticulate, you should not use this method to install. Instead, you'll need to
install radian in the same environment as the Python installation you plan on
using.

Alternatives:

- plain vanilla R, which doesn't have the syntax highlighting or tab completion

.. _rg:

``ripgrep`` (``rg``)
~~~~~~~~~~~~~~~~~~~~

.. code-block:: bash

    ./setup.sh --install-ripgrep

`ripgrep <https://github.com/BurntSushi/ripgrep/>`_ is a fast code-searching
tool. It is like grep, but by default skips files in .gitignore, binary files,
and hidden files.

Alternatives:

- ``grep``, or ``find ... | xargs grep``
- ``ag``, the Silver Searcher


.. _vd:

``visidata`` (``vd``)
~~~~~~~~~~~~~~~~~~~~~

.. code-block:: bash

    ./setup.sh --install-vd

`visidata <https://visidata.org/>`__ is a powerful spreadsheet-like tool for
viewing, sorting, searching, and manipulating data directly in the terminal.
Any files that pandas can open, visidata can open too.

Waaaaay nicer than ``less -S`` or ``vim`` followed by messing with tabstops.

Alternatives:

- tabview. Visidata can do a lot more, even though I pretty much use it along
  the same lines as tabview.
- ``less -S``
- ``vim`` followed by messing with tabstops. You'll probably need to use vim if
  you have a lot of editing to do.


``zoxide``
~~~~~~~~~~

.. code-block::

    ./setup.sh --install-zoxide

`zoxide <https://github.com/ajeetdsouza/zoxide>`_ is "a smarter cd command". It
keeps track of the directories you visit, and makes it easy to jump back to
them.

Note that after installation it requires an additional command to be added to
your :file:`.bashrc`.

I most commonly use its interactive mode ``zi``, which opens up :ref:`fzf_ref` as
an interface for changing directories via fuzzy search.

Alternatives:

- fasd
- autojump
- z.sh
