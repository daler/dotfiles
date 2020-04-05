.. _tools:

Additional tool installations
=============================

Run the ``--install-<toolname>`` for each of the tools below. Each is
installed (or symlinked) into ``~/opt/bin``, so you’ll want to make sure
that’s on your path.

``icdiff``
~~~~~~~~~~

.. code-block:: bash

    ./setup.sh --install-icdiff

`icdiff <https://www.jefftk.com/icdiff>`_ makes an easy-to-read, side-by-side
colored diff between files. It’s used for ``./setup.sh --diffs``.


``fzf``
~~~~~~~

.. code-block:: bash

    ./setup.sh --install-fzf

`fzf <https://github.com/junegunn/fzf>`_ is a fuzzy-finder interface that
works with stdin. It integrates with bash so that when you use ``Ctrl-R`` (the
standard bash way of reverse-search through history), you’ll instead get the
fzf interface.


``ripgrep`` (``rg``)
~~~~~~~~~~~~~~~~~~~~

.. code-block:: bash

    ./setup.sh --install-ripgrep

`ripgrep <https://github.com/BurntSushi/ripgrep/>`_ is a fast
code-searching tool. It is like grep, but by default skips files in
.gitignore, binary files, and hidden files.

``fd``
~~~~~~

.. code-block:: bash

    ./setup.sh --install-fd

`fd <https://github.com/sharkdp/fd>`__ is a much faster and more
ergonomic ``find``.

``visidata`` (``vd``)
~~~~~~~~~~~~~~~~~~~~~

.. code-block:: bash

    ./setup.sh --install-vd

`visidata <https://visidata.org/>`__ ia a powerful spreadsheet-like tool
for viewing, sorting, searching, and manipulating data directly in the
terminal. Any files that pandas can open, visidata can open too.

``black``
~~~~~~~~~

.. code-block:: bash

    ./setup.sh --install-black

`black <https://black.readthedocs.io>`_ reformats Python files to conform to
PEP8 style conventions.


``radian``
~~~~~~~~~~

.. code-block:: bash

    ./setup.sh --install-radian

`radian <https://github.com/randy3k/radian>`_ is a replacement shell for
R. It has syntax highlighting, multiline editings, and tab completion built in.
can be used with any version of R, in a conda environment or otherwise.

``git-cola``
~~~~~~~~~~~~

.. code-block:: bash

    ./setup.sh --install-git-cola


`git-cola <https://git-cola.github.io/>`_ is a graphical tool for
incrementally making git commits. Very useful, for example, at the end of
a coding session and you want to make atomic commits from all the changes you
made.

``bat``
~~~~~~~

.. code-block:: bash

    ./setup.sh --install-bat

`bat <https://github.com/sharkdp/bat>`_ is a replacement for ``cat``,
with syntax highlighting, line numbers, non-printable characters, and
git diffs.

``alacritty``
~~~~~~~~~~~~~

.. code-block:: bash

    ./setup.sh --install-alacritty

`alacritty <https://github.com/alacritty/alacritty>`_ is a
cross-platform GPU-accelerated terminal emulator. The speed is most
noticable when catting large files over tmux.

``jq``
~~~~~~

.. code-block:: bash

    ./setup.sh --install-jq

`jq <https://stedolan.github.io/jq/>` is like sed or awk for JSON data.


``docker``
~~~~~~~~~~

.. code-block:: bash

  ./setup.sh --install-docker

`docker <https://www.docker.com>`_ runs containers. Needs root access, and the
installation here is currently only supported on Linux.
