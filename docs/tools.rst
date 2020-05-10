.. _tools:

Additional tool installations
=============================

Run the ``--install-<toolname>`` for each of the tools below. Each is
installed (or symlinked) into ``~/opt/bin``, so you’ll want to make sure
that’s on your path.

.. note::

   Some of these tools are available in conda. In those cases, they are
   "installed" as follows:

   - create a conda environment named after the tool
   - symlink the tool's executable from the conda environment over to ~/opt/bin

   This means that you do **not** have to ``conda activate`` an environment to
   use an installed tool. As long as ~/opt/bin is on your path, you can use it
   immediately. This allows for more modular updating of the tools and avoiding
   conflicting dependencies.

``icdiff``
~~~~~~~~~~

.. code-block:: bash

    ./setup.sh --install-icdiff

`icdiff <https://www.jefftk.com/icdiff>`_ makes an easy-to-read, side-by-side
colored diff between files. It’s used for ``./setup.sh --diffs``.


Alternatives:

- ``diff``
- ``vim -d``, which I still use quite often

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

Alternatives:

- ``grep``, or ``find ... | xargs grep``
- ``ag``, the Silver Searcher

``fd``
~~~~~~

.. code-block:: bash

    ./setup.sh --install-fd

`fd <https://github.com/sharkdp/fd>`__ is a much faster and more
ergonomic ``find``.

Alternatives:

- ``find``

``visidata`` (``vd``)
~~~~~~~~~~~~~~~~~~~~~

.. code-block:: bash

    ./setup.sh --install-vd

`visidata <https://visidata.org/>`__ is a powerful spreadsheet-like tool
for viewing, sorting, searching, and manipulating data directly in the
terminal. Any files that pandas can open, visidata can open too.

Waaaaay nicer than ``less -S`` or ``vim`` followed by messing with tabstops.

Alternatives:

- tabview. Visidata can do a lot more, even though I pretty much use it along
  the same lines as tabview.
- ``less -S``
- ``vim`` followed by messing with tabstops. You'll probably need to use vim if
  you have editing to do.

``tig``
~~~~~~~

.. code-block:: bash

    ./setup.sh --install-tig

`tig <https://jonas.github.io/tig/>`_ is a terminal user interface ("TUI") for
git. It lets you browse changes and stage them in chunks. There is a bit of
a learning curve and there are a lot of features, but what I've been using the
most is the following workflow:

.. list-table::

    * - command
      - description
    * - :kbd:`s`
      - enter "status" mode
    * - up/dn arrows
      - move between *files* in the status window
    * - :kbd:`enter` (on a filename in status view)
      - show diffs in file
    * - :kbd:`j`, :kbd:`k`
      - move between *lines in the open file*
    * - :kbd:`1`
      - stage just the current line. For multiple lines, you'll need to hit
        :kbd:`1` for each one of them.
    * - :kbd:`u`
      - stage current chunk
    * - :kbd:`q`
      - quit out of window, view, and program

While there are options for commiting and other fancy things from within `tig`,
it's so fast to start and quit that I just use it for incremental staging, then
pop back out to the terminal to commit as usual.

Alternatives:

- ``vim-fugitive``, which I still fall back to for complicated situations
- ``git-cola``, but this is a GUI so not that useful for remote work
- ``lazygit`` is super powerful, but has even more of a learning curve than
  ``tig``. With so many keyboard shortcuts, I was worried I'd do something
  terrible to my git repo by accident.

``pyp``
~~~~~~~

`pyp <https://github.com/hauntsaninja/pyp>`_ lets you run Python right from the
terminal similar to Perl one-liners.

I use it most often for a quick calculator (``pyp "(4e6 / 300) * 3600"``), and
am starting to introduce it more into my workflow for arbitrary command-line
activities. It strikes a nice balance of having enough magic (e.g., implicit
variable names for lines) while still being understandable (the ``--explain``
flag is a brilliant touch).

ALternatives:

- pythonpy (no longer maintained)

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

Alternatives:

- plain vanilla R, which doesn't have the syntax highlighting or tab completion

``git-cola``
~~~~~~~~~~~~

.. code-block:: bash

    ./setup.sh --install-git-cola


`git-cola <https://git-cola.github.io/>`_ is a graphical tool for
incrementally making git commits. Very useful, for example, at the end of
a coding session and you want to make atomic commits from all the changes you
made.

Alternatives:

- tig, which I'm using more than git-cola now. It's a TUI instead of GUI.

``bat``
~~~~~~~

.. code-block:: bash

    ./setup.sh --install-bat

`bat <https://github.com/sharkdp/bat>`_ is a replacement for ``cat``,
with syntax highlighting, line numbers, non-printable characters, and
git diffs.

Alternatives:

- cat

``alacritty``
~~~~~~~~~~~~~

.. code-block:: bash

    ./setup.sh --install-alacritty

`alacritty <https://github.com/alacritty/alacritty>`_ is a
cross-platform GPU-accelerated terminal emulator. The speed is most
noticable when catting large files over tmux.

Alternatives:

- On Mac, iTerm2 or the default Terminal app
- On Linux, any number of default terminal apps


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
