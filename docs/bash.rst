.. _bash:

Bash dotfiles
=============

.. _bashrc:

``.bashrc``
-----------

At the top of ``.bashrc``, the following files are sourced if they’re present.
This keeps things a little more organized and modular:

This modular structure makes it easier to edit specific parts of the
configuration without digging through a single large file. For example if you
want to add your own aliases, edit :file:`.aliases`; for PATH changes edit
:file:`.path`.

.. code-block:: bash

  for file in ~/.{path,exports,bash_prompt,functions,aliases,extra}; do
      [ -r "$file" ] && [ -f "$file" ] && source "$file";
  done;
  unset file;

These files are described in the sections below, but a quick summary:

- :ref:`.path`: all ``export PATH=...`` can go here.
- :ref:`.aliases`: store your aliases here.
- :ref:`.functions`: store your bash functions here.
- :ref:`.bash_prompt`: edit your bash prompt here.
- :ref:`.exports`: add your various env var exports here.
- :ref:`.extra`: any machine-specific config goes here.


The modular organization for bash configuration is inspired by `this
repo <https://github.com/mathiasbynens/dotfiles>`__.

Other notable parts of the :file:`.bashrc`:

- Update terminal size after commands
- Enables `autocd` if available. When enabled, just the name of a directory
  will be sufficient to cd to it.
- Enables `globstar` if available. When enabled, the pattern ``**`` used in
  a filename expansion context will match all files and zero or more
  directories and subdirectories. If the pattern is followed by a ‘/’, only
  directories and subdirectories match.
- Enables bash completion and git completion
- Enables color support for ``ls``
- If running under tmux, always deactivate environments when creating a new
  bash shell (see :ref:`conda` for more details on this)

``.bash_profile``
-----------------

``.bash_profile`` does only one thing: it sources ``.bashrc``.

.. _path:

``.path``
---------

This file ends up being lots of ``export PATH="$PATH:/some/other/path"``
lines. It is initially populated to put ``~/opt/bin`` and
``~/miniforge/condabin`` on the path. As you install more software in other
locations, this is a tidy place to put the various exports.

.. _.aliases:

``.aliases``
------------

This file keeps aliases separate for easier maintenance. See :file:`.aliases`
for the commands set for each alias.

.. list-table::
    :header-rows: 1
    :align: left

    * - alias
      - description

    * - ``vim``
      - always use neovim (this is added only if nvim is found on the path)

    * - ``D``
      - sometimes when using tmux the display is not set, causing GUI programs
        launched from the terminal to complain. This sets the display variable.

    * - ``ll``
      - useful `ls` arguments (long format, human-readable sizes, sorted by
        time (latest at bottom), use color). MacOS has different options, so
        this alias tries to handle that correctly.

    * - ``la``
      - same as above, but also show hidden files

    * - ``v``
      - Live, searchable, syntax-highlighted preview of files in a directory.
        Needs :ref:`fzf_ref` and :ref:`bat_ref` installed

    * - ``..``
      - faster way of moving up a directory

    * - ``gsv``
      - Opens vim and runs vim-fugitive. See :ref:`vimfugitive` for details.

    * - ``glv``
      - Opens vim and runs diffview for browsing git history. See :ref:`diffview`
        for details.

    * - ``s``
      - Runs the start_agent function (see :file:`.functions` below)

    * - ``st``
    - If you connect to a host with SSH key forwarding, start a tmux session,
      and then disconnect and reconnect to the remote tmux session, the
      ``SSH_AUTH_SOCKET`` path used by tmux is stale, preventing key forwarding.
      This refreshes the path so that key forwarding works.

    * - ``git-clean-branches-master``
      - Deletes any git branches that have been merged into the master branch

    * - ``git-clean-branches-main``
      - Similar to above, but used for repos where ``main`` is the default
        branch instead of ``master``.

.. _.functions:

``.functions``
--------------

Separate file for bash functions. This is also where fzf and autojump
are set up. Some notable functions defined here:

.. list-table::
    :header-rows: 1
    :align: left

    * - function
      - description
    * - ``start_agent``
      - Use this to start the ssh agent so you don't need to keep entering your
        ssh key during a session
    * - ``tre``
      - Nicer ``tree`` output, colored and piped to less
    * - ``sa``
      - Open ``fzf`` to search across all conda environments, and activates the
        selected one
    * - ``prsetup``
      - When run in a clone of a repo with a pull request from a fork, get set up
        to push changes back to the contributor's branch

    * - ``ca``
      - Equivalent to ``conda activate``, but done in such a way that you don't
        *always* need to have conda activated. See :ref:`conda` for details.

    * - ``conda_deactivate_all``
      - Deactivate all conda environments. Useful when running under tmux; see
        :ref:`conda` for more details.

    * - ``hostlist``
      - Print out a nice table of hostnames and aliases from your
        :file:`.ssh/config` file. Useful for when you're trying to remember how
        to log in to an infrequently-accessed host.


.. _.bash_prompt:

``.bash_prompt``
----------------

This file changes the prompt color for Biowulf or Helix (NIH HPC), but
here you can add any other hosts or colors. See
https://misc.flogisoft.com/bash/tip_colors_and_formatting for color
options.

.. _.extra:

``.extra``
----------

Nothing is in here by default. This is a good place to store host-specific
details.

.. _.exports:

``.exports``
------------

Exported environment variables.

.. list-table::
    :header-rows: 1
    :align: left

    * - env var
      - value and description
    * - ``EDITOR``
      - set ``nvim`` as the default editor if it exists, otherwise use ``vim``

    * - ``LC_ALL``
      - ``en_US.UTF-8``, localization setting for US English. ``$LANG`` and
        ``$LANGUAGE`` `should also be set
        <https://www.gnu.org/software/gettext/manual/html_node/The-LANGUAGE-variable.html#The-LANGUAGE-variable>`_
        (see below)
    * - ``LC_LANG``
      - ``en_US.UTF-8``, localization setting for US English
    * - ``LC_LANGUAGE``
      - ``en_US.UTF-8``, localization setting for US English
    * - ``HISTSIZE``
      - Set a large history size
    * - ``HISTFILESIZE``
      - Same for history file
    * - ``LESS_TERMCAP_se``, ``LESS_TERMCAP_so``
      - In tmux, default is to italicize identified search terms. This
        highlights instead.
    * - ``MANGPAGER``
      - Uses ``less -X``, which does not clear the screen after exiting.
    * - ``SHELL``
      - Exports shell as ``/bin/bash`` if on Mac. See :ref:`macpostinstall` for
        details on newer Macs
